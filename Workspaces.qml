import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "Config"

RowLayout {
  id:root
  property bool showing: false
  visible: showing

  Timer {
    id: workspaceTimer
    interval: 500
    onTriggered: root.showing = false
  }

  Connections {
    target: Hyprland
    function onRawEvent(event) {
      if (event.name === "workspace" || event.name === "workspacev2") {
        root.showing = true
        workspaceTimer.restart()
      }
    }
  }

  property int activeWorkspaceCount: Hyprland.workspaces.values.length

  spacing: 7
  Repeater {
    model: activeWorkspaceCount
    Rectangle {
      id: wsButton
      required property int index
      property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
      property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

      implicitWidth: label.implicitWidth + 14
      implicitHeight: 22
      radius: 15

      //color: isActive ? Colors.overlay : Colors.surfaceAlt
      color: "transparent"


      Behavior on color {
        ColorAnimation { duration: 150 }
      }

      Text {
        id:label
        anchors.centerIn: parent
        //text: wsButton.index + 1
        text: "󰝥"

        color: isActive ? Colors.hint : (wsButton.ws ? Colors.accent : Colors.text)

        font {
          family: "Google Sans Flex"
          letterSpacing: -1
          pixelSize: 15
          weight: isActive ? 600 : 400
        }
      }

      MouseArea {
        anchors.fill: parent
        onClicked: Hyprland.dispatch("hl.dsp.focus({workspace = "+ (parent.index + 1) +"})")
      }
    }
  }
}

