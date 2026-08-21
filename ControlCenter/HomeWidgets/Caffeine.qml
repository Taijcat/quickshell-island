import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../../Config"

Rectangle {
  id: root
  property bool isOn: false

  property string buttonColor: isOn ? (mouseArea.containsMouse ? Colors.hint : Colors.accent) : (mouseArea.containsMouse ? Colors.overlay : Colors.surface)
  property string borderColor: isOn ? (mouseArea.containsMouse ? Colors.hint : Colors.accent) : (mouseArea.containsMouse ? Colors.accent : Colors.border)
  property string iconColor: isOn ? Colors.surface : Colors.text
  property string icon: isOn ? String.fromCodePoint(0xf0176) : String.fromCodePoint(0xf06ca)

  Layout.preferredWidth: 56
  Layout.preferredHeight: 56
  antialiasing: true
  radius: Metrics.roundingRadius
  color: buttonColor
  border.color: borderColor

  Process {
    id: caffeine
    command: ["systemd-inhibit", "--what=idle", "--who=quickshell", "--why=caffeine button", "--mode=block", "sleep", "infinity"]
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    onClicked: {
      root.isOn = !root.isOn
      caffeine.running = root.isOn
    }
  }

  Text {
    text: icon
    color: iconColor
    anchors.centerIn: parent
    font {
      family: "JetBrainsMono Nerd Font Propo"
      pixelSize: Metrics.iconSize
    }
  }

  Behavior on color {
    ColorAnimation { duration: Metrics.animationLength }
  }
}
