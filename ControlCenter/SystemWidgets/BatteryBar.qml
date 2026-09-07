import Quickshell
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts
import "../../Config/"

RowLayout{
  id: root
  spacing: Metrics.spacingInMenu

  property var battery: UPower.displayDevice
  property bool pluggedIn: battery.state === UPowerDeviceState.Charging || battery.state === UPowerDeviceState.FullyCharged
  readonly property real level: battery.energy / battery.energyCapacity
  readonly property int percentage: Math.round(100 * level)


  property string icon: {
    if (percentage > 94 && pluggedIn) { return String.fromCodePoint(0xf06a5) }
    if (root.pluggedIn) { return String.fromCodePoint(0xf0084) }
    if (percentage < 95) { return String.fromCodePoint(0xf0079 + Math.trunc(percentage / 10)) }

    return String.fromCodePoint(0xf0079)
  }
  
  property string color: {
    if (pluggedIn) { return Colors.info }
    if (percentage < 15) {return Colors.error}
    if (percentage < 30) {return Colors.warn}
    return Colors.success
  }

  Text{
    color: root.color
    Layout.alignment: Qt.AlignVCenter

    text: icon
    font {
      family: "JetBrainsMono Nerd Font Propo"
      pixelSize: Metrics.textSize
    }
  }

  Item {}

  Rectangle {
    Layout.fillWidth: true
    implicitHeight: Metrics.textSize / 3
    color: Colors.surface
    radius: height/2
    Rectangle{
      implicitHeight: parent.implicitHeight
      color: root.color
      radius: height/2
      width: parent.width * level

    }
    Rectangle{
      anchors.verticalCenter: parent.verticalCenter
      implicitHeight: Metrics.textSize
      implicitWidth: Metrics.textSize
      radius: height / 2
      color: Colors.text
      x: parent.width * level - width / 2
    }
  }

  Item {}

  Text {
    text: percentage + "%"
    color: root.color
    font {
      family: Metrics.textFont
      pixelSize: Metrics.textSize
    }
  }
}
