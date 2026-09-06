import QtQuick
import QtQuick.Effects
import "../../Config"

Rectangle{
  id: root
  required property int spanW
  required property int spanH
  implicitWidth: Functions.spanToWidth(spanW)
  implicitHeight: Functions.spanToHeight(spanH)
  color: Colors.surface
  radius: Metrics.roundingRadius
  border.color: Colors.border
}
