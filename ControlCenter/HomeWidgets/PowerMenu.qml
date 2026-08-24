import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../../Config"

Rectangle {
  id: root
  property bool expanded: false

  Layout.preferredHeight: 56
  Layout.preferredWidth: 60
  radius: Metrics.roundingRadius
  color: Colors.surface
  border.color: Colors.border
  antialiasing: true
  clip: true

  Behavior on Layout.preferredWidth {
    NumberAnimation { duration: Metrics.animationLength; easing.type: Easing.OutQuad }
  }

  Process { id: action }

  RowLayout {
    id: content
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left
    anchors.leftMargin: Metrics.paddingSmall
    spacing: Metrics.spacingInMenu

    Text {
      id: powerIcon
      text: String.fromCodePoint(0xf0425) // power symbol — verify against a nerd font cheat sheet
      color: Colors.text
      font { family: "JetBrainsMono Nerd Font Propo"; pixelSize: Metrics.iconSize }

      MouseArea {
        anchors.fill: parent
        onClicked: root.expanded = !root.expanded
      }
    }

    RowLayout {
      id: confirmRow
      spacing: Metrics.spacingInMenu
      clip: true
      opacity: root.expanded ? 1 : 0
      Layout.preferredWidth: root.expanded ? implicitWidth : 0

      Behavior on Layout.preferredWidth {
        NumberAnimation { duration: Metrics.animationLength; easing.type: Easing.OutQuad }
      }
      Behavior on opacity {
        NumberAnimation { duration: Metrics.animationLength }
      }

      Repeater {
        model: [
          { icon: 0xf033e, cmd: ["hyprlock"] },
          { icon: 0xf04b2, cmd: ["systemctl", "suspend"] },
          { icon: 0xf0709, cmd: ["systemctl", "reboot"] },
          { icon: 0xf0425, cmd: ["systemctl", "poweroff"] }
        ]
        delegate: Text {
          required property var modelData
          text: String.fromCodePoint(modelData.icon)
          color: Colors.error
          font { family: "JetBrainsMono Nerd Font Propo"; pixelSize: Metrics.iconSize }

          MouseArea {
            anchors.fill: parent
            onClicked: {
              action.command = modelData.cmd
              action.running = true
              root.expanded = false
            }
          }
        }
      }
    }
  }
}
