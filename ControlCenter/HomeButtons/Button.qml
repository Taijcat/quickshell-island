import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../../Config"

// Boilerplate code for a button. For use in debugging and writing actually good buttons.
Rectangle {
  property bool isOn: false
  property bool isActive: false

  property string buttonColor: {
    if (!isActive) { return mouseArea.containsMouse ? Colors.overlay : Colors.surface }
    if (!isOn) { return mouseArea.containsMouse ? Colors.overlay : Colors.surface }
    if (isOn) { return mouseArea.containsMouse ? Colors.hint : Colors.accent }
  }

  property string borderColor: {
    if (!isActive) { return mouseArea.containsMouse ? Colors.error : Colors.border }
    if (!isOn) { return mouseArea.containsMouse ? Colors.accent : Colors.border }
    if (isOn) { return mouseArea.containsMouse ? Colors.hint : Colors.accent }
  }

  property string iconColor: {
    if (!isActive) { return Colors.text }
    if (!isOn) { return Colors.text }
    if (isOn) { return Colors.surface }
  }

  property string icon: {
    if (!isActive) { return String.fromCodePoint(0xf13f1) }
    if (!isOn) { return String.fromCodePoint(0xf13f2) }
    if (isOn) { return String.fromCodePoint(0xf184a) }
  }

  Process {
    id: menuLaunch
    command: ["kitty"]
  }

  Layout.preferredWidth: 56
  Layout.preferredHeight: 56
  antialiasing: true
  radius: Metrics.roundingRadius
  color: buttonColor
  border.color: borderColor

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
    onClicked: (mouse) => {
      if (mouse.button == Qt.LeftButton) { isActive = !isActive }
      if (mouse.button == Qt.RightButton) { isOn = !isOn }
      if (mouse.button == Qt.MiddleButton) { menuLaunch.running = true }
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
    ColorAnimation {duration: Metrics.animationLength}
  }
}
