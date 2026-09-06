import QtQuick
import QtQuick.Controls
import "../../Config"

Rectangle{
  id: root
  required property int spanW
  required property int spanH
  radius: Metrics.roundingRadius
  implicitWidth: Functions.spanToWidth(spanW)
  implicitHeight: Functions.spanToHeight(spanH)
  color: mouseArea.containsMouse? Colors.overlay : Colors.surface
  border.color: mouseArea.containsMouse ? Colors.accent : Colors.border

  Behavior on color {
    ColorAnimation {duration: Metrics.animationLength}
  }

  MouseArea{
    anchors.fill: parent
    id: mouseArea
    hoverEnabled: true
  }

  TextField{
    anchors.fill: parent
    anchors.margins: Metrics.edgePadding
    placeholderText: qsTr("Type away...")
    wrapMode: TextEdit.Wrap
    font{
      family: Metrics.textFont
      pixelSize: Metrics.textSize / Metrics.textSizeMult
    }

    background: Rectangle{
      color: "transparent"; border.color: "transparent"
    }

  }
}
