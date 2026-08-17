import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../../Config/"

Rectangle{
  // Boilerplate
  id:root
  required property int length
  Layout.fillWidth: true
  Layout.preferredHeight: Metrics.textSize + Metrics.buttonPadding
  antialiasing: true
  color: "transparent"


  // Audio logic
  property var sink: Pipewire.defaultAudioSink
  readonly property bool ready: sink && sink.ready
  readonly property bool muted: sink && sink.audio.muted
  readonly property int vol: ready ? Math.round(sink.audio.volume * 100) : 0


  // Button logic
  readonly property string icon: {

    if (!ready) return String.fromCodePoint(0xF0581)
    if (muted) return "󰸈"
    if (vol === 0) return String.fromCodePoint(0xF0581)
    if (vol <= 33) return String.fromCodePoint(0xF057F)
    if (vol <= 67) return String.fromCodePoint(0xF0580)

    return String.fromCodePoint(0xF057E)
  }

  function increaseVolume(step: real): void {
    if (sink && sink.audio) {
      sink.audio.volume = Math.max(0.0, Math.min(1.0, sink.audio.volume + step) )
    }
  }

  function decreaseVolume(step: real): void {
    if (sink && sink.audio) {
      sink.audio.volume = Math.max(0.0, Math.min(1.0, sink.audio.volume - step) )
    }
  }


  function setVolume(value: real): void {
    if (sink && sink.audio) {
      sink.audio.volume = Math.max(0.0, Math.min(1.0, value) )
    }
  }



  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    onWheel: (wheel) => {
      if (wheel.angleDelta.y > 0) { increaseVolume(0.01) }
      if (wheel.angleDelta.y < 0) { decreaseVolume(0.01) }
    }
  }

  RowLayout{
    anchors.fill: parent
    spacing: Metrics.spacingInMenu

    anchors.leftMargin: Metrics.spacingInMenu
    anchors.rightMargin: Metrics.spacingInMenu

    Text {
      text: icon
      color: Colors.text
      font {
        family: "JetBrainsMono Nerd Font Propo"
        pixelSize: Metrics.textSize
      }
    }

    Slider {
      id: volumeSlider
      from: 0.0
      to: 1.0
      Layout.fillWidth: true

      background: Rectangle {
        x: volumeSlider.leftPadding
        y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
        width: volumeSlider.availableWidth
        height: volumeSlider.pressed ? (Metrics.textSize / 2) : Metrics.textSize / 3
        radius: this.height / 2
        color: Colors.surface

        Rectangle {
          width: volumeSlider.visualPosition * parent.width
          height: parent.height
          radius: 3
          color: Colors.accent
        }

        Behavior on height {
          NumberAnimation{
            duration: Metrics.animationLength / 2
          }
        }
      }


      handle: Rectangle {
        x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
        y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
        implicitWidth: Metrics.textSize / 2
        implicitHeight: Metrics.textSize
        radius: implicitHeight / 2
        color: volumeSlider.pressed ? "#f0f0f0" : "#f6f6f6"
        border.color: "#bdbebf"
      }

      value: Pipewire.defaultAudioSink?.audio.volume ?? 0.0
      onMoved: setVolume(this.value.toFixed(2))
    }

    Text {
      text: vol + "%"
      color: Colors.text
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
