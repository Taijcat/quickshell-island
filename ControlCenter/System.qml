import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../Config/"
import "../Island"
import "Examples"
import "SystemWidgets"


Item {
  id: root
  required property var parentWindow

  readonly property var thisMonitor: Hyprland.monitorFor(parentWindow.screen)
  readonly property bool isActiveHere: IslandState.activeModule === IslandTypes.Module.System
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
    spacing: Metrics.spacingInMenu
    ControlCenterPicker {id:picker; length: main.height}
    Rectangle{
      implicitWidth: Metrics.spacerWidth
      Layout.fillHeight: true
      color: Colors.border
      radius: implicitWidth / 2
    }
    ColumnLayout{
      RowLayout{
        Item {Layout.preferredWidth: Functions.spanToWidth(content.columns - powerPicker.spanW)}
        PowerPicker{id: powerPicker; spanW: 3}
      }
      GridLayout{
        id: content
        columns: 9
        rowSpacing: Metrics.spacingInMenu
        columnSpacing: Metrics.spacingInMenu
        CPUInfo {
          Layout.column: 0; Layout.row: 0
          Layout.columnSpan: 6; Layout.rowSpan: 2
          spanW: 6; spanH: 2
        }
        GPUInfo {
          Layout.column: 0; Layout.row: 2
          Layout.columnSpan: 6; Layout.rowSpan: 2
          spanW: 6; spanH: 2
        }
        Logo{
          Layout.column: content.columns - 3; Layout.row: 0
          Layout.columnSpan: 3; Layout.rowSpan: 3
        }
        ResourcesInfo {
          Layout.column: content.columns - 3; Layout.row: 3
          Layout.columnSpan: 3; Layout.rowSpan: 1
          spanW: 3; spanH:1
        }
      }
      BatteryBar {Layout.fillWidth: true}
    }

  }
}
