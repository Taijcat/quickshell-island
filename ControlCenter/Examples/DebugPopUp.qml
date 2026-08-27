import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../../Config"
import "../../Island"

PopupWindow{
  id: root
  color: "transparent"
  required property var anchorWindow
  property var model: []
  grabFocus: true

  property bool menuOpen: false
  visible: menuOpen

  implicitWidth: content.implicitWidth * Metrics.easingHeadroom
  implicitHeight: content.implicitHeight * Metrics.easingHeadroom


  anchor.window: anchorWindow
  anchor.rect.x: anchorWindow.width / 2 - root.width / 2
  anchor.rect.y: anchorWindow.height / 2 - root.height / 2

  onVisibleChanged: {
    menuOpen = visible
  }

  Rectangle{
    id: content
    anchors.centerIn: parent
    color: Colors.base
    border.color: Colors.border
    radius: Metrics.roundingRadius

    implicitHeight: listCol.implicitHeight + 2 * Metrics.edgePadding
    implicitWidth: Metrics.popUpMenuWidth

    scale: root.menuOpen ? 1.0 : 0.4
    Behavior on scale {
      NumberAnimation {
        duration: Metrics.animationLength
        easing.type: Easing.OutBack
        easing.overshoot: Metrics.easingHeadroom
      }
    }

    ColumnLayout {
      id: listCol
      anchors.fill: parent
      anchors.margins: Metrics.edgePadding
      spacing: Metrics.spacingInMenu

      Repeater {
        model: root.model
        delegate: Rectangle {
          id: itemRect
          required property var modelData
          Layout.fillWidth: true
          Layout.preferredHeight: text.height + 2 * Metrics.edgePadding
          color: itemMouse.containsMouse ? Colors.overlay : Colors.surface
          border.color: itemMouse.containsMouse ? Colors.accent : Colors.border
          radius: Metrics.roundingRadius
          Text{
            id: text
            text: modelData
            color: Colors.text
            anchors.centerIn: parent
            font {
              family: Metrics.textFont
              pixelSize: Metrics.textSize * Metrics.textSizeMult
            }
          }
          MouseArea {
            id: itemMouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: console.log(modelData)
          }

          Behavior on color { ColorAnimation { duration: Metrics.animationLength } }
        }
      }
    }
  }
}
