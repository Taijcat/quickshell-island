import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../Config/"
import "HomeWidgets"
import "../Island"
import "Visualizer"
import "Examples"


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


  ColumnLayout{
    id: main
    anchors.centerIn: parent
    spacing: Metrics.spacingInMenu
    RowLayout{
      id: content
      spacing: Metrics.spacingInMenu
      Visualizer {length: content.height}
      GridLayout {
        id: grid
        columns: 4
        rowSpacing: Metrics.spacingInMenu
        columnSpacing: Metrics.spacingInMenu

        Ethernet  { Layout.column: 0; Layout.row: 0 }
        Wifi      { Layout.column: 1; Layout.row: 0 }
        Bluetooth { Layout.column: 2; Layout.row: 0 }
        Caffeine  { Layout.column: 3; Layout.row: 0 }

        UsageBars{
          Layout.column: 3; Layout.row: 1
          Layout.columnSpan: 1; Layout.rowSpan: 2
          spanW: 1; spanH: 2
        }

        BigClock{
          Layout.column: 3; Layout.row: 3
          Layout.columnSpan: 1; Layout.rowSpan: 2
          spanW: 1; spanH: 2
        }

        Calendar{
          Layout.column: 0; Layout.row: 1
          Layout.columnSpan: 3; Layout.rowSpan: 4
          spanW: 3; spanH: 4
        }
      }
      Media {id: media; lengthPre: content.height; preferredIndex: playerMenu.preferredIndex} // Base length = 112
      //Text{text: media.height; color:"#FFFFFF"}
    }
    VolumeSlider {id: volumeSlider; length: main.width;}
  }

  // Menus
  SinkMenu { target: volumeSlider; anchorWindow: root.parentWindow }
  PlayerMenu { id: playerMenu; target: media; anchorWindow: root.parentWindow }


  HyprlandFocusGrab {
    windows: [root.parentWindow]
    active: isActiveHere
    onCleared: IslandState.show(IslandTypes.Module.Clock)
  }
}
