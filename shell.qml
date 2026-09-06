import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "ControlCenter"
import "Config"
import "Island"
import "OSDs"

ShellRoot {
  IpcHandler {
    target: "controlCenter"
    function toggle(): void {
      IslandState.activeModule === IslandTypes.Module.Home ? (IslandState.show(IslandTypes.Module.Clock)) : (IslandState.show(IslandTypes.Module.Home))
    }
  }
  Variants{
    model: Quickshell.screens
    PanelWindow {
      id: root

      required property var modelData
      screen: modelData
      property bool isFullscreen: false

      function updateFullscreen() {
        const mon = Hyprland.monitorFor(screen)
        isFullscreen = !!(mon && mon.activeWorkspace && mon.activeWorkspace.hasFullscreen)
      }

      Component.onCompleted: updateFullscreen()

      Connections {
        target: Hyprland
        function onRawEvent(event) { root.updateFullscreen() }
      }

      visible: !isFullscreen


      WlrLayershell.namespace: "quickshell:island" // Hyprland stuff

      // Give the clock some space
      WlrLayershell.layer: WlrLayer.Overlay 
      exclusionMode: ExclusionMode.Normal
      exclusiveZone: (!isFullscreen) 
      ? Metrics.clockReservedHeight
      : 0

      anchors.top: true
      anchors.left: true
      anchors.right: true
      implicitHeight: modelData.height
      color: "transparent"

      // Make root not steal clicks from the screen
      mask: Region {
        item: island
      }

      // Main island
      Rectangle {
        id: island
        anchors.horizontalCenter: parent.horizontalCenter
        y: 8
        implicitWidth: content.implicitWidth + Metrics.islandHorizPadding
        implicitHeight: content.implicitHeight + Metrics.islandVertPadding
        radius: Metrics.roundingRadius
        color: Colors.base
        antialiasing: true
        clip: true

        Component.onCompleted: {
          Qt.callLater(() => {
            Metrics.islandHeight = height
          })
        }

        Behavior on implicitWidth {
          NumberAnimation {
            duration: Metrics.animationLength
            easing.type: Easing.OutBack
            easing.overshoot: Metrics.easingHeadroom
          }
        }

        Behavior on implicitHeight {
          NumberAnimation {
            duration: Metrics.animationLength
            easing.type: Easing.OutBack
            easing.overshoot: Metrics.easingHeadroom
          }
        }

        RowLayout {
          id: content
          anchors.centerIn: parent
          spacing: 0
          Clock {}
          Workspaces {}
          ControlCenterHome { parentWindow: root }
          VolumeOSD {}
          ControlCenterSystem {parentWindow: root}
          ControlCenterSchedule {parentWindow: root}
          ControlCenterProductivity {parentWindow: root}
        }
      }
    }
  }
}
