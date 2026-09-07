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

  property int refreshIntervalMs: 15 * 60 * 1000

    Timer {
    interval: root.refreshIntervalMs
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.fetchWeather()
  }

  property string condition: "Loading…"

  function weatherIcon(condition) {
    const c = condition.toLowerCase()
    if (c.includes("thunder"))                      return String.fromCodePoint(0xe31d) // 
    if (c.includes("snow") || c.includes("sleet"))   return String.fromCodePoint(0xe31a) // 
    if (c.includes("rain") || c.includes("drizzle")) return String.fromCodePoint(0xe318) // 
    if (c.includes("fog") || c.includes("mist") || c.includes("haze")) return String.fromCodePoint(0xf0591) // 
    if (c.includes("overcast"))                      return String.fromCodePoint(0xe30c) // 
    if (c.includes("cloud"))                         return String.fromCodePoint(0xe312) // 
    if (c.includes("sunny") || c.includes("clear"))   return String.fromCodePoint(0xe30d) // 
    return String.fromCodePoint(0xf00d) // fallback
  }

  function reqListener(req) {
    const weatherData = JSON.parse(req.responseText)
    const current = weatherData.current_condition[0]
    root.condition = current.weatherDesc[0].value
  }

  function fetchWeather() {
    const req = new XMLHttpRequest()
    req.onreadystatechange = function () {
      if (req.readyState === XMLHttpRequest.DONE) {
        reqListener(req)
      }
    }
    req.open("GET", "https://wttr.in/?format=j1")
    req.setRequestHeader("Connection", "close")
    req.send()
  }

  MouseArea {
    anchors.fill: parent
    onClicked: {
      fetchWeather()
    }
  }


    RowLayout{
      anchors.fill: parent
      anchors.margins: Metrics.edgePadding
      spacing: Metrics.spacingInMenu
      Text{
        Layout.alignment: Qt.AlignVCenter
        text: root.weatherIcon(condition)
        color: Colors.text
        font {
          family: Metrics.iconFont
          pixelSize: Metrics.iconSize * Metrics.iconSizeMult
        }
      }
      Text{
      Layout.alignment: Qt.AlignVCenter
      text: root.condition
      color: Colors.text
      font {
        family: Metrics.textFont
        pixelSize: Metrics.iconSize
      }
    }
    Item{Layout.fillWidth:true}
  }
}
