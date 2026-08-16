import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Networking
import "../../Style"

// Boilerplate code for a button. For use in debugging and writing actually good buttons.
Rectangle {
  // Boilerplate
  //  Layout.preferredWidth: 56
  //  Layout.preferredHeight: 56
  implicitHeight: text.implicitHeight
  implicitWidth: text.implicitWidth
  antialiasing: true
  radius: Metrics.roundingRadius
  color: buttonColor
  border.color: borderColor

  // Network stuff
  readonly property var wifiDevice: Networking.devices.values.find(d => d.type === DeviceType.Wifi)
  readonly property bool wifiActive: wifiDevice.connected
  readonly property var wifiState: parseInt(wifiDevice.state.toString())

  // Button stuff
  Text {
    id: text
    text: wifiState.toString()
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
    onClicked: {
      wifiActive ? (wifiDevice.disconnect()) : (wifiDevice.autoconnect = true, wifiDevice.network.connect())

    }
  }

  Behavior on color {
    ColorAnimation {duration: Metrics.animationLength}
  }
}
