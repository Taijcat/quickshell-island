import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../../Config"

Rectangle{
  id: root
  required property int spanW
  required property int spanH
  property int barCount: Math.max(0, Math.floor((implicitWidth - 3 * Metrics.edgePadding - textCol.width - Metrics.spacerWidth) / (Metrics.usageBarWidthSystem + Metrics.usageBarSpacingSystem)))
  property real usageVal: 0.0
  property real usageTemp: 0.0
  property var usageArr: Array(barCount).fill(0.01)

  implicitHeight: Functions.spanToHeight(spanH)
  implicitWidth: Functions.spanToWidth(spanW)
  radius: Metrics.roundingRadius
  color: Colors.surface

  Process {
    id: gpuProc
    command: Metrics.gpuProcCommand
    stdout: StdioCollector {
      onStreamFinished: {
        const parts = text.trim().split(",")
        if (parts.length === 2) {
          const u = parseFloat(parts[0])
          const t = parseFloat(parts[1])
          if (!isNaN(u)) {
            usageVal = parseFloat(u.toFixed(5))
            let newArr = usageArr.slice(1)
            newArr.push(usageVal)
            usageArr = newArr
          }
          if (!isNaN(t)) root.usageTemp = t
        }
      }
    }
  }



  Timer {
    interval: 1000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      gpuProc.running = true
    }
  }


  RowLayout {
    id: content
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.margins: Metrics.edgePadding
    implicitWidth: root.implicitWidth - 2 * Metrics.edgePadding
    implicitHeight: root.implicitHeight - Metrics.edgePadding
    spacing:0
    RowLayout{
      id:bars
      Layout.alignment: Qt.AlignBottom
      spacing: Metrics.usageBarSpacingSystem
      Repeater {
        model: barCount
        delegate: Rectangle{
          Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
          Layout.preferredHeight: (root.implicitHeight - 2 * Metrics.edgePadding) * Math.max(0.01,((usageArr[index]) / 100))
          Layout.preferredWidth: Metrics.usageBarWidthSystem
          radius: Layout.preferredWidth / 2
          color: Colors.green
        }
      }
      Item {Layout.preferredHeight: root.implicitHeight - 2 * Metrics.edgePadding}
      Rectangle{
        Layout.preferredWidth: Metrics.spacerWidth
        Layout.fillHeight: true
        color: Colors.border
        radius: Layout.preferredWidth / 2
        antialiasing: true
      }
      Item{width:3}
      ColumnLayout{
        id: textCol
        spacing: 12

        RowLayout{
          spacing: 4
          Item{
            Layout.preferredHeight: gpuIcon.implicitHeight
            Text{
              id: gpuIcon
              anchors.centerIn: parent
              text: String.fromCodePoint(0xf035b)
              color: Colors.green
              font.family: Metrics.iconFont
              font.pixelSize: Metrics.textSize / Metrics.textSizeMult
            }
          }
          Text{
            text: " GPU: " + (usageVal).toFixed(1) + " %"
            color: Colors.green
            font{
              family: Metrics.numberFont
              pixelSize: Metrics.textSize / Metrics.textSizeMult
              features: { "tnum": 1 }
            }
          }
        }

        RowLayout{
          spacing: 4
          Item{
            Layout.preferredHeight: tmpIcon.implicitHeight
            Text{
              id: tmpIcon
              anchors.centerIn: parent
              text: String.fromCodePoint(0xf050f)
              color: Colors.red
              font.family: Metrics.iconFont
              font.pixelSize: Metrics.textSize / Metrics.textSizeMult
            }
          }
          Text{
            text: " TMP: " + usageTemp + " " + String.fromCodePoint(0xe33e) + "C"
            color: Colors.red
            font{
              family: Metrics.numberFont
              pixelSize: Metrics.textSize / Metrics.textSizeMult
              features: { "tnum": 1 }
            }
          }
        }
      }
    }
  }
}
