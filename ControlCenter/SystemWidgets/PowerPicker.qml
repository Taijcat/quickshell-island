import Quickshell
import QtQuick
import QtQuick.Layouts
import "../../Config"

RowLayout {
  id: root
  spacing: 0
  required property int length
  implicitWidth: length

  property var buttons: [
    buttonComponent.createObject(root, { icon: 0xf0425, onClicked: () => console.log("power"), isActive: false, activeColor: Colors.error }),
    buttonComponent.createObject(root, { icon: 0xf0709, onClicked: () => console.log("restart"), isActive: false, activeColor: Colors.success }),
    buttonComponent.createObject(root, { icon: 0xf03e4, onClicked: () => console.log("pause"), isActive: false, activeColor: Colors.info }),
    buttonComponent.createObject(root, { icon: 0xf0343, onClicked: () => console.log("log out"), isActive: false, activeColor: Colors.hint }),
    buttonComponent.createObject(root, { icon: 0xf033e, onClicked: () => console.log("lock"), isActive: false, activeColor: Colors.accent })
  ]

  Component {
    id: buttonComponent
    QtObject {
      property int icon
      property var onClicked
      property bool isActive
      property color activeColor
    }
  }

  component ComponentButton: Rectangle {
    id: buttonRect
    property var buttonData: null
    color: mouseArea.containsMouse ? (buttonData.isActive ? buttonData.activeColor : Colors.overlay ) : ( buttonData.isActive ? buttonData.activeColor : Colors.surface )
    radius: Metrics.roundingRadius
    border.color: mouseArea.containsMouse ? buttonData.activeColor : Colors.border
    implicitHeight: Metrics.textSize + Metrics.edgePadding * 2
    implicitWidth: Metrics.textSize + Metrics.edgePadding * 2

    Rectangle {
      id: flashOverlay
      anchors.fill: parent
      radius: parent.radius
      color: Colors.base
      border.color: mouseArea.containsMouse ? buttonData.activeColor : Colors.border
      opacity: 0
      SequentialAnimation {
        id: flash
        NumberAnimation { target: flashOverlay; property: "opacity"; to: 1; duration: Metrics.animationLength }
        NumberAnimation { target: flashOverlay; property: "opacity"; to: 0; duration: Metrics.animationLength }
      }
    }

    Text {
      text: String.fromCodePoint(buttonRect.buttonData.icon)
      anchors.centerIn: parent
      color: buttonData.isActive ? Colors.accentText : buttonData.activeColor
      font {
        family: Metrics.iconFont
        pixelSize: Metrics.textSize
      }
    }

    MouseArea {
      id: mouseArea
      anchors.fill: parent
      hoverEnabled: true
      acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
      onClicked: (mouse) => {
        if (mouse.button == Qt.LeftButton) { buttonData.isActive ? buttonRect.buttonData.onClicked() : flash.start() }
        if (mouse.button == Qt.RightButton) { buttonData.isActive = !buttonData.isActive }
      }
    }

    Behavior on color { ColorAnimation { duration: Metrics.animationLength } }
  }

  ComponentButton { buttonData: buttons[0] }
  Item {Layout.fillWidth: true}
  ComponentButton { buttonData: buttons[1] }
  Item {Layout.fillWidth: true}
  ComponentButton { buttonData: buttons[2] }
  Item {Layout.fillWidth: true}
  ComponentButton { buttonData: buttons[3] }
  Item {Layout.fillWidth: true}
  ComponentButton { buttonData: buttons[4] }
}
