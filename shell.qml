import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "ControlCenter"
import "Config"
import "Island"
import "OSDs"

ShellRoot {
  Variants{
    model: Quickshell.screens
    PanelWindow {
      id: root
      visible: !isFullscreen

      // Make quickshell work with multiple screens
      required property var modelData
      screen: modelData
      WlrLayershell.namespace: "quickshell:island" // Hyprland stuff

      // Check for fullscreen
      property bool isFullscreen: { 
        const mon = Hyprland.monitorFor(screen)
        return mon && mon.activeWorkspace && mon.activeWorkspace.hasFullscreen
      }

      // Give the clock some space
      WlrLayershell.layer: WlrLayer.Overlay 
      exclusionMode: ExclusionMode.Normal
      exclusiveZone: (!isFullscreen) 
      ? Metrics.clockReservedHeight
      : 0

      anchors.top: true
      anchors.left: true
      anchors.right: true
      implicitHeight: 600
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
        implicitWidth: content.implicitWidth + 14
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
          NumberAnimation { duration: Metrics.animationLength; easing.type: Easing.InOutQuad }
        }
        Behavior on implicitHeight {
          NumberAnimation { duration: Metrics.animationLength; easing.type: Easing.InOutQuad }
        }
        RowLayout {
          id: content
          anchors.centerIn: parent
          spacing: 0
          Clock { onClicked: IslandState.show( IslandTypes.Module.Home ) }
          Workspaces {}
          ControlCenterHome { parentWindow: root }
        }
      }
    }
  }
}
