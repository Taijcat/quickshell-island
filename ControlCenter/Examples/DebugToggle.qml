import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import "../../Config"

Switch {
  id: control
  hoverEnabled: true
  checked: false

  indicator: Rectangle {
    implicitWidth: Metrics.switchLength
    implicitHeight: Metrics.iconSize
    x: control.leftPadding
    y: parent.height / 2 - height / 2
    radius: height / 2
    color: control.checked ? Colors.accent : Colors.surface
    border.color: control.checked ? Colors.accent : Colors.border

    Rectangle {
      width: 19
      height: Metrics.iconSize - 6
      radius: 10
      anchors.verticalCenter: parent.verticalCenter
      x: control.checked ? parent.width - width - 3 : 3
      color: Colors.text

      Behavior on x { NumberAnimation { duration: Metrics.animationLength; easing.type: Easing.OutCubic } }
    }
  }

  onToggled: console.log("now", checked)
  onCheckedChanged: console.log("changed")
}
