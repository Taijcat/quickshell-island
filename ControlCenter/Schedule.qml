import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import "../Config/"
import "../Island"
import "Examples"
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
      spacing: Metrics.spacingInMenu
      RowLayout{
        id: content
        spacing: Metrics.spacingInMenu
        GridLayout {
          id: grid
          columns: 2
          rowSpacing: Metrics.spacingInMenu
          columnSpacing: Metrics.spacingInMenu
          CalendarSchedule {}
          DebugButton{}
          DebugButton{}
          DebugButton{}
          DebugButton{}
          DebugButton{}
        }
      }
    }
  }
}
