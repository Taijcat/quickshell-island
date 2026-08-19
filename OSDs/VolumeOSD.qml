import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../Config/"
import "../Island"

Rectangle{
  // Boilerplate
  id:root
  visible: IslandState.activeModule === IslandTypes.Module.VolumeOSD
  implicitWidth: Metrics.osdWidth
  Layout.preferredHeight: Metrics.textSize + Metrics.buttonPadding
  antialiasing: true
  color: "transparent"


  // Audio logic
  property var sink: Pipewire.defaultAudioSink
  readonly property bool ready: sink && sink.ready
  readonly property bool muted: sink && sink.audio.muted
  readonly property int vol: ready ? Math.round(sink.audio.volume * 100) : 0

  Timer{
    id: volumeTimer
    interval: 500
    onTriggered: IslandState.restore()
  }

  onVolChanged: {
    if (IslandState.activeModule !== IslandTypes.Module.Home) {
      IslandState.show(IslandTypes.Module.VolumeOSD)
      volumeTimer.restart()
    }
  }
  onMutedChanged: {
    if (IslandState.activeModule !== IslandTypes.Module.Home) {
      IslandState.show(IslandTypes.Module.VolumeOSD)
      volumeTimer.restart()
    }
  }

  readonly property string icon: {

    if (!ready) return String.fromCodePoint(0xF0581)
    if (muted) return "󰸈"
    if (vol === 0) return String.fromCodePoint(0xF0581)
    if (vol <= 33) return String.fromCodePoint(0xF057F)
    if (vol <= 67) return String.fromCodePoint(0xF0580)

    return String.fromCodePoint(0xF057E)
  }

  RowLayout{
    anchors.centerIn: parent
    spacing: Metrics.spacingInMenu
    width: parent.implicitWidth
    anchors.leftMargin: Metrics.spacingInMenu
    anchors.rightMargin: Metrics.spacingInMenu

    Text {
      text: icon
      color: root.muted ? Colors.error : Colors.text
      font {
        family: "JetBrainsMono Nerd Font Propo"
        pixelSize: Metrics.textSize * Metrics.iconSizeMult
      }
    }

    Slider {
      id: volumeSlider
      Layout.topMargin: -1

      from: 0.0
      to: 1.0
      Layout.fillWidth:true
      Layout.alignment: Qt.AlignVCenter


      topPadding: 0
      bottomPadding: 0
      leftPadding: 0
      rightPadding: 0

      background: Rectangle {
        x: volumeSlider.leftPadding
        y: volumeSlider.topPadding + Math.round((volumeSlider.availableHeight - height) / 2)
        width: volumeSlider.availableWidth
        implicitHeight: Metrics.textSize / 3
        height: implicitHeight
        radius: height / 2
        color: Colors.surface

        Rectangle {
          width: volumeSlider.visualPosition * parent.width
          height: parent.height
          radius: this.height / 2
          color: root.muted ? Colors.error : Colors.accent
          Behavior on height {
            NumberAnimation{
              duration: Metrics.animationLength / 2
            }
          }

          Behavior on color {
            ColorAnimation{
              duration: Metrics.animationLength / 2
            }
          }
        }
      }
      handle: Rectangle {
        x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
        y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
        implicitWidth: Metrics.textSize / 2
        implicitHeight: Metrics.textSize
        radius: implicitHeight / 2
        color: Colors.text
        border.color: "#bdbebf"
      }

      value: Pipewire.defaultAudioSink?.audio.volume ?? 0.0
      onMoved: setVolume(this.value.toFixed(2))
    }

    Text {
      text: vol + "%"
      color: root.muted ? Colors.error : Colors.text
      font {
        family: "JetBrainsMono Nerd Font Propo"
        pixelSize: Metrics.textSize
      }
    }
  }

  PwObjectTracker{
    objects: [root.sink]
  }
}
