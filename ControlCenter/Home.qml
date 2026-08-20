import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../Config/"
import "HomeWidgets"
import "../Island"


Item {
  id: root
  visible: IslandState.activeModule === IslandTypes.Module.Home
  required property var parentWindow
  focus: IslandState.activeModule === IslandTypes.Module.Home
  Keys.onEscapePressed: IslandState.show(IslandTypes.Module.Clock)

  implicitWidth: IslandState.activeModule === IslandTypes.Module.Home ? content.implicitWidth : 0
  implicitHeight: IslandState.activeModule === IslandTypes.Module.Home ? content.implicitHeight + Metrics.islandVertPadding * 1.5 : 0

  ColumnLayout {
    id: content
    anchors.centerIn: parent
    spacing: Metrics.spacingInMenu

    RowLayout {
      spacing: Metrics.spacingInMenu
      Ethernet {}
      Wifi {}
      Bluetooth {}
    }

    RowLayout {
      spacing: Metrics.spacingInMenu
      VolumeSlider { length : content.implicitWidth }
    }

  }

  HyprlandFocusGrab {
    windows: [root.parentWindow]
    active: IslandState.activeModule === IslandTypes.Module.Home
    onCleared: IslandState.show(IslandTypes.Module.Clock)
  }
}
