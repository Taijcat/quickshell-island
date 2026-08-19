import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../Config"
import "../Island"

RowLayout {
  id: root
  visible: IslandState.activeModule === IslandTypes.Module.Workspaces

  Timer {
    id: workspaceTimer
    interval: 500
    onTriggered: IslandState.restore()
  }

  Connections {
    target: Hyprland
    function onRawEvent(event) {
      if (event.name === "workspace" || event.name === "workspacev2") {
        IslandState.show(IslandTypes.Module.Workspaces)
        workspaceTimer.restart()
      }
    }
  }

  spacing: 7

  Repeater {
    model: Hyprland.workspaces.values.slice().sort((a, b) => a.id - b.id)

    Rectangle {
      id: wsButton
      required property var modelData
      property var ws: modelData
      property bool isActive: Hyprland.focusedWorkspace?.id === ws.id

      implicitHeight: label.implicitHeight
      implicitWidth: label.implicitWidth + 14
      radius: 15
      color: "transparent"
      Behavior on color {
        ColorAnimation { duration: 150 }
      }

      Text {
        id: label
        anchors.centerIn: parent
        text: "󰝥"
        color: isActive ? Colors.hint : (wsButton.ws ? Colors.accent : Colors.text)
        font {
          family: Metrics.iconFont
          letterSpacing: -1
          pixelSize: Metrics.textSize
          weight: isActive ? 600 : 400
        }
      }

      MouseArea {
        anchors.fill: parent
        onClicked: Hyprland.dispatch("hl.dsp.focus({workspace = " + ws.id + "})")
      }
    }
  }
}
