import QtQuick
import QtQuick.Effects
import "../../Config"

Rectangle{
  id: root
  property int span: 3
  implicitHeight: Functions.spanToHeight(span)
  implicitWidth: Functions.spanToWidth(span)
  color: Colors.surface
  radius: Metrics.roundingRadius
  //border.color: Colors.border
  Item {
    anchors.centerIn: parent
    width: icon.width
    height: icon.height

    Image {
      id: icon
      property int dimensions: Functions.spanToWidth(span) - Metrics.edgePadding * 2
      anchors.fill: parent
      source: Qt.resolvedUrl("../../Assets/arch-logo.svg")
      visible: false
      width: dimensions
      height: dimensions
      sourceSize.width: dimensions
      sourceSize.height: dimensions
    }


    MultiEffect {
      anchors.fill: parent
      source: icon
      colorization: 1.0
      colorizationColor: Colors.text
    }
  }
}
