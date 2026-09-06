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
  color: isOn ? (mouseArea.containsMouse ? Colors.hint : Colors.accent) : (mouseArea.containsMouse ? Colors.overlay : Colors.surface)
  border.color: isOn ? (mouseArea.containsMouse ? Colors.hint : Colors.accent) : (mouseArea.containsMouse ? Colors.accent : Colors.border)
  property bool isOn: false
  property int icon: isOn ? 0xf0a91 : 0xf009c

  Process {
    id: getDNDState
    command: ["noctalia", "msg", "notification-dnd-status"]
    stdout: StdioCollector{
      onStreamFinished: isOn = (text === "on\n")
    }
  }

  Process {
    id: toggleDNDState
    command: ["noctalia", "msg", "notification-dnd-toggle"]
    onExited: getDNDState.running = true
  }

  Timer {
    interval: 10000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      getDNDState.running = true
    }
  }

  Behavior on color {
    ColorAnimation {duration: Metrics.animationLength}
  }

  MouseArea{
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    onClicked: {
      toggleDNDState.running = true
    }
  }

  Text {
    anchors.centerIn: parent
    text: String.fromCodePoint(icon)
    color: isOn ? Colors.accentText : Colors.text
    font{
      family: Metrics.iconFont
      pixelSize: Metrics.iconSize
    }
  }
}
