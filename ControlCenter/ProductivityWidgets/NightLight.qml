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
  property int icon: isOn ? 0xf0594 : 0xe30d

  Process {
    id: toggleNightLight
    command: ["noctalia", "msg", "nightlight-force-toggle"]
  }

  Behavior on color {
    ColorAnimation {duration: Metrics.animationLength}
  }

  MouseArea{
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    onClicked: {
      toggleNightLight.running = true
      isOn = !isOn
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
