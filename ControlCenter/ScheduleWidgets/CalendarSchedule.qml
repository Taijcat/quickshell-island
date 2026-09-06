import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../../Config"

Rectangle{
  color: "#282828"
  implicitHeight: 56
  implicitWidth: 56
  border.color: Colors.border

  Process {
  }

  MouseArea{
    anchors.fill: parent
    onClicked: (console.log("Foobar"))
  }
}
