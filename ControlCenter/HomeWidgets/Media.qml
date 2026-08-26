import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Io
import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import "../../Config/"

RowLayout{
  id: root
  Layout.fillWidth: true
  required property int lengthPre
  property int length : lengthPre - 112
  spacing: Metrics.spacingInMenu

  readonly property var player: {
    const players = Mpris.players.values
    if (players.length === 0) return null
    return players.find(p => p.playbackState === MprisPlaybackState.Playing) ?? players[0]
  }
  readonly property bool active: player !== null
  readonly property bool playing: active && player.playbackState === MprisPlaybackState.Playing
  //visible: active


component MediaSlider: Item {
  id: slider
  implicitHeight: 16
  property real position: 0
  property real length: 1
  property bool seeking: false
  property bool wasPlayingBeforeSeek: false
  signal seekRequested(real position)
  signal seekStarted()
  signal seekFinished()

  readonly property real ratio: length > 0 ? position / length : 0

  property real waveAmplitude: (root.active && root.playing && !slider.seeking) ? Metrics.waveAmp : 0

  Behavior on waveAmplitude {
    NumberAnimation { duration: Metrics.animationLength; easing.type: Easing.OutQuad }
  }
  property real waveLength: Metrics.waveLength
  property real phase: 0

  NumberAnimation on phase {
    running: root.playing && !slider.seeking
    loops: Animation.Infinite
    from: 0
    to: slider.waveLength
    duration: Metrics.waveSpeed
  }

  // unplayed track — only covers the remaining (not yet played) portion
  Rectangle {
    id: track
    anchors.verticalCenter: parent.verticalCenter
    x: slider.width * slider.ratio
    width: slider.width * (1 - slider.ratio)
    height: 4
    radius: height / 2
    color: Colors.surface
    border.color: Colors.border
  }

  // played portion, wavy
  Shape {
    id: waveShape
    anchors.verticalCenter: parent.verticalCenter
    x: -strokeHalf
    width: slider.width * slider.ratio + strokeHalf
    height: slider.implicitHeight
    antialiasing: true
    layer.enabled: true
    layer.samples: 4
    clip: true

    property real strokeHalf: wavePath.strokeWidth / 2

    ShapePath {
      id: wavePath
      strokeColor: Colors.accent
      strokeWidth: 4
      fillColor: "transparent"
      capStyle: ShapePath.RoundCap
      joinStyle: ShapePath.RoundJoin
      startX: waveShape.strokeHalf
      startY: waveShape.height / 2

      PathPolyline {
        path: {
          const pts = []
          const w = waveShape.width - waveShape.strokeHalf  // logical wave width, unshifted
          const h = waveShape.height / 2
          const amp = slider.waveAmplitude
          const wl = slider.waveLength
          const offset = waveShape.strokeHalf
          for (let x = 0; x <= w; x += 1) {
            const y = h + amp * Math.sin((2 * Math.PI / wl) * (x + slider.phase))
            pts.push(Qt.point(x + offset, y))
          }
          return pts
        }
      }
    }
  }

  Rectangle {
    width: 12
    height: 12
    radius: 6
    color: Colors.text
    anchors.verticalCenter: parent.verticalCenter
    x: slider.width * slider.ratio - width / 2
  }

  MouseArea {
    id: dragArea
    anchors.fill: parent
    anchors.margins: -6
    onPressed: (mouse) => {
      slider.seeking = true
      slider.seekStarted()
      updateFromMouse(mouse.x)
    }
    onPositionChanged: (mouse) => {
      if (slider.seeking) updateFromMouse(mouse.x)
    }
    onReleased: (mouse) => {
      updateFromMouse(mouse.x)
      slider.seeking = false
      slider.seekFinished()
    }
    function updateFromMouse(x) {
      const ratio = Math.max(0, Math.min(1, x / slider.width))
      slider.position = ratio * slider.length
      slider.seekRequested(slider.position)
    }
  }
}

  component MediaButton: Rectangle {
    id: btn
    property string icon: ""
    property bool enabled: true
    signal clicked()

    implicitWidth: Math.max(text.width, text.height) + Metrics.spacingInMenu
    implicitHeight: Math.max(text.width, text.height) + Metrics.spacingInMenu
    radius: height / 2
    color: mouseArea.containsMouse ? Colors.overlay : Colors.surface
    border.color: mouseArea.containsMouse ? Colors.accent : Colors.border

    Text {
      id:text
      anchors.centerIn: parent
      text: btn.icon
      color: Colors.text
      font{
        family: Metrics.iconFont
        pixelSize: Metrics.iconSize
      }
    }

    SequentialAnimation {
      id: flash
      ColorAnimation { target: btn; property: "color"; to: Colors.accent; duration: Metrics.animationLength }
      ColorAnimation { target: btn; property: "color"; to: Colors.surface; duration: Metrics.animationLength }
    }

    MouseArea {
      id: mouseArea
      enabled: btn.enabled
      anchors.fill: parent
      hoverEnabled: true
      onClicked: {
        btn.clicked()
        flash.start()
      }
    }
    Behavior on color {
      ColorAnimation {duration: Metrics.animationLength}
    }
  }

  Rectangle{
    implicitHeight: content.height
    implicitWidth: content.width
    radius: Metrics.roundingRadius
    color: Colors.surface
    border.color: Colors.border
    ColumnLayout{
      id:content
      Item{
        id:art
        Layout.leftMargin: Metrics.edgePadding
        Layout.rightMargin: Metrics.edgePadding
        Layout.topMargin: Metrics.edgePadding
        Layout.preferredWidth: root.length - 2 * Metrics.edgePadding
        Layout.preferredHeight: root.length - 2 *  Metrics.edgePadding
        Rectangle {
          anchors.fill: parent
          //radius: Metrics.roundingRadius
          radius: height/2
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
          //radius: Metrics.roundingRadius
          radius: height/2
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
          //radius: Metrics.roundingRadius
          radius: height/2
          border.color: Colors.border
        }
      }

      Text{
        Layout.leftMargin: Metrics.edgePadding
        Layout.preferredWidth: parent.width - 2 *Metrics.edgePadding
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
        Layout.leftMargin: Metrics.edgePadding
        Layout.preferredWidth: parent.width - 2 * Metrics.edgePadding
        text: root.active ? (root.player.trackArtist || "Unknown Artist") : ""
        color: Colors.text
        elide: Text.ElideRight
        font {
          family: Metrics.textFont
          pixelSize: Metrics.textSize
          weight: 500
        }
      }

      MediaSlider {
        id: mediaSlider
        Layout.fillWidth: true
        Layout.leftMargin: Metrics.edgePadding
        Layout.rightMargin: Metrics.edgePadding

        property bool wasPlayingBeforeSeek: false

        length: root.active ? root.player.length : 1
        position: root.active && !seeking ? root.player.position : position

        onSeekStarted: {
          wasPlayingBeforeSeek = root.playing
          if (root.active && root.playing) root.player.pause()
        }
        onSeekRequested: (pos) => {
          mediaSlider.position = pos
        }
        onSeekFinished: {
          if (root.active) root.player.position = mediaSlider.position  // seek once
          if (root.active && wasPlayingBeforeSeek) root.player.play()
        }
      }

      Timer {
        interval: 1000
        running: root.playing
        repeat: true
        onTriggered: {
          if (root.active) {
            // force position re-read from the player each tick
            mediaSlider.position = root.player.position
          }
        }
      }

      RowLayout {
        Layout.fillWidth: true
        Layout.leftMargin: Metrics.edgePadding
        Layout.rightMargin: Metrics.edgePadding
        Layout.bottomMargin: Metrics.edgePadding
        Layout.alignment: Qt.AlignHCenter
        spacing: Metrics.spacingInMenu

        MediaButton {
          icon: String.fromCodePoint(0xf04ae)
          enabled: root.active && root.player.canGoPrevious
          onClicked: root.player.previous()
        }
        MediaButton {
          icon: root.playing ? String.fromCodePoint(0xf03e4) : String.fromCodePoint(0xf040a)
          enabled: root.active && root.player.canPause
          onClicked: root.player.togglePlaying()
        }
        MediaButton {
          icon: String.fromCodePoint(0xf04ad)
          enabled: root.active && root.player.canGoNext
          onClicked: root.player.next()
        }
      }
    }
  }
}
