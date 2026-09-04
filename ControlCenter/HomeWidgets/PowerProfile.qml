import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts
import "../../Config"

Rectangle {
  id: root

  Layout.preferredWidth: 56
  Layout.preferredHeight: 56
  antialiasing: true
  radius: Metrics.roundingRadius
  color: mouseArea.containsMouse ? Colors.overlay : Colors.surface
  border.color: mouseArea.containsMouse ? iconColor : Colors.border

  property string iconColor: {
    if ( PowerProfiles.profile === PowerProfile.PowerSaver ) { return Colors.green }
    if ( PowerProfiles.profile === PowerProfile.Balanced ) { return Colors.blue }
    if ( PowerProfiles.profile === PowerProfile.Performance ) { return Colors.red }
  }

  property string icon:{
    if ( PowerProfiles.profile === PowerProfile.PowerSaver ) { return String.fromCodePoint(0xf032a) }
    if ( PowerProfiles.profile === PowerProfile.Balanced ) { return String.fromCodePoint(0xf05d1) }
    if ( PowerProfiles.profile === PowerProfile.Performance ) { return String.fromCodePoint(0xf04c5) }
  }

  function changeProfile() {
    if ( PowerProfiles.profile === PowerProfile.PowerSaver ) { PowerProfiles.profile = PowerProfile.Balanced; return }
    if ( PowerProfiles.profile === PowerProfile.Balanced ) { PowerProfiles.hasPerformanceProfile ? PowerProfiles.profile = PowerProfile.Performance : PowerProfiles.profile = PowerProfile.PowerSaver; return }
    if ( PowerProfiles.profile === PowerProfile.Performance ) { PowerProfiles.profile = PowerProfile.PowerSaver; return }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    onClicked: {
      changeProfile()
    }
  }

  Text {
    text: icon
    color: iconColor
    anchors.centerIn: parent
    font {
      family: Metrics.iconFont
      pixelSize: Metrics.iconSize
    }
  }

  Behavior on color {
    ColorAnimation { duration: Metrics.animationLength }
  }
}
