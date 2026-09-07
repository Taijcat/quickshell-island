import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../../Config/"

RowLayout{
  id: root
  spacing: Metrics.spacingInMenu

  property date today: new Date()
  function journalName() {
    let day = (today.getDate() < 10) ? ("0" + today.getDate()) : (today.getDate())
    let month = ((today.getMonth() + 1) < 10) ? ("0" + (today.getMonth() + 1)) : (today.getMonth() + 1)

    return today.getFullYear() + "-" + month + "-" + day + ".md"
  }

  property string wcCommand: "wc -w " + Metrics.journalPath + journalName()
  property int wordCount: 0

    Process {
    id: getJournalLinecount
    command: ["sh", "-c", wcCommand]
    stdout: StdioCollector {
      onStreamFinished: {
        let textSplit = text.split(" ")
        wordCount = parseInt(textSplit[0]) === NaN ? 0 : parseInt(textSplit[0])
      }
    }
  }

  property real level: Math.min(wordCount, Metrics.journalWordGoal) / Metrics.journalWordGoal

  Timer {
    interval: 10000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      getJournalLinecount.running = true
    }
  }

  Text{
    text: level === 1 ? String.fromCodePoint(0xf14f6) : String.fromCodePoint(0xf14e9)
    color: level === 1.0 ? Colors.aqua : Colors.yellow
    Layout.alignment: Qt.AlignVCenter

    font {
      family: Metrics.iconFont
      pixelSize: Metrics.textSize * Metrics.textSizeMult
    }

    MouseArea{
      anchors.fill: parent
      onClicked: getJournalLinecount.running = true, console.log(level)
    }
  }

  Rectangle {
    Layout.fillWidth: true
    implicitHeight: Metrics.textSize / 3
    color: Colors.surface
    radius: height/2
    Rectangle{
      implicitHeight: parent.implicitHeight
      color: level === 1.0 ? Colors.aqua : Colors.yellow
      radius: height/2
      width: parent.width * level

    }
    Rectangle{
      anchors.verticalCenter: parent.verticalCenter
      implicitHeight: Metrics.textSize
      implicitWidth: Metrics.textSize
      radius: height / 2
      color: Colors.text
      x: parent.width * level - width / 2
    }
  }

  Item {}

  Text {
    text: journalName()
    color: level === 1.0 ? Colors.aqua : Colors.yellow
    font {
      family: Metrics.textFont
      pixelSize: Metrics.textSize
    }
  }
}
