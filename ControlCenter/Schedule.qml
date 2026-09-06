import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import "../Config/"
import "../Island"
import "ScheduleWidgets"

Item {
  id: root
  required property var parentWindow
  readonly property var thisMonitor: Hyprland.monitorFor(parentWindow.screen)
  readonly property bool isActiveHere: IslandState.activeModule === IslandTypes.Module.Schedule
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
      id: content
      spacing: Metrics.spacingInMenu
      RowLayout{
        spacing: Metrics.spacingInMenu
        GridLayout {
          id: grid
          columns: 8
          rowSpacing: Metrics.spacingInMenu
          columnSpacing: Metrics.spacingInMenu
          Weather {
            Layout.column: 0; Layout.row: 0
            Layout.columnSpan: 5; Layout.rowSpan: 1
            spanW: 5; spanH: 1
          }
          WeatherStats {
            Layout.column: 5; Layout.row: 0
            Layout.columnSpan: 3; Layout.rowSpan: 1
            spanW: 3; spanH: 1
          }
          CalendarSchedule{
            Layout.column: 0; Layout.row: 2
            Layout.columnSpan: 3; Layout.rowSpan: 4
            spanW: 3; spanH: 4
          }
          Appointments {
            Layout.column: 3; Layout.row: 2
            Layout.columnSpan: 3; Layout.rowSpan: 4
            spanW: 3; spanH: 4
          }
          Todo {
            Layout.column: 6; Layout.row: 2
            Layout.columnSpan: 2; Layout.rowSpan: 4
            spanW: 2; spanH: 4
          }
        }
      }
    }
  }
}
