import QtQuick
import QtQuick.Effects
import "../../Config"

Rectangle{
  id: root
  required property int spanW
  required property int spanH
  property var colorAArray: [Colors.red, Colors.blue ,Colors.yellow]
  property var colorBArray: [Colors.green, Colors.orange, Colors.purple]
  property string colorA: colorAArray[0]
  property string colorB: colorBArray[0]
  property int colorNum: colorAArray.length
  property int colorIndex: 0
  radius: Metrics.roundingRadius
  implicitWidth: Functions.spanToWidth(spanW)
  implicitHeight: Functions.spanToHeight(spanH)

  //color: mouseArea.containsMouse? Colors.overlay : Colors.surface
  //border.color: mouseArea.containsMouse ? Colors.accent : Colors.border

  Behavior on colorA { ColorAnimation {duration: 4000} }
  Behavior on colorB { ColorAnimation {duration: 4000} }

  gradient: Gradient {
    GradientStop { position: 0.0; color: colorA}
    GradientStop { position: 1.0; color: colorB}
  }


  Timer{
    interval: 4000
    repeat: true
    running: true
    triggeredOnStart: true
    onTriggered: {
      (colorIndex) < (colorNum - 1) ? colorIndex++ : colorIndex = 0
      colorA = colorAArray[colorIndex]
      colorB = colorBArray[colorIndex]
    }
  }


  MouseArea{
    anchors.fill: parent
    id: mouseArea
    hoverEnabled: true
    onClicked: console.log(colorIndex)
  }
}
