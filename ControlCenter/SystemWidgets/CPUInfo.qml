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
    id: cpuProc
    command: ["sh", "-c", "top -bn1 | grep '%Cpu(s)' | awk '{print 100 - $8}'"]
    stdout: StdioCollector {
      onStreamFinished: {
        const val = parseFloat(text)
        if (!isNaN(val)) {
          usageVal = val.toFixed(5) / 100
          let newArr = usageArr.slice(1)
          newArr.push(usageVal)
          usageArr = newArr
        }
      }
    }
  }

  Process {
    id: tempProc
    command: ["sh", "-c", "sensors | grep -m1 -E 'Package id 0|Tctl|Tdie' | grep -oE '[0-9]+\\.[0-9]+' | head -1"]
    stdout: StdioCollector {
      onStreamFinished: {
        const val = parseFloat(text)
        if (!isNaN(val)) usageTemp = val
      }
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      cpuProc.running = true
      tempProc.running = true
    }
  }

  MouseArea{
    anchors.fill: parent
    onClicked: console.log(usageArr)
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
          Layout.preferredHeight: ((root.implicitHeight - 2 * Metrics.edgePadding) * usageArr[index])
          Layout.preferredWidth: Metrics.usageBarWidthSystem
          radius: Layout.preferredWidth / 2
          color: Colors.blue
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
            Layout.preferredHeight: cpuIcon.implicitHeight
            Text{
              id: cpuIcon
              anchors.centerIn: parent
              text: String.fromCodePoint(0xf0ee0)
              color: Colors.blue
              font.family: Metrics.iconFont
              font.pixelSize: Metrics.textSize / Metrics.textSizeMult
            }
          }
          Text{
            text: " CPU: " + usageVal.toFixed(2) + " %"
            color: Colors.blue
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
