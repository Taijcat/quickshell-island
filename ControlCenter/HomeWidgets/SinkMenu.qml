import Quickshell
import Quickshell.Io
import QtQuick.Controls
import QtQuick.Controls.Material
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import "../../Config"
import "../../Island"

PopupWindow{
  id: root
  color: "transparent"
 
  //Audio Logic
  property var sink: Pipewire.defaultAudioSink
  readonly property bool ready: sink && sink.ready

  readonly property var audioSinks: {
    let result = []
    for (const node of Pipewire.nodes.values) {
      if (node.isSink && !node.isStream && node.audio) {
        result.push(node)
      }
    }
    return result
  }

  PwObjectTracker {
    objects: audioSinks
  }

  // PopUp Logic
  required property var anchorWindow
  property var target: null
  grabFocus: true

  property bool menuOpen: false
  visible: menuOpen

  implicitWidth: content.implicitWidth * Metrics.easingHeadroom
  implicitHeight: content.implicitHeight * Metrics.easingHeadroom

  anchor.window: anchorWindow
  anchor.rect.x: anchorWindow.width / 2 - root.width / 2
  anchor.rect.y: anchorWindow.height / 2 - root.height / 2

  Connections {
    target: root.target
    function onClicked() {
      root.menuOpen = true
      //for (const s of audioSinks) { console.log(s.name, s.description) }
    }
  }

  onVisibleChanged: {
    menuOpen = visible
  }

  Rectangle{
    id: content
    anchors.centerIn: parent
    color: Colors.base
    border.color: Colors.border
    radius: Metrics.roundingRadius

    implicitHeight: listCol.implicitHeight + 2 * Metrics.edgePadding
    implicitWidth: Metrics.popUpMenuWidth * 1.5

    scale: root.menuOpen ? 1.0 : 0.4
    Behavior on scale {
      NumberAnimation {
        duration: Metrics.animationLength
        easing.type: Easing.OutBack
        easing.overshoot: Metrics.easingHeadroom
      }
    }

    ColumnLayout {
      id: listCol
      anchors.fill: parent
      anchors.margins: Metrics.edgePadding
      spacing: Metrics.spacingInMenu

      Text {
        text: "Available sinks"
        color: Colors.text
        font {
          family: Metrics.textFont
          pixelSize: Metrics.textSize * Metrics.textSizeMult
          weight: 500
        }
      }
      Rectangle{height: 1; color: Colors.textDim; implicitWidth: parent.width; Layout.alignment: Qt.AlignHCenter; radius: 1; antialiasing: true}
      Item {}

      Repeater {
        model: audioSinks
        delegate: Rectangle {
          id: itemRect

          required property var modelData
          property bool isDefault: modelData.description == sink.description

          Layout.fillWidth: true
          Layout.preferredHeight: text.height + 2 * Metrics.edgePadding
          color: itemMouse.containsMouse ? (isDefault ? Colors.hint : Colors.overlay) : (isDefault ? Colors.accent : Colors.surface)
          border.color: itemMouse.containsMouse ? (isDefault ? Colors.hint : Colors.accent) : (isDefault ? Colors.accent : Colors.border)
          radius: Metrics.roundingRadius

          Text{
            id: text
            text: (isDefault ? String.fromCodePoint(0xf0c52) : String.fromCodePoint(0xf0131)) + "   " + (modelData.description)
            color: itemRect.isDefault ? Colors.base : Colors.text
            anchors.centerIn: parent
            width: itemRect.width - 2 * Metrics.edgePadding
            wrapMode: Text.WordWrap
            font {
              family: Metrics.textFont
              pixelSize: Metrics.textSize
              weight: itemRect.isDefault ? 500 : 400
            }
          }
          MouseArea {
            id: itemMouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: Pipewire.preferredDefaultAudioSink = modelData
          }
          Behavior on color { ColorAnimation { duration: Metrics.animationLength } }
        }
      }
    }
  }
}
