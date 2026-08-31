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
  Keys.onEscapePressed: IslandState.show(IslandTypes.Module.Clock)

  implicitWidth: isActiveHere ? main.implicitWidth : 0
  implicitHeight: isActiveHere ? main.implicitHeight + Metrics.islandVertPadding * 1.5 : 0


  RowLayout{
    id: main
    anchors.centerIn: parent
    spacing: Metrics.spacingInMenu
    ControlCenterPicker {length: main.height}
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
        columns: 5
        rowSpacing: Metrics.spacingInMenu
        columnSpacing: Metrics.spacingInMenu
        DebugButton {}
        DebugButton {}
        Logo{
          Layout.column: 2; Layout.row: 0
          Layout.columnSpan: 3; Layout.rowSpan: 3
        }
      }
      BatteryBar {Layout.fillWidth: true}
    }

  }

  HyprlandFocusGrab {
    windows: [root.parentWindow]
    active: isActiveHere
    onCleared: IslandState.show(IslandTypes.Module.Clock)
  }
}
