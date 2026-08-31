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
    DebugButton{}
    ColumnLayout{
      PowerPicker{length: buttons.width}
      GridLayout{
        id: buttons
        columns: 3
        rowSpacing: Metrics.spacingInMenu
        columnSpacing: Metrics.spacingInMenu
        DebugButton {}
        DebugButton {}
        DebugButton {}
        DebugButton {}
        DebugButton {}
      }
    }

  }

  HyprlandFocusGrab {
    windows: [root.parentWindow]
    active: isActiveHere
    onCleared: IslandState.show(IslandTypes.Module.Clock)
  }
}
