import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../Config/"
import "HomeWidgets"
import "../Island"
import "Visualizer"


Item {
  id: root
  visible: IslandState.activeModule === IslandTypes.Module.Home
  required property var parentWindow
  focus: IslandState.activeModule === IslandTypes.Module.Home
  Keys.onEscapePressed: IslandState.show(IslandTypes.Module.Clock)

  implicitWidth: IslandState.activeModule === IslandTypes.Module.Home ? main.implicitWidth : 0
  implicitHeight: IslandState.activeModule === IslandTypes.Module.Home ? main.implicitHeight + Metrics.islandVertPadding * 1.5 : 0

  RowLayout{
    id: main
    anchors.centerIn: parent
    spacing: Metrics.spacingInMenu * 2
    ColumnLayout{
      id: content
      spacing: Metrics.spacingInMenu
      Media {length: buttons.width}
      ColumnLayout{
        id: buttons
        RowLayout{
          spacing: Metrics.spacingInMenu
          Ethernet {}
          Wifi {}
          Bluetooth {}
        }
        RowLayout{
          spacing: Metrics.spacingInMenu
          Caffeine {}
          Button {}
          Button {}
        }
      }
      VolumeSlider {length: content.width}
    }
    Visualizer{}
  }

  HyprlandFocusGrab {
    windows: [root.parentWindow]
    active: IslandState.activeModule === IslandTypes.Module.Home
    onCleared: IslandState.show(IslandTypes.Module.Clock)
  }
}
