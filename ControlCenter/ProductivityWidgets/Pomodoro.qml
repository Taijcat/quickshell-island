import Quickshell.Io
import QtQuick
import QtQuick.Shapes
import "../../Config"

Rectangle{
  id: root
  required property int spanW
  required property int spanH
  radius: Metrics.roundingRadius
  implicitWidth: Functions.spanToWidth(spanW)
  implicitHeight: Functions.spanToHeight(spanH)
  color: mouseArea.containsMouse? Colors.overlay : Colors.surface
  border.color: mouseArea.containsMouse ? Colors.accent : Colors.border

  property int workSeconds: Metrics.pomodoroWorkSeconds
  property int restSeconds: Metrics.pomodoroRestSeconds
  property real workSecondsRemaining: workSeconds
  property real restSecondsRemaining: restSeconds
  property int ringThickness: 5
  property real sweepAngle: 0
  property string ringColor: Colors.accent
  property string shownTimer: parseTime(workSeconds)

  Behavior on color {
    ColorAnimation {duration: Metrics.animationLength}
  }

  Behavior on sweepAngle {
    NumberAnimation {duration: 500}
  }

  function pauseCurrentTimer() {
    if (workSeconds != workSecondsRemaining) {countdownWork.running = false}
    if (restSeconds != restSecondsRemaining) {countdownRest.running = false}
  }

  function isTimerRunning() {
    return !((countdownWork.running === false) && (countdownRest.running === false))
  }

  function isTimerActive() {
    return ((workSeconds != workSecondsRemaining) && (restSeconds != restSecondsRemaining))
  }

  function startWorkTimer() {
    shownTimer = parseTime(workSecondsRemaining)
    countdownWork.running = true
  }

  function unpauseCurrentTimer() {
    if (workSeconds != workSecondsRemaining) {countdownWork.running = true}
    if (restSeconds != restSecondsRemaining) {countdownRest.running = true}
  }

  function resetTimer() {
    workSecondsRemaining = workSeconds
    restSecondsRemaining = restSeconds
    countdownWork.running = false
    countdownRest.running = false
    shownTimer = parseTime(workSeconds)
    sweepAngle = 0
  }


  Process {
    id: procSendNotificationWork
    command: ["notify-send", "Pomodoro Timer", "Work timer elapsed"]
  }

  Process {
    id: procSendNotificationRest
    command: ["notify-send", "Pomodoro Timer", "Rest timer elapsed"]
  }

  Process {
    id: procSFX
    command: [Metrics.audioPlayer, Metrics.timerCompletionSoundPath]
  }

  MouseArea{
    anchors.fill: parent
    id: mouseArea
    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: (mouse) => {
      if (mouse.button == Qt.LeftButton) {isTimerRunning() ? pauseCurrentTimer() : isTimerActive() ? unpauseCurrentTimer() : startWorkTimer()}
      if (mouse.button == Qt.RightButton) {isTimerRunning() ? pauseCurrentTimer() : resetTimer()}
    }
  }

  function parseTime(timeSeconds) {
    timeSeconds = parseInt(timeSeconds.toFixed(0))
    let seconds = timeSeconds % 60
    let minutes = (timeSeconds - seconds) / 60 ?? "00"

    if (seconds < 10) {seconds = "0" + seconds}
    if (minutes < 10) {minutes = "0" + minutes}

    return minutes + ":" + seconds
  }


  Timer {
    id: countdownWork
    interval: 500
    repeat: true
    running: false
    onTriggered: {
      if (root.workSecondsRemaining > 0) {
        root.workSecondsRemaining = root.workSecondsRemaining - 0.5
        root.sweepAngle = ((root.workSeconds - root.workSecondsRemaining) / root.workSeconds) * 360
        shownTimer = parseTime(workSecondsRemaining)
      } else {
        root.finishedWork()
      }
    }
  }

  Timer{
    id: countdownRest
    interval: 500
    repeat: true
    running: false
    onTriggered: {
      if (root.restSecondsRemaining > 0) {
        root.restSecondsRemaining = root.restSecondsRemaining - 0.5
        root.sweepAngle = (root.restSecondsRemaining / root.restSeconds) * 360
        shownTimer = parseTime(restSecondsRemaining)
      } else {
        root.finishedRest()
      }
    }
  }


  signal finishedWork()
  signal finishedRest()
  onFinishedWork: {
    workSecondsRemaining = workSeconds
    countdownWork.running = false
    countdownRest.running = true
    shownTimer = parseTime(restSecondsRemaining)
    ringColor = Colors.green
    procSendNotificationWork.running = true
    procSFX.running = true
  }

  onFinishedRest: {
    restSecondsRemaining = restSeconds
    countdownRest.running = false
    shownTimer = parseTime(0)
    ringColor = Colors.accent
    procSendNotificationRest.running = true
    procSFX.running = true
  }

  Text{
    anchors.centerIn: parent
    text: shownTimer
    color: "white"

    font {
      family: Metrics.numberFont
      pixelSize: Metrics.iconSize
    }
  }

  Shape {
    id: ringShape
    anchors.centerIn: parent
    implicitHeight: root.height - Metrics.edgePadding * 2
    implicitWidth: root.width - Metrics.edgePadding * 2
    preferredRendererType: Shape.CurveRenderer


    ShapePath {
      id: background
      strokeColor: Colors.base
      strokeWidth: root.ringThickness
      fillColor: "transparent"
      capStyle: ShapePath.RoundCap

      PathAngleArc {
        centerX: ringShape.width / 2
        centerY: ringShape.height / 2
        radiusX: (ringShape.width - root.ringThickness) / 2
        radiusY: (ringShape.height - root.ringThickness) / 2
        startAngle: 0
        sweepAngle: 360
      }
    }

    ShapePath {
      id: timerBar
      strokeColor: root.ringColor
      strokeWidth: root.ringThickness
      fillColor: "transparent"
      capStyle: ShapePath.RoundCap

      PathAngleArc {
        centerX: ringShape.width / 2
        centerY: ringShape.height / 2
        radiusX: (ringShape.width - root.ringThickness) / 2
        radiusY: (ringShape.height - root.ringThickness) / 2
        startAngle: 270
        sweepAngle: root.sweepAngle
      }
    }
  }
}
