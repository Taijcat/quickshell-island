import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth
import "../../Config/"

Rectangle {
  Layout.preferredWidth: 56
  Layout.preferredHeight: 56
  antialiasing: true
  radius: Metrics.roundingRadius
  color: buttonColor
  border.color: borderColor

  property string buttonColor: {
    if (!bluetoothAdapter.enabled) { return mouseArea.containsMouse ? Colors.overlay : Colors.surface }
    if (!connectedDevice) { return mouseArea.containsMouse ? Colors.overlay : Colors.surface }
    if (connectedDevice) { return mouseArea.containsMouse ? Colors.hint : Colors.accent }
  }

  property string borderColor: {
    if (!bluetoothAdapter.enabled) { return mouseArea.containsMouse ? Colors.error : Colors.border }
    if (!connectedDevice) { return mouseArea.containsMouse ? Colors.accent : Colors.border }
    if (connectedDevice) { return mouseArea.containsMouse ? Colors.hint : Colors.accent }
  }

  property string iconColor: {
    if (!bluetoothAdapter.enabled) { return Colors.text }
    if (!connectedDevice) { return Colors.text }
    if (connectedDevice) { return Colors.surface }
  }

  property string icon: {
    if (!bluetoothAdapter.enabled) { return String.fromCodePoint(0xf00b2) }
    if (!connectedDevice) { return String.fromCodePoint(0xf00af) }
    if (connectedDevice) { return String.fromCodePoint(0xf00b1) }
  }

  // Bluetooth Logic
  readonly property var bluetoothAdapter: Bluetooth.defaultAdapter
  readonly property var connectedDevice: bluetoothAdapter
  ? bluetoothAdapter.devices.values.find(d => d.connected)
  : null

  //Button Logic
  Process {
    id: bluetuiLaunch
    command: ["kitty", "bluetui"]
  }

  Process {
    id:rfkillToggle
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
    onClicked: (mouse) => {
      if (mouse.button == Qt.MiddleButton) { bluetuiLaunch.running = true }
      if (mouse.button == Qt.RightButton) { 
        connectedDevice ? console.log("True") : console.log("False")
      }
      if (mouse.button == Qt.LeftButton) { 
        rfkillToggle.command = bluetoothAdapter.enabled ? ["rfkill", "block", "bluetooth"] : ["rfkill", "unblock", "bluetooth"]
        rfkillToggle.running = true
      }
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
