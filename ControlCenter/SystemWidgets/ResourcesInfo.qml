import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../../Config"

Rectangle{
  id: root
  required property int spanW
  required property int spanH
  property real usedDisk: 1.0
  property real totalDisk: 1.0
  property real usedRAM: 1.0
  property real totalRAM: 1.0

  implicitHeight: Functions.spanToHeight(spanH)
  implicitWidth: Functions.spanToWidth(spanW)
  radius: Metrics.roundingRadius
  color: Colors.surface

  Process{
    id: procRAM
    command: ["sh", "-c", "top -bn1 | grep 'MiB Mem' | awk '{print $6 \" \" $4}'"]
    stdout: StdioCollector {
      onStreamFinished: {
        let vals = this.text.trim().split(" ")
        usedRAM = parseFloat(vals[0] / 1000)
        totalRAM = parseFloat(vals[1] / 1000)
      }
    }
  }

  Process{
    id: procDisk
    command: ["sh", "-c", "df -h | sed -n 2p | awk '{print $3 \" \" $2}'"]
    stdout: StdioCollector {
      onStreamFinished: {
        let vals = this.text.trim().split(" ")
        usedDisk = parseFloat(vals[0].slice(0, -1))
        totalDisk = parseFloat(vals[1].slice(0, -1) )
      }
    }
  }

  Timer {
    interval: 5000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      procDisk.running = true
      procRAM.running = true
    }
  }

  MouseArea{
    anchors.fill: parent
    onClicked: {
      console.log(usageRAM + "\n" + usageDisk)
    }
  }

  ColumnLayout{
    anchors.fill: parent
    anchors.margins: Metrics.edgePadding
    Rectangle{
      Layout.fillHeight: true
      Layout.fillWidth: true
      color: "transparent"
      Text{
        anchors.centerIn: parent
        text: String.fromCodePoint(0xf0126) + "  Disk: " + usedDisk + " G / " + totalDisk + " G (" + Math.round((usedDisk / totalDisk) * 100) + "%)"
        color: Colors.text
        font{
          family: Metrics.numberFont
          pixelSize: Metrics.textSize / Metrics.textSizeMult
        }
      }
    }
    Rectangle{
      Layout.fillWidth: true
      implicitHeight: Metrics.spacerWidth
      color: Colors.border
    }
    Rectangle{
      Layout.fillHeight: true
      Layout.fillWidth: true
      color: "transparent"
      Text{
        anchors.centerIn: parent
        text: String.fromCodePoint(0xf09d1) + "  RAM: " + usedRAM.toFixed(1) + " G / " + totalRAM.toFixed(1) + " G (" + ((usedRAM / totalRAM) * 100).toFixed(1) + "%)"
        color: Colors.text
        font{
          family: Metrics.numberFont
          pixelSize: Metrics.textSize / Metrics.textSizeMult
        }
      }
    }
  }
}
