import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import "../Config/"
import "../Island"
import "ProductivityWidgets"


Item {
  id: root
  required property var parentWindow
  readonly property var thisMonitor: Hyprland.monitorFor(parentWindow.screen)
  readonly property bool isActiveHere: IslandState.activeModule === IslandTypes.Module.Productivity
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
          ReadingList {
            id: readingList
            Layout.column: 0; Layout.row: 0
            Layout.columnSpan: spanW; Layout.rowSpan: spanH
            spanW: 6; spanH: 3
          }
          /*
          Animation {
            Layout.column: 4; Layout.row: 0
            Layout.columnSpan: spanW; Layout.rowSpan: spanH
            spanW: 2; spanH: 3
          }
          */
          Pomodoro {
            Layout.column: 6; Layout.row: 0
            Layout.columnSpan: spanW; Layout.rowSpan: spanH
            spanW: 2; spanH: 2
          }
          QuickCapture {
            Layout.column: 0; Layout.row: 3
            Layout.columnSpan: spanW; Layout.rowSpan: spanH
            spanW: 6; spanH: 1
          }
          DoNotDisturb {Layout.column: 6; Layout.row: 2}
          NightLight {Layout.column: 7; Layout.row: 2}
          Notes {Layout.column: 6; Layout.row: 3}
          Journal {Layout.column: 7; Layout.row: 3}
        }
      }
      ProgressBar{}
    }
  }
  BookPopup {target: readingList; anchorWindow: root.parentWindow; chosenBook: readingList.chosenBook}
  BookPopup {target: libraryPopup; anchorWindow: root.parentWindow; chosenBook: libraryPopup.chosenBook}
  LibraryPopup {id: libraryPopup; target: readingList; anchorWindow: root.parentWindow;}
}
