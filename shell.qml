import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "ControlCenter"
import "Config"

ShellRoot {
  Variants{
    model: Quickshell.screens
    PanelWindow {
      id: root
      visible: !isFullscreen

      // Make quickshell work with multiple screens
      required property var modelData
      screen: modelData
      WlrLayershell.namespace: "quickshell:island" // Hyprland bullshit

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
        width: content.implicitWidth + 14
        height: content.implicitHeight + 6
        radius: Metrics.roundingRadius
        color: Colors.base
        antialiasing: true
        clip: true

        Behavior on width {
          NumberAnimation { duration: Metrics.animationLength; easing.type: Easing.InOutQuad }
        }
        Behavior on height {
          NumberAnimation { duration: Metrics.animationLength; easing.type: Easing.InOutQuad }
        }

        RowLayout {
          id: content
          anchors.centerIn: parent
          spacing: 0
          Clock {
            visible: !controlCenterHome.showHome && !workspaces.showing
            onClicked: controlCenterHome.showHome = true
          }
          Workspaces { id: workspaces }
          ControlCenterHome {
            id: controlCenterHome
            parentWindow: root
            visible: !workspaces.showing
          }
        }
      }
    }
  }
}
