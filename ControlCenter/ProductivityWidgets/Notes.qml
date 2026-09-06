import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Effects
import "../../Config"

Rectangle{
  id: root
  implicitWidth: Metrics.buttonWidth
  implicitHeight: Metrics.buttonHeight
  radius: Metrics.roundingRadius
  color: mouseArea.containsMouse? Colors.overlay : Colors.surface
  border.color: mouseArea.containsMouse ? Colors.accent : Colors.border

  property string launchCommand: Metrics.terminal + " " + Metrics.editor + " " + Metrics.notesPath

  Process {
    id: launchEditor
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

  MouseArea{
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    onClicked: {
      launchEditor.running = true
      flash.start()
    }
  }

  Text {
    anchors.centerIn: parent
    text: String.fromCodePoint(0xf125f)
    color: Colors.text
    font{
      family: Metrics.iconFont
      pixelSize: Metrics.iconSize
    }
  }
}
