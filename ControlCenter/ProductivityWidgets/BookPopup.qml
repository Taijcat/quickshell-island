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
  property int chosenBook: 0
  property var bookData: []
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
    function onClicked() {
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
      root.bookData = parsedFile.books
    }
  }

  function changeCurrentPage(newPage) {
    var dataBookChange = JSON.parse(readingListFile.text())
    dataBookChange.books[chosenBook].currentPage = newPage
    readingListFile.setText(JSON.stringify(dataBookChange, null, 2))
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

      Text {
        text: root.bookData.length > 1 ? root.bookData[chosenBook].title : ""
        color: Colors.text
        font {
          family: Metrics.textFont
          pixelSize: Metrics.textSize * Metrics.textSizeMult
          weight: 500
        }
      }
      Text{
        text: root.bookData.length > 0 ? root.bookData[chosenBook].author: ""
        color: Colors.textDim
        wrapMode: Text.WordWrap
        font.family: Metrics.textFont
        font.pixelSize: Metrics.textSize
      }

      Rectangle{height: 1; color: Colors.textDim; implicitWidth: parent.width; Layout.alignment: Qt.AlignHCenter; radius: 1; antialiasing: true}
      Item {}
      Rectangle {
        id: fieldBox
        color: Colors.surface
        border.color: pageInput.activeFocus ? Colors.accent : Colors.border
        radius: Metrics.roundingRadius
        implicitWidth: rowContent.implicitWidth + Metrics.edgePadding * 2
        implicitHeight: rowContent.implicitHeight + Metrics.edgePadding

        RowLayout {
          id: rowContent
          anchors.centerIn: parent
          spacing: 2

          Text {
            text: "Page: "
            color: Colors.text
            font.family: Metrics.textFont
            font.pixelSize: Metrics.textSize
          }

          TextField {
            id: pageInput
            placeholderText: root.bookData.length > 0 ? String(root.bookData[chosenBook].currentPage) : ""
            color: Colors.textDim
            palette.placeholderText: Colors.textDim
            font.family: Metrics.textFont
            font.pixelSize: Metrics.textSize
            validator: IntValidator {
              bottom: 0
              top: 999
            }
            onAccepted: changeCurrentPage(parseInt(pageInput.text))
            background: Rectangle{color: "transparent"}
          }

          Text {
            text: root.bookData.length > 0 ? " / " + root.bookData[chosenBook].totalPages : ""
            color: Colors.text
            font.family: Metrics.textFont
            font.pixelSize: Metrics.textSize
          }
        }
      }
    }
  }
}
