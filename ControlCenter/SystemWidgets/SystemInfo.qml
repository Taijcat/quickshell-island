import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../../Config"

Rectangle{
  id: root
  required property int spanW
  required property int spanH
  property var fetchOutput: []
  implicitWidth: Functions.spanToWidth(spanW)
  implicitHeight: Functions.spanToWidth(spanH)
  color: Colors.surface
  radius: Metrics.roundingRadius

  Process {
    id: fetchProc
    command: ["fastfetch", "--pipe", "--logo", "none"]
    stdout: SplitParser {
      onRead: data => fetchOutput = [...fetchOutput, data]
    }
    running: true
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    onClicked: {
      fetchProc.running = true
      console.log(fetchOutput)
    }
  }

  ColumnLayout {
    anchors.verticalCenter: parent.verticalCenter
    anchors.margins: Metrics.edgePadding
    spacing: Metrics.spacingInMenu
    Repeater {
      model: Metrics.fetchLines
      delegate: Text {
        text: fetchOutput[modelData] ?? ""
        color: "white"
        font {
          family: Metrics.textFont
          pixelSize: Metrics.textSize / (Metrics.textSizeMult * Metrics.textSizeMult)
        }
      }
    }
  }
}
