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
  property var appointmentsList: []

  SystemClock { id: clock; precision: SystemClock.Minutes }
  property int currentTimeMinutes: clock.hours * 60 + clock.minutes

  function getColorFromUrgency (startTime, endTime) { // time in format HH:MM
    let startTimeMinutes =  parseInt(startTime.slice(0,2)) * 60 + parseInt(startTime.slice(3))
    let endTimeMinutes =  parseInt(endTime.slice(0,2)) * 60 + parseInt(endTime.slice(3))
    let timeBeforeStart = startTimeMinutes - currentTimeMinutes
    let timebeforeEnd = endTimeMinutes - currentTimeMinutes

    if (timebeforeEnd < 0) {return Colors.textDim}

    if (timeBeforeStart < 0) {return Colors.blue}
    if (timeBeforeStart < 30) {return Colors.red}
    if (timeBeforeStart < 180) {return Colors.yellow}
    if (timeBeforeStart < 720) {return Colors.green}
    return Colors.text
  }

  Process {
    id: getAppointmentsList
    running: true
    command: ["calcurse", "-a"]
    stdout: StdioCollector{
      onStreamFinished: {
        let noTabs = text.replace(/\t/g, '')
        let lines = noTabs.split('\n').slice(1, -1)
        let newList = []
        for (let i = 0; i < lines.length; i += 2) {
          let linesTop = lines[i]
          let linesBottom = lines[i+1]
          newList.push(linesTop.slice(2) + ": " + linesBottom)
        }
        appointmentsList = newList
      }
    }
  }

  MouseArea{
    anchors.fill: parent
    onClicked: {
      getAppointmentsList.running = true
    }
  }

  Timer {
    id: getAppointmetnsListTimer
    interval: 10000
    repeat: true
    running: true
    triggeredOnStart: true
    onTriggered: getAppointmentsList.running = true
  }

  ColumnLayout{
    id: textCol
    anchors.fill: parent
    anchors.margins: Metrics.edgePadding
    spacing: Metrics.spacingInMenu
    Text {
      text: "Appointments"
      color: Colors.text
      font {
        family: Metrics.textFont
        pixelSize: Metrics.textSize
        weight: 500
      }
    }
    Rectangle{height: Metrics.spacerWidth; color: Colors.textDim; implicitWidth: parent.width; Layout.alignment: Qt.AlignHCenter; radius: 1; antialiasing: true}


    Repeater{
      model: appointmentsList
      delegate: RowLayout
      Text {
        property string textString: appointmentsList[index].slice(1).replace('..:..', '00:00')
        text: textString ?? ""
        Layout.preferredWidth: textCol.width
        color: getColorFromUrgency(textString.slice(0,5), textString.slice(9,14))
        wrapMode: Text.Wrap
        font {
          family: Metrics.textFont
          pixelSize: Metrics.textSize / Metrics.textSizeMult
          features: { "tnum": 1 }
        }
      }
    }
    Item {Layout.fillHeight:true}
  }
}
