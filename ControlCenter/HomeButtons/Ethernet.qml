import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Networking
import "../../Style"

// Boilerplate code for a button. For use in debugging and writing actually good buttons.
Rectangle {
  // Boilerplate
  Layout.preferredWidth: 56
  Layout.preferredHeight: 56
  antialiasing: true
  radius: Metrics.roundingRadius
  color: buttonColor
  border.color: borderColor

  // Network stuff
  readonly property var wiredDevice: Networking.devices.values.find(d => d.type === DeviceType.Wired)
  readonly property bool wiredActive: wiredDevice.connected
  readonly property var wiredState: parseInt(wiredDevice.state.toString())

  // Button stuff
  property string buttonColor: {
      switch (wiredState) {
        case 0: return mouseArea.containsMouse ? Colors.error : Colors.surface // Unknown (Not plugged in).
        case 1: return mouseArea.containsMouse ? Colors.hint : Colors.success // Connecting
        case 2: return mouseArea.containsMouse ? Colors.hint : Colors.accent // Connected
        case 3: return mouseArea.containsMouse ? Colors.hint : Colors.info // Disconnecting
        case 4: return mouseArea.containsMouse ? Colors.hint : Colors.surface // Disconnected
      }
  }

  property string borderColor: {
    switch (wiredState) {
      case 0: return mouseArea.containsMouse ? Colors.error : Colors.border // Unknown (Not plugged in).
      case 1: return mouseArea.containsMouse ? Colors.hint : Colors.success // Connecting
      case 2: return mouseArea.containsMouse ? Colors.hint : Colors.accent // Connected
      case 3: return mouseArea.containsMouse ? Colors.hint : Colors.info // Disconnecting
      case 4: return mouseArea.containsMouse ? Colors.accent : Colors.border // Disconnected
    }
  }

  property string iconColor: {
    switch (wiredState) {
      case 0: return mouseArea.containsMouse ? Colors.surface : Colors.text // Unknown (Not plugged in).
      case 1: return mouseArea.containsMouse ? Colors.surface : Colors.surface // Connecting
      case 2: return mouseArea.containsMouse ? Colors.surface : Colors.surface // Connected
      case 3: return mouseArea.containsMouse ? Colors.surface : Colors.surface // Disconnecting
      case 4: return mouseArea.containsMouse ? Colors.surface : Colors.text // Disconnected
    }
  }

  Text {
    text: String.fromCodePoint("0xF0200")
    color: iconColor
    anchors.centerIn: parent
    font {
      family: "JetBrainsMono Nerd Font Propo"
      pixelSize: 20
    }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    onClicked: {
      wiredActive ? (wiredDevice.network.disconnect()) : (wiredDevice.autoreconnect = true , wiredDevice.network.connect())
    }
  }

  Behavior on color {
    ColorAnimation {duration: Metrics.animationLength}
  }
}
