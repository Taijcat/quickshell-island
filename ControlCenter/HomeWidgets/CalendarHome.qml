import QtQuick
import QtQuick.Layouts
import "../../Config"

Rectangle {
  id: root
  required property int spanH
  required property int spanW
  implicitWidth: Functions.spanToWidth(spanW)
  implicitHeight: Functions.spanToHeight(spanH)
  radius: Metrics.roundingRadius

  color: mouseArea.containsMouse ? Colors.overlay : Colors.surface
  border.color: mouseArea.containsMouse ? Colors.accent : Colors.border

  SequentialAnimation {
    id: flash
    ColorAnimation { target: root; property: "color"; to: Colors.accent; duration: Metrics.animationLength }
    ColorAnimation { target: root; property: "color"; to: Colors.surface; duration: Metrics.animationLength }
  }

  MouseArea{
    id:mouseArea
    anchors.fill: parent
    hoverEnabled: true
  }

  Behavior on color {
    ColorAnimation {duration: Metrics.animationLength}
  }

  property date viewDate: new Date()
  property date today: new Date()

  // DATE LOGIC
  function monthName(d) {
    return d.toLocaleDateString(Qt.locale(), "MMMM yyyy")
  }

  function nextMonth() {
    var d = new Date(viewDate)
    d.setMonth(d.getMonth() + 1)
    viewDate = d
  }

  function prevMonth() {
    var d = new Date(viewDate)
    d.setMonth(d.getMonth() - 1)
    viewDate = d
  }

  function gridCells() {
    var year = viewDate.getFullYear()
    var month = viewDate.getMonth()
    var firstDay = new Date(year, month, 1)
    var startOffset = firstDay.getDay()
    var daysInMonth = new Date(year, month + 1, 0).getDate()

    var cells = []
    for (var i = 0; i < startOffset; i++) cells.push(null)
    for (var d = 1; d <= daysInMonth; d++) cells.push(d)
    while (cells.length < 42) cells.push(null)
    return cells
  }

  function isToday(day) {
    return day === today.getDate()
    && viewDate.getMonth() === today.getMonth()
    && viewDate.getFullYear() === today.getFullYear()
  }


  ColumnLayout{
    id:content
    anchors.centerIn: parent

    RowLayout{
      id:topText
      Layout.fillWidth: true
      Text{
        text: String.fromCodePoint(0xf0141)
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: Colors.text
        font{
          family: Metrics.iconFont
          weight: Metrics.fontBold
          pixelSize: Metrics.textSize * 1.5
        }
        MouseArea { anchors.fill: parent; onClicked: root.prevMonth() }
      }

      Text{
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: root.monthName(root.viewDate)
        color: Colors.text

        font{
          family: Metrics.textFont
          weight: Metrics.fontBold
          pixelSize: Metrics.textSize
        }

        MouseArea {
          anchors.fill: parent
          onWheel: (wheel) => {
            if (wheel.angleDelta.y > 0) { root.nextMonth() }
            if (wheel.angleDelta.y < 0) { root.prevMonth() }
          }
          onClicked: {
            viewDate.setMonth(today.getMonth())
            viewDate.setYear(today.getFullYear())
            flash.start()
          }
        }

      }
      Text{
        text: String.fromCodePoint(0xf0142)
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: Colors.text
        font{
          family: Metrics.iconFont
          weight: Metrics.fontBold
          pixelSize: Metrics.textSize * 1.5
        }
        MouseArea { anchors.fill: parent; onClicked: root.nextMonth() }
      }
    }
    GridLayout {
      Layout.fillWidth: true
      columns: 7
      Repeater{
        model: ["S", "M", "T", "W", "T", "F", "S"]
        Text{
          text: modelData
          Layout.fillWidth: true
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          color: index === 0 ? Colors.error : Colors.text
        }
      }
      Repeater {
        model: root.gridCells()
        Rectangle {
          Layout.fillWidth: true   // each cell shares leftover width equally
          Layout.preferredHeight: text.height + Metrics.buttonPadding
          Layout.preferredWidth: text.height + Metrics.buttonPadding
          radius: Metrics.textSize / Metrics.textSizeMult * 0.4
          color: modelData && root.isToday(modelData)
          ? Colors.accent
          : "transparent"
          Text {
            id:text
            anchors.centerIn: parent
            text: modelData
            color: index % 7 === 0 ? Colors.error : Colors.text
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font{
              family: Metrics.textFont
              weight: Metrics.fontBold
              pixelSize: Metrics.textSize / Metrics.textSizeMult
            }
          }
        }
      }
    }
  }
}
