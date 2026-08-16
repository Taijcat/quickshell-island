import Quickshell
import QtQuick
import QtQuick.Layouts
import "../../Config"

// Boilerplate code for a button. For use in debugging and writing actually good buttons.
Rectangle {
  property bool isActive: false

  property string buttonColor: {
    if (isActive) { return mouseArea.containsMouse ? Colors.hint : Colors.accent }
    if (!isActive) { return mouseArea.containsMouse ? Colors.overlay : Colors.surface }
  }

  property string borderColor: {
    if (isActive) { return mouseArea.containsMouse ? Colors.hint : Colors.accent }
    if (!isActive) { return mouseArea.containsMouse ? Colors.accent : Colors.border }
  }

  Layout.preferredWidth: 56
  Layout.preferredHeight: 56
  antialiasing: true
  radius: Metrics.roundingRadius
  color: buttonColor
  border.color: borderColor

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    onClicked: {
      isActive = !isActive
    }
  }

  Behavior on color {
    ColorAnimation {duration: Metrics.animationLength}
  }
}
