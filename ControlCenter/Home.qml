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
  required property var parentWindow

  readonly property var thisMonitor: Hyprland.monitorFor(parentWindow.screen)
  readonly property bool isActiveHere: IslandState.activeModule === IslandTypes.Module.Home
                                        && thisMonitor === Hyprland.focusedMonitor

  visible: isActiveHere
  focus: isActiveHere
  Keys.onEscapePressed: IslandState.show(IslandTypes.Module.Clock)

  implicitWidth: isActiveHere ? main.implicitWidth : 0
  implicitHeight: isActiveHere ? main.implicitHeight + Metrics.islandVertPadding * 1.5 : 0


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
       // Calendar {length: buttons.width}
        BigClock {}
      }
      VolumeSlider {length: content.width}
    }
    Visualizer {length: content.height}
  }


  HyprlandFocusGrab {
    windows: [root.parentWindow]
    active: isActiveHere
    onCleared: IslandState.show(IslandTypes.Module.Clock)
  }
}
