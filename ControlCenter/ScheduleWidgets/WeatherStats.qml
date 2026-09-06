import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../../Config"

Rectangle{
  id:root
  color: Colors.surface
  required property int spanW
  required property int spanH
  implicitHeight: Functions.spanToHeight(spanH)
  implicitWidth: Functions.spanToWidth(spanW)
  border.color: Colors.border
  radius: Metrics.roundingRadius

  property string temp: "--"
  property string tempFelt: "--"
  property string pressure: "--"
  property string humidity: "--"

  property int refreshIntervalMs: 15 * 60 * 1000

    Timer {
    interval: root.refreshIntervalMs
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.fetchWeather()
  }

  function reqListener(req) {
    const weatherData = JSON.parse(req.responseText)
    const current = weatherData.current_condition[0]
    root.temp = current.temp_C
    root.tempFelt = current.FeelsLikeC
    root.pressure = current.pressure + "mb"
    root.humidity = current.humidity + "%"
  }

  function fetchWeather() {
    const req = new XMLHttpRequest()
    req.onreadystatechange = function () {
      if (req.readyState === XMLHttpRequest.DONE) {
        reqListener(req)
      }
    }
    req.open("GET", "https://wttr.in/?format=j1")
    req.send()
  }

  MouseArea {
    anchors.fill: parent
    onClicked: {
      fetchWeather()
    }
  }


    ColumnLayout{
      anchors.fill: parent
      anchors.margins: Metrics.edgePadding
      spacing: Metrics.spacingInMenu
      Text{
      Layout.alignment: Qt.AlignVCenter
      text: String.fromCodePoint(0xf050f) + "  " + root.temp + String.fromCodePoint(0xe33e) + " (feels like " + root.tempFelt + String.fromCodePoint(0xe33e)+ ")"
      color: Colors.red
      font {
        family: Metrics.textFont
        pixelSize: Metrics.textSize / Metrics.textSizeMult
      }
    }
    Text{
      Layout.alignment: Qt.AlignVCenter
      text: String.fromCodePoint(0xf058c) + "  Humidity: " + root.humidity
      color: Colors.blue
      font {
        family: Metrics.textFont
        pixelSize: Metrics.textSize / Metrics.textSizeMult
      }
    }
  }
}
