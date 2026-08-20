import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../../Config/"

Rectangle{
  id: root
  color: Colors.surface
  border.color: Colors.border
  radius: Metrics.roundingRadius
  implicitHeight: content.height
  implicitWidth: Metrics.avBarWidthHome
  property var barValues: Array(Metrics.avBarCountHome).fill(0)

  MouseArea{
    id: regenerateCava
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: (mouse) => {
      if (mouse.button == Qt.LeftButton) { killCava.running = true }
      if (mouse.button == Qt.RightButton) {
        killNoRegen.running = true 
        root.barValues = Array(root.barCount).fill(0)
      }
    }
  }

  Process{
    id: killNoRegen
    command: ["pkill", "cava"]
  }

  Process{
    id: killCava
    command: ["pkill", "cava"]
    onExited: deleteCavaConfig.running = true
  }

  Process {
    id: deleteCavaConfig
    command: ["rm", "-f", "/tmp/quickshell-cava.conf"]
    onExited: writeCavaConfig.running = true
  }

  Process {
    id: cava
    command: ["cava", "-p", "/tmp/quickshell-cava.conf"]
    stdout: SplitParser {
      onRead: data => {
        const values = data.split(";")
        root.barValues = values
      }
    }
  }

  Process{
  id: writeCavaConfig
  command: ["bash", "-c",
  `cat > /tmp/quickshell-cava.conf << 'EOF'
[general]
bars = ${Metrics.avBarCountHome}
framerate = 60

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 100
bar_delimiter = 59
frame_delimiter = 10

[smoothing]
noise_reduction = 80
monstercat = 1
scientific = 1
EOF
`]
  onExited: cava.running = true
}

  ColumnLayout{
    id: bars
    anchors.centerIn: parent
    spacing: Metrics.avBarSpacingHome

    Repeater {
      model: Metrics.avBarCountHome
      Rectangle{
        Layout.alignment: Qt.AlignCenter
        required property int index
        implicitWidth: Math.max(Metrics.avBarHeightHome, Math.min(
          root.barValues[index] * 0.01 * root.width,
          root.width - implicitHeight * 2
        )
      )
      implicitHeight: Metrics.avBarHeightHome
      radius: Metrics.avBarHeightHome / 2
      color: Colors.text
    }
  }
}
}
