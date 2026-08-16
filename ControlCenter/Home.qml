import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../Style"
import "HomeButtons"


Item {
  id: root
  property bool showHome: false
  required property var parentWindow


  focus: showHome
  Keys.onEscapePressed: root.showHome = false

  implicitWidth: showHome ? content.implicitWidth + Metrics.islandPadding : 0
  implicitHeight: showHome ? content.implicitHeight + Metrics.islandPadding * 2 : 0

ColumnLayout {
  id: content
  visible: showHome
  anchors.centerIn: parent
  spacing: Metrics.spacingInMenu
  RowLayout {
  spacing: Metrics.spacingInMenu
  Ethernet {}
  Wifi {}
  Button {}
  }
  RowLayout {
  spacing: Metrics.spacingInMenu
  Button {}
  Button {}
  Button {}

  }
}

  HyprlandFocusGrab {
    windows: [root.parentWindow]
    active: root.showHome
    onCleared: root.showHome = false
  }

  IpcHandler {
    target: "controlCenter"

    function toggle(): void{
      root.showHome = !root.showHome
    }
  }
}
