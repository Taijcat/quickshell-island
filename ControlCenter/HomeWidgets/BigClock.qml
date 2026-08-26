import Quickshell
import QtQuick
import QtQuick.Layouts
import "../../Config"

Rectangle{
  id: root

  required property int spanH
  required property int spanW
  implicitWidth: Functions.spanToWidth(spanW)
  implicitHeight: Functions.spanToHeight(spanH)

  color: mouseArea.containsMouse ? Colors.overlay : Colors.surface
  border.color: isRunning ? Colors.success : mouseArea.containsMouse ? Colors.accent : Colors.border
  radius: Metrics.roundingRadius

  SystemClock { id: clock; precision: SystemClock.Seconds }

  property bool isRunning: false
  property bool isUpdating: false
  property bool isStopwatch: false
  property real elapsedMs: 0      // total accumulated elapsed time
  property real displayMs: 0
  property real startEpoch: 0     // Date.now() when (re)started

  function currentElapsed() {
    return isRunning ? elapsedMs + (Date.now() - startEpoch) : elapsedMs
  }

  function toggleRunning() {
    if (isRunning) {
      elapsedMs += Date.now() - startEpoch
      isRunning = false
      isUpdating = false
    } else {
      startEpoch = Date.now()
      isRunning = true
      isUpdating = true
    }
  }

  function reset() {
    isRunning = false
    isUpdating = false
    elapsedMs = 0
    displayMs = 0
  }

  function toggleLap() {
    if(isUpdating == true && isRunning == true) {
      isUpdating = false
      return
    }

    if(isUpdating == false && isRunning == true) {
      isUpdating = true
      return
    }
  }

  Timer {
    interval: 30
    running: isUpdating
    repeat: true
    onTriggered: displayMs = currentElapsed()
  }

  function formatTop(timeMs) {
    if (timeMs < 3600000) {
      var timeMin = Math.trunc(timeMs/60000)
      return (timeMin < 10 ? "0" + timeMin : timeMin)
    }

    var timeHour = Math.trunc(timeMs / 3600000)
    return (timeHour < 10 ? "0" + timeHour : timeHour)
  }

  function formatMiddle(timeMs) {
    if (timeMs < 3600000) {
      var timeSec = Math.trunc((timeMs % 60000)/1000)
      return (timeSec < 10 ? "0" + timeSec : timeSec)
    }

    var timeMin = Math.trunc((timeMs % 3600000)/60000)
    return (timeMin < 10 ? "0" + timeMin : timeMin)
  }

  function formatBottom(timeMs) {
    if (timeMs < 3600000) {
      var timeCenti = Math.trunc((timeMs % 1000)/ 10)
      return (timeCenti < 10 ? "0" + timeCenti : timeCenti)
    }
  }


  property string topText: isStopwatch ? formatTop(displayMs) : Qt.formatDateTime(clock.date, "hh")
  property string middleText: isStopwatch ? formatMiddle(displayMs) : Qt.formatDateTime(clock.date, "mm")
  property string bottomText: isStopwatch ? formatBottom(displayMs) : Qt.formatDateTime(clock.date, "ss")

  MouseArea{
    id: mouseArea
    hoverEnabled: true
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
    onClicked: (mouse)=>{
      if (mouse.button == Qt.LeftButton) {isStopwatch ?  root.toggleRunning() : isStopwatch = true}
      if (mouse.button == Qt.MiddleButton) { isStopwatch = !isStopwatch }
      if (mouse.button == Qt.RightButton) {root.isRunning ? root.toggleLap() : root.reset()}
    }
  }


  ColumnLayout{
    id: content
    anchors.centerIn: parent
    spacing: -5

   Text{
      text: topText
      color: Colors.text
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignHCenter
      horizontalAlignment: Text.AlignHCenter
      font {
        family: "Google Sans Flex"
        pixelSize: Metrics.iconSize
        weight: Metrics.fontBold
        features: { "tnum": 1 }
      }
    }
    Text{
      text: middleText
      color: Colors.text
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignHCenter
      horizontalAlignment: Text.AlignHCenter
      font {
        family: "Google Sans Flex"
        pixelSize: Metrics.iconSize
        weight: Metrics.fontBold
        features: { "tnum": 1 }
      }
    }
    Text{
      text: bottomText
      color: Colors.textFaint
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignHCenter
      horizontalAlignment: Text.AlignHCenter
      Layout.topMargin: 8
      font {
        family: "Google Sans Flex"
        pixelSize: Metrics.textSize
      }
    }
  }

  Behavior on color {
    ColorAnimation {duration: Metrics.animationLength}
  }
}
