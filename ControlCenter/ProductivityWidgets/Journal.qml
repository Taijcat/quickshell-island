import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Effects
import "../../Config"

Rectangle{
  id: root
  radius: Metrics.roundingRadius
  implicitWidth: Metrics.buttonWidth
  implicitHeight: Metrics.buttonHeight
  color: mouseArea.containsMouse? Colors.overlay : Colors.surface
  border.color: mouseArea.containsMouse ? Colors.accent : Colors.border
  property string launchCommand: Metrics.terminal + " " + Metrics.editor + " " + Metrics.journalPath + journalName()

  Process {
    id: launchJournal
    command: ["sh", "-c", launchCommand]
  }

  Behavior on color {
    ColorAnimation {duration: Metrics.animationLength}
  }

  SequentialAnimation {
    id: flash
    ColorAnimation { target: root; property: "color"; to: Colors.accent; duration: Metrics.animationLength }
    ColorAnimation { target: root; property: "color"; to: Colors.surface; duration: Metrics.animationLength }
  }

  property date today: new Date()
  function journalName() {
    let day = (today.getDate() < 10) ? ("0" + today.getDate()) : (today.getDate())
    let month = ((today.getMonth() + 1) < 10) ? ("0" + (today.getMonth() + 1)) : (today.getMonth() + 1)

    return today.getFullYear() + "-" + month + "-" + day + ".md"
  }

  MouseArea{
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    onClicked: {
      launchJournal.running = true
      flash.start()
    }
  }

  Text {
    anchors.centerIn: parent
    text: String.fromCodePoint(0xf0ebf)
    color: Colors.text
    font{
      family: Metrics.iconFont
      pixelSize: Metrics.iconSize
    }
  }
}
