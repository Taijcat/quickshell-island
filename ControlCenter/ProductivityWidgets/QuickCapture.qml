import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
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
  property string textToJournal: ""
  property string echoCommand: "echo '" + textToJournal + "' >> " + Metrics.journalPath + journalName()
  property string touchCommand: "touch " + Metrics.journalPath + journalName()

  property date today: new Date()
  function journalName() {
    let day = (today.getDate() < 10) ? ("0" + today.getDate()) : (today.getDate())
    let month = ((today.getMonth() + 1) < 10) ? ("0" + (today.getMonth() + 1)) : (today.getMonth() + 1)

    return today.getFullYear() + "-" + month + "-" + day + ".md"
  }

  Behavior on color {
    ColorAnimation {duration: Metrics.animationLength}
  }

  MouseArea{
    anchors.fill: parent
    id: mouseArea
    hoverEnabled: true
  }

  SystemClock { id: clock; precision: SystemClock.Minutes }


  function pushToJournal(text) {
    procTouchJournal.running = true
    textToJournal = "\n" + Qt.formatDateTime(clock.date, "hh:mm") + ":\n" + text
    procPushToJournal.running = true
  }

  Process {
    id: procPushToJournal
    command: ["sh", "-c", echoCommand]
    onExited: procCopy.running = true
  }

  Process {
    id: procTouchJournal
    command: ["sh", "-c", touchCommand]
    onExited: procCopy.running = true
  }



  Process {
    id: procCopy
    command: ["wl-copy", textToJournal]
  }

  TextField{
    anchors.fill: parent
    anchors.margins: Metrics.edgePadding
    placeholderText: qsTr("Type away...")
    wrapMode: TextEdit.Wrap
    onAccepted: {
      pushToJournal(text)
      text = ""
    }

    font{
      family: Metrics.textFont
      pixelSize: Metrics.textSize / Metrics.textSizeMult
    }

    background: Rectangle{
      color: "transparent"; border.color: "transparent"
    }

  }
}
