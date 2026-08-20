import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import "../../Config/"

RowLayout{
  id: root
  Layout.fillWidth: true
  required property int length
  spacing: Metrics.spacingInMenu

  readonly property var player: {
    const players = Mpris.players.values
    if (players.length === 0) return null
    return players.find(p => p.playbackState === MprisPlaybackState.Playing) ?? players[0]
  }
  readonly property bool active: player !== null
  readonly property bool playing: active && player.playbackState === MprisPlaybackState.Playing
  visible: active

  ColumnLayout{
    Item{
      id:art
      Layout.preferredWidth: root.length
      Layout.preferredHeight: root.length
      Rectangle {
        anchors.fill: parent
        radius: Metrics.roundingRadius
        color: Colors.surface
        antialiasing: true
      }
      Image {
        id: artImage
        anchors.fill: parent
        source: root.active ? (root.player.trackArtUrl ?? "") : ""
        fillMode: Image.PreserveAspectCrop
        mipmap: true
        smooth: true
        sourceSize.width: parent.height
        sourceSize.height: parent.height
        visible: false
        antialiasing: true
      }
      Rectangle{
        id: artMask
        anchors.fill: parent
        radius: Metrics.roundingRadius
        layer.enabled: true
        layer.samples: 4
        visible: false
        antialiasing: true
      }

      MultiEffect {
        anchors.fill: parent
        source: artImage
        maskEnabled: true
        maskSource: artMask
        visible: true
        antialiasing: true
        maskThresholdMin: 0.5
        maskSpreadAtMin: 0.05
      }

      Rectangle{
        anchors.fill: parent
        color: "transparent"
        radius: Metrics.roundingRadius
        border.color: Colors.border
      }
    }

    Text{
      Layout.preferredWidth: parent.width
      text: root.active ? (root.player.trackTitle || "Unknown track") : ""
      color: Colors.text
      elide: Text.ElideRight
      font {
        family: Metrics.textFont
        pixelSize: Metrics.textSize
        weight: 600
      }
    }

    Text{
      Layout.preferredWidth: parent
      text: root.active ? (root.player.trackArtist || "Unknown Artist") : ""
      color: Colors.text
      elide: Text.ElideRight
      font {
        family: Metrics.textFont
        pixelSize: Metrics.textSize
        weight: 500
      }
    }
  }
}
