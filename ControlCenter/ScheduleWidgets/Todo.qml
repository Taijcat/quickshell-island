import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../../Config"

Rectangle{
  color: "#282828"
  required property int spanW
  required property int spanH
  implicitHeight: Functions.spanToHeight(spanH)
  implicitWidth: Functions.spanToWidth(spanW)
  border.color: Colors.border
  radius: Metrics.roundingRadius
  property var taskList: []

  function getColorFromPriority(priority) {
    switch (priority) {
      case '0':
      return Colors.textDim
      case '1':
      return Colors.red
      case '2':
      return Colors.orange
      case '3':
      return Colors.yellow
      case '4':
      return Colors.green
      case '5':
      return Colors.blue
      default:
      return Colors.text
    }
  }

  Process {
    id: getTaskList
    running: true
    command: ["calcurse", "-Q"]
    stdout: StdioCollector{
      onStreamFinished: {
        let splitList = text.split('\n\n')
        let lines = splitList[0].split('\n')
        let newList = lines.slice(1)
        if (lines[0] != "to do:") {newList = []}
        taskList = newList
      }
    }
  }

  MouseArea{
    anchors.fill: parent
    onClicked: {
      getTaskList.running = true
    }
  }

  Timer {
    id: getTaskListTimer
    interval: 10000
    repeat: true
    running: true
    triggeredOnStart: true
    onTriggered: getTaskList.running = true
  }

  ColumnLayout{
    id: textCol
    anchors.fill: parent
    anchors.margins: Metrics.edgePadding
    spacing: Metrics.spacingInMenu
    Text {
      text: "To do"
      color: Colors.text
      font {
        family: Metrics.textFont
        pixelSize: Metrics.textSize
        weight: 500
      }
    }
    Rectangle{height: Metrics.spacerWidth; color: Colors.textDim; implicitWidth: parent.width; Layout.alignment: Qt.AlignHCenter; radius: 1; antialiasing: true}

    Repeater{
      model: taskList
      delegate: Text {
        property string textString: taskList[index]
        text: textString.slice(3) ?? ""
        Layout.preferredWidth: textCol.width
        color: getColorFromPriority(textString[0])
        wrapMode: Text.Wrap
        font {
          family: Metrics.textFont
          pixelSize: Metrics.textSize / Metrics.textSizeMult
        }
      }
    }
   Item {Layout.fillHeight:true}
  }
}
