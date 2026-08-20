import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Quickshell.Networking
import "../../Config/"

// Boilerplate code for a button. For use in debugging and writing actually good buttons.
Rectangle {
  // Boilerplate
  Layout.preferredWidth: 56
  Layout.preferredHeight: 56
  antialiasing: true
  radius: Metrics.roundingRadius
  color: buttonColor
  border.color: borderColor

  // Color stuff
  property string buttonColor: {
      switch (wiredState) {
        case 0: return mouseArea.containsMouse ? Colors.overlay : Colors.surface // Unknown (Not plugged in)
        case 1: return mouseArea.containsMouse ? Colors.hint : Colors.success // Connecting
        case 2: return mouseArea.containsMouse ? Colors.hint : Colors.accent // Connected
        case 3: return mouseArea.containsMouse ? Colors.hint : Colors.info // Disconnecting
        case 4: return mouseArea.containsMouse ? Colors.overlay : Colors.surface // Disconnected
      }
  }

  property string borderColor: {
    switch (wiredState) {
      case 0: return mouseArea.containsMouse ? Colors.error : Colors.border // Unknown (Not plugged in)
      case 1: return mouseArea.containsMouse ? Colors.hint : Colors.success // Connecting
      case 2: return mouseArea.containsMouse ? Colors.hint : Colors.accent // Connected
      case 3: return mouseArea.containsMouse ? Colors.hint : Colors.info // Disconnecting
      case 4: return mouseArea.containsMouse ? Colors.accent : Colors.border // Disconnected
    }
  }

  property string iconColor: {
    switch (wiredState) {
      case 0: return mouseArea.containsMouse ? Colors.text : Colors.text // Unknown (Not plugged in)
      case 1: return mouseArea.containsMouse ? Colors.surface : Colors.surface // Connecting
      case 2: return mouseArea.containsMouse ? Colors.surface : Colors.surface // Connected
      case 3: return mouseArea.containsMouse ? Colors.surface : Colors.surface // Disconnecting
      case 4: return mouseArea.containsMouse ? Colors.text : Colors.text // Disconnected
    }
  }


  // Network stuff
  readonly property var wiredDevice: Networking.devices.values.find(d => d.type === DeviceType.Wired)
  readonly property bool wiredActive: wiredDevice.connected
  readonly property var wiredState: wiredActive ? parseInt(wiredDevice.state.toString()) : 0

  Process {
    id:nmtuiLaunch
    command: ["kitty", "nmtui"]
  }


  // Button stuff
  Text {
    text: String.fromCodePoint("0xF0200")
    color: iconColor
    anchors.centerIn: parent
    font {
      family: "JetBrainsMono Nerd Font Propo"
      pixelSize: Metrics.iconSize
    }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.MiddleButton
    onClicked: (mouse) => {
      if (mouse.button == Qt.MiddleButton) { nmtuiLaunch.running = true }
      if (mouse.button == Qt.LeftButton && wiredDevice) {
        wiredActive ? (wiredDevice.network.disconnect()) : (wiredDevice.autoreconnect = true , wiredDevice.network.connect())
      }
    }
  }



  Behavior on color {
    ColorAnimation {duration: Metrics.animationLength}
  }
}
