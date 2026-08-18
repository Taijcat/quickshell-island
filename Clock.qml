import Quickshell
import QtQuick
import "Config"
import "Island"

Text {
  id:root
  signal clicked()
  visible: IslandState.activeModule === IslandTypes.Module.Clock
  text: Qt.formatDateTime(clock.date, "hh:mm")
  color: Colors.text

  font {
    family: "Google Sans Flex"
    letterSpacing: -0.5
    pixelSize: 15
    weight: 600
  }

  SystemClock { id: clock; precision: SystemClock.Minutes }

  MouseArea {
    anchors.fill: parent
    onClicked: root.clicked()
  }
}

