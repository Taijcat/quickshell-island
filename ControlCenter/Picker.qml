import Quickshell
import QtQuick
import QtQuick.Layouts
import "../Config"
import "../Island/"

ColumnLayout {
  id: root
  spacing: Metrics.spacingInMenu
  required property int length
  property int activeTabIndex: buttons.findIndex(b => b.isActive === true)
  implicitHeight: length

  function tabDown() {
    buttons[(activeTabIndex + 1) % buttons.length].onClicked()
  }

  function tabUp() {
    buttons[(activeTabIndex - 1 + buttons.length) % buttons.length].onClicked()
  }

  property var buttons: [
    { icon: 0xf02dc, onClicked: () => IslandState.show(IslandTypes.Module.Home),   isActive: IslandState.activeModule === IslandTypes.Module.Home   },
    { icon: 0xf00ed, onClicked: () => IslandState.show(IslandTypes.Module.Schedule), isActive: IslandState.activeModule === IslandTypes.Module.Schedule },
    { icon: 0xf0493, onClicked: () => IslandState.show(IslandTypes.Module.System), isActive: IslandState.activeModule === IslandTypes.Module.System },
  ]

  component ComponentButton: Rectangle {
    id: buttonRect
    property var buttonData: null
    color: mouseArea.containsMouse ? (buttonData.isActive ? Colors.hint : Colors.overlay ) : ( buttonData.isActive ? Colors.accent : Colors.surface )
    radius: Metrics.roundingRadius
    border.color: mouseArea.containsMouse ? Colors.accent : Colors.border
    implicitHeight: Metrics.textSize + Metrics.edgePadding * 2
    implicitWidth: Metrics.textSize + Metrics.edgePadding * 2

    Text {
      text: String.fromCodePoint(buttonRect.buttonData.icon)
      anchors.centerIn: parent
      color: buttonData.isActive ? Colors.accentText : Colors.text
      font {
        family: Metrics.iconFont
        pixelSize: Metrics.textSize
      }
    }

    MouseArea {
      id: mouseArea
      anchors.fill: parent
      hoverEnabled: true
      onClicked: buttonRect.buttonData.onClicked()
    }
  }

  ComponentButton {buttonData: buttons[0]}
  Item {Layout.fillHeight: true}
  ComponentButton {buttonData: buttons[1]}
  Item {Layout.fillHeight: true}
  ComponentButton {buttonData: buttons[2]}
}
