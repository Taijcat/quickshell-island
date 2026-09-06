import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import "../Config/"
import "HomeWidgets"
import "../Island"
import "Visualizer"
import "Examples"
import "Calendar"


Item {
  id: root
  required property var parentWindow
  readonly property var thisMonitor: Hyprland.monitorFor(parentWindow.screen)
  readonly property bool isActiveHere: IslandState.activeModule === IslandTypes.Module.Home
  && thisMonitor === Hyprland.focusedMonitor

  visible: isActiveHere
  focus: isActiveHere
  implicitWidth: isActiveHere ? main.implicitWidth : 0
  implicitHeight: isActiveHere ? main.implicitHeight + Metrics.islandVertPadding * 1.5 : 0

  // Navigation

  HyprlandFocusGrab {
    windows: [root.parentWindow]
    active: isActiveHere
    onCleared: IslandState.show(IslandTypes.Module.Clock)
  }

  Shortcut {
    sequence: "Escape"
    enabled: root.visible
    onActivated:{
      IslandState.show(IslandTypes.Module.Clock)
    }
  }

  Shortcut {
    sequences: ["J", "Down"]
    enabled: root.visible
    onActivated: picker.tabDown()
  }

  Shortcut {
    sequences: ["K", "Up"]
    enabled: root.visible
    onActivated: picker.tabUp()
  }

  
  // Widgets
  RowLayout{
    id: main
    anchors.centerIn: parent
    ControlCenterPicker {id: picker; length: content.height}
    Rectangle{
      implicitWidth: Metrics.spacerWidth
      Layout.fillHeight: true
      color: Colors.border
      radius: implicitWidth / 2
    }
    ColumnLayout{
      spacing: Metrics.spacingInMenu
      RowLayout{
        id: content
        spacing: Metrics.spacingInMenu
        GridLayout {
          id: grid
          columns: 4
          rowSpacing: Metrics.spacingInMenu
          columnSpacing: Metrics.spacingInMenu
          Ethernet  { Layout.column: 0; Layout.row: 0 }
          Wifi      { Layout.column: 1; Layout.row: 0 }
          Bluetooth { Layout.column: 2; Layout.row: 0 }
          PowerProfile  { Layout.column: 3; Layout.row: 0 }
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
          CalendarHome{
            Layout.column: 0; Layout.row: 1
            Layout.columnSpan: 3; Layout.rowSpan: 4
            spanW: 3; spanH: 4
          }
        }
        Media {id: media; lengthPre: content.height; preferredIndex: playerMenu.preferredIndex} // Base length = 112
        Visualizer {length: content.height}
        //Text{text: media.height; color:"#FFFFFF"}
      }
      VolumeSlider {id: volumeSlider; length: main.width;}
    }
  }

  // Menus
  SinkMenu { target: volumeSlider; anchorWindow: root.parentWindow }
  PlayerMenu { id: playerMenu; target: media; anchorWindow: root.parentWindow }
}
