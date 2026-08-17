import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Quickshell.Networking
import "../../Config/"

// Boilerplate code for a button. For use in debugging and writing actually good buttons.
Rectangle {
  // Boilerplate
  Layout.preferredWidth: Metrics.buttonWidth
  Layout.preferredHeight: Metrics.buttonHeight
  antialiasing: true
  radius: Metrics.roundingRadius
  color: buttonColor
  border.color: borderColor


  // Color stuff
  property string buttonColor: {
    switch (wifiState) {
      case 0: return mouseArea.containsMouse ? Colors.overlay : Colors.surface // Unknown (Not plugged in)
      case 1: return mouseArea.containsMouse ? Colors.hint : Colors.success // Connecting
      case 2: return mouseArea.containsMouse ? Colors.hint : Colors.accent // Connected
      case 3: return mouseArea.containsMouse ? Colors.hint : Colors.info // Disconnecting
      case 4: return mouseArea.containsMouse ? Colors.overlay : Colors.surface // Disconnected
    }
  }

  property string borderColor: {
    switch (wifiState) {
      case 0: return mouseArea.containsMouse ? Colors.error : Colors.border // Unknown (Not plugged in)
      case 1: return mouseArea.containsMouse ? Colors.hint : Colors.success // Connecting
      case 2: return mouseArea.containsMouse ? Colors.hint : Colors.accent // Connected
      case 3: return mouseArea.containsMouse ? Colors.hint : Colors.info // Disconnecting
      case 4: return mouseArea.containsMouse ? Colors.accent : Colors.border // Disconnected
    }
  }

  property string iconColor: {
    switch (wifiState) {
      case 0: return mouseArea.containsMouse ? Colors.text : Colors.text // Unknown (Not plugged in)
      case 1: return mouseArea.containsMouse ? Colors.surface : Colors.surface // Connecting
      case 2: return mouseArea.containsMouse ? Colors.surface : Colors.surface // Connected
      case 3: return mouseArea.containsMouse ? Colors.surface : Colors.surface // Disconnecting
      case 4: return mouseArea.containsMouse ? Colors.text : Colors.text // Disconnected
    }
  }



  // Network stuff
  readonly property var wifiDevice: Networking.devices.values.find(d => d.type === DeviceType.Wifi)
  readonly property var activeNetwork: wifiDevice ? wifiDevice.networks.values.find(n => n.connected) : null
  readonly property var wifiState: parseInt(wifiDevice.state.toString())
  readonly property bool wifiBlocked: {
    if (wifiState.toString() == "0") { return true }
    return false
  }

  Process {
    id:rfkillToggle
  }

  Process {
    id:nmtuiLaunch
    command: ["kitty", "nmtui"]
  }

  // Button stuff

  readonly property real signal: activeNetwork ? activeNetwork.signalStrength : 0

  readonly property string icon:{
    if (!Networking.wifiEnabled) return String.fromCodePoint(0xF05AA)
    if (!activeNetwork) return String.fromCodePoint(0xF092D)

    let tier = signal >= 0.75 ? 4
    : signal >= 0.50 ? 3
    : signal >= 0.25 ? 2
    : 1

    return String.fromCodePoint(0xF091F + (tier - 1) * 3)
  }

  Text {
    id: text
    text: icon
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
      if (mouse.button == Qt.LeftButton) { 
        rfkillToggle.command = wifiBlocked ? ["rfkill", "unblock", "wifi"] : ["rfkill", "block", "wifi"]
        rfkillToggle.running = true
      }
    }
  }

  Behavior on color {
    ColorAnimation { duration: Metrics.animationLength }
  }
}
