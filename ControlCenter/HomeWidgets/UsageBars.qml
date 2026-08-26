import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../../Config"

Rectangle {
  id: root
  required property int spanH
  required property int spanW
  implicitWidth: Functions.spanToWidth(spanW)
  implicitHeight: Functions.spanToHeight(spanH)

  color: mouseArea.containsMouse ? Colors.overlay : Colors.surface
  border.color: mouseArea.containsMouse ? Colors.accent : Colors.border
  radius: Metrics.roundingRadius

  Behavior on color {
    ColorAnimation {duration: Metrics.animationLength}
  }

  SequentialAnimation {
    id: flash
    ColorAnimation { target: root; property: "color"; to: Colors.accent; duration: Metrics.animationLength }
    ColorAnimation { target: root; property: "color"; to: Colors.surface; duration: Metrics.animationLength }
  }

  MouseArea{
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    onClicked: btop.running = true, flash.start()
  }

  Process{
    id: btop
    command: ["kitty", "btop"]
  }


  component Bar: Rectangle{
    id: track
    property real ratio: 0
    property string activeColor: ""
    color: Colors.base
    border.color: Colors.border
    antialiasing: true
    radius: width / 2

    Rectangle{
      anchors.bottom: parent.bottom
      anchors.horizontalCenter: parent.horizontalCenter
      antialiasing: true
      color: track.activeColor
      border.color: Colors.border
      radius: width / 2
      width: track.width
      height: track.height * track.ratio
      Behavior on height {
        NumberAnimation {duration: 2000}
      }
    }

  }

  property real cpuUsage: 0
  property real cpuTemp: 0
  property real gpuUsage: 0
  property real gpuTemp: 0
  property real avgTemp: (cpuTemp + gpuTemp) / 2

  Timer {
    interval: 2000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      cpuProc.running = true
      tempProc.running = true
      gpuProc.running = true
    }
  }

  Process {
    id: cpuProc
    command: ["sh", "-c", "top -bn1 | grep '%Cpu(s)' | awk '{print 100 - $8}'"]
    stdout: StdioCollector {
      onStreamFinished: {
        const val = parseFloat(text)
        if (!isNaN(val)) root.cpuUsage = val / 100
      }
    }
  }

  Process {
    id: tempProc
    command: ["sh", "-c", "sensors | grep -m1 -E 'Package id 0|Tctl|Tdie' | grep -oE '[0-9]+\\.[0-9]+' | head -1"]
    stdout: StdioCollector {
      onStreamFinished: {
        const val = parseFloat(text)
        if (!isNaN(val)) root.cpuTemp = val / 100
      }
    }
  }

  Process {
    id: gpuProc
    command: ["sh", "-c",
    "nvidia-smi --query-gpu=utilization.gpu,temperature.gpu " +
    "--format=csv,noheader,nounits"]
    stdout: StdioCollector {
      onStreamFinished: {
        const parts = text.trim().split(",")
        if (parts.length === 2) {
          const u = parseFloat(parts[0])
          const t = parseFloat(parts[1])
          if (!isNaN(u)) root.gpuUsage = u / 100
          if (!isNaN(t)) root.gpuTemp = t / 100
        }
      }
    }
  }

  /*
  ColumnLayout{
    anchors.fill: parent
    spacing: 0
    Item {height: Metrics.edgePadding}
    RowLayout{
      id: bars
      Layout.fillWidth: true
      Layout.preferredHeight: parent.height
      Layout.leftMargin: Metrics.edgePadding
      Layout.rightMargin: Metrics.edgePadding
      spacing: Metrics.spacingInMenu
      Bar {id:cpuBar; barHeight: bars.height; ratio: Math.max(0.1, cpuUsage); activeColor: Colors.hint; Layout.fillWidth: true}
      Bar {id:gpuBar; barHeight: bars.height; ratio: gpuUsage; activeColor: Colors.success; Layout.fillWidth: true }
      Bar {id:tempBar; barHeight: bars.height; ratio: avgTemp; activeColor: Colors.error; Layout.fillWidth: true}
    }
    RowLayout{
      Layout.fillWidth: true
      Layout.preferredHeight: parent.height
      Layout.leftMargin: Metrics.edgePadding
      Layout.rightMargin: Metrics.edgePadding
      spacing: Metrics.spacingInMenu
      Text{
        text: String.fromCodePoint(0xf0ee0)
        Layout.preferredWidth: cpuBar.width
        color: Colors.text
        Layout.fillWidth: true
        font{
          family: Metrics.iconFont
        }
      }
      Text{
        text: String.fromCodePoint(0xf035b)
        Layout.preferredWidth: gpuBar.width
        color: Colors.text
        Layout.fillWidth: true
        font{
          family: Metrics.iconFont
        }
      }
      Text{
        text: String.fromCodePoint(0xf050f)
        Layout.preferredWidth: tempBar.width
        color: Colors.text
        Layout.fillWidth: true
        font{
          family: Metrics.iconFont
        }
      }
    }
  }
  */

 ColumnLayout {
  anchors.fill: parent
  spacing: 0
  Item { height: Metrics.edgePadding }

  GridLayout {
    id: statsGrid
    columns: 3
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.leftMargin: Metrics.edgePadding
    Layout.rightMargin: Metrics.edgePadding
    columnSpacing: Metrics.spacingInMenu
    rowSpacing: 0

    // Row 0: bars
    Bar { ratio: Math.max(0.1, cpuUsage); activeColor: Colors.hint; Layout.fillWidth: true; Layout.fillHeight: true }
    Bar { ratio: Math.max(0.1, gpuUsage); activeColor: Colors.success; Layout.fillWidth: true; Layout.fillHeight: true }
    Bar { ratio: Math.max(0.1, avgTemp); activeColor: Colors.error; Layout.fillWidth: true; Layout.fillHeight: true }


    // Row 1: icons
    Text {
      text: String.fromCodePoint(0xf0ee0)
      color: Colors.text
      Layout.preferredWidth: 12
      Layout.fillWidth: true
      horizontalAlignment: Text.AlignHCenter
      font.family: Metrics.iconFont
    }
    Text {
      text: String.fromCodePoint(0xf035b)
      color: Colors.text
      Layout.preferredWidth: 12
      Layout.fillWidth: true
      horizontalAlignment: Text.AlignHCenter
      font.family: Metrics.iconFont
    }
    Text {
      text: String.fromCodePoint(0xf050f)
      color: Colors.text
      Layout.preferredWidth: 12
      Layout.fillWidth: true
      horizontalAlignment: Text.AlignHCenter
      font.family: Metrics.iconFont
    }
  }
}
}
