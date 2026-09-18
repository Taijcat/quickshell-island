import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../../Config"
import "../../Island"

PopupWindow{
  id: root
  color: "transparent"

  // PopUp Logic
  required property var anchorWindow
  property bool menuOpen: false
  property var target: null
  visible: menuOpen
  grabFocus: true

  implicitWidth: content.implicitWidth * Metrics.easingHeadroom
  implicitHeight: content.implicitHeight * Metrics.easingHeadroom

  anchor.window: anchorWindow
  anchor.rect.x: anchorWindow.width / 2 - root.width / 2
  anchor.rect.y: anchorWindow.height / 2 - root.height / 2

  Connections {
    target: root.target
    function onAdd() {
      root.menuOpen = true
    }
  }

  FileView {
    id: readingListFile
    path: Qt.resolvedUrl("../../books.json")
    watchChanges: true
    onFileChanged: reload()


    onLoaded: {
      let parsedFile = JSON.parse(readingListFile.text())
    }
  }

  function addBook() {
    let data = JSON.parse(readingListFile.text())

    data.books.push({
      "title": titleTextbox.text,
      "author": authorTextBox.text,
      "totalPages": totalPageTextBox.text,
      "currentPage": currentPageTextBox.text,
      "status": "test_sts"
    })

    readingListFile.setText(JSON.stringify(data, null, 2))
  }


  Shortcut {
    sequence: "Escape"
    enabled: root.visible
    onActivated: {
      menuOpen = false
      IslandState.show(IslandTypes.Module.Home)
    }
  }

  onVisibleChanged: {
    menuOpen = visible
  }

  Rectangle{
    id: content
    anchors.centerIn: parent
    color: Colors.base
    border.color: Colors.border
    radius: Metrics.roundingRadius

    implicitHeight: listCol.implicitHeight + 2 * Metrics.edgePadding
    implicitWidth: Metrics.popUpMenuWidth

    scale: root.menuOpen ? 1.0 : 0.4
    Behavior on scale {
      NumberAnimation {
        duration: Metrics.animationLength
        easing.type: Easing.OutBack
        easing.overshoot: Metrics.easingHeadroom
      }
    }

    ColumnLayout {
      id: listCol
      anchors.fill: parent
      anchors.margins: Metrics.edgePadding
      spacing: Metrics.spacingInMenu

          RowLayout{
        Text {
          text: "Add a new Book"
          color: Colors.text
          font {
            family: Metrics.textFont
            pixelSize: Metrics.textSize * Metrics.textSizeMult
            weight: 500
          }
        } 
        Item{Layout.fillWidth: true}
        Rectangle{
          Layout.preferredWidth: Math.max( acceptSign.width, acceptSign.height )
          Layout.preferredHeight: Math.max( acceptSign.width, acceptSign.height )
          radius: Metrics.roundingRadius
          border.color: acceptMouseArea.containsMouse ? Colors.accent : Colors.border
          color: acceptMouseArea.containsMouse ? Colors.overlay : Colors.surface
          Behavior on color {
            ColorAnimation{duration: Metrics.animationLength}
          }
          MouseArea{
            id: acceptMouseArea
            hoverEnabled: true
            anchors.fill: parent
            onClicked: {
              root.addBook()
              menuOpen = false
              IslandState.show(IslandTypes.Module.Home)
            }
          }
          Text{
            anchors.centerIn: parent
            id: acceptSign
            text: String.fromCodePoint(0xf012c)
            color: Colors.text
            font{
              family: Metrics.iconFont
              pixelSize: Metrics.iconSize / Metrics.iconSizeMult
            }
          }
        }
      }
      Rectangle{height: 1; color: Colors.textDim; implicitWidth: parent.width; Layout.alignment: Qt.AlignHCenter; radius: 1; antialiasing: true}
      Item {}
      RowLayout{
        Text{
          text: "Title: "
          color: Colors.text
          font{
            family: Metrics.textFont
            pixelSize: Metrics.textSize
          }
        }
        TextField {
          id: titleTextbox
          placeholderText: "Enter Title"
          color: Colors.textDim
          palette.placeholderText: Colors.textDim
          font.family: Metrics.textFont
          font.pixelSize: Metrics.textSize
          onAccepted: {
            console.log(text)
          }
          background: Rectangle{color: "transparent"}
        }
      }
      RowLayout{
        Text{
          text: "Author: "
          color: Colors.text
          font{
            family: Metrics.textFont
            pixelSize: Metrics.textSize
          }
        }
        TextField {
          id: authorTextBox
          placeholderText: "Enter Author"
          color: Colors.textDim
          palette.placeholderText: Colors.textDim
          font.family: Metrics.textFont
          font.pixelSize: Metrics.textSize
          onAccepted: {
            console.log(text)
          }
          background: Rectangle{color: "transparent"}
        }
      }
      RowLayout{
        Text{
          text: "Current Page: "
          color: Colors.text
          font{
            family: Metrics.textFont
            pixelSize: Metrics.textSize
          }
        }
        TextField {
          id: currentPageTextBox
          placeholderText: "Enter Current Page"
          color: Colors.textDim
          palette.placeholderText: Colors.textDim
          font.family: Metrics.textFont
          font.pixelSize: Metrics.textSize
          onAccepted: {
            console.log(text)
          }
          validator: IntValidator {
            bottom: 0
            top: 999
          }
          background: Rectangle{color: "transparent"}
        }
      }
            RowLayout{
        Text{
          text: "Total Pages: "
          color: Colors.text
          font{
            family: Metrics.textFont
            pixelSize: Metrics.textSize
          }
        }
        TextField {
          id: totalPageTextBox
          placeholderText: "Enter Total Pages"
          color: Colors.textDim
          palette.placeholderText: Colors.textDim
          font.family: Metrics.textFont
          font.pixelSize: Metrics.textSize
          onAccepted: {
            console.log(text)
          }
          validator: IntValidator {
            bottom: 0
            top: 999
          }
          background: Rectangle{color: "transparent"}
        }
      }
    }
  }
}
