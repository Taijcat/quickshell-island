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
  property var bookData: []
  property var target: null
  property int chosenBook: 0
  visible: menuOpen
  grabFocus: true

  implicitWidth: content.implicitWidth * Metrics.easingHeadroom
  implicitHeight: content.implicitHeight * Metrics.easingHeadroom

  anchor.window: anchorWindow
  anchor.rect.x: anchorWindow.width / 2 - root.width / 2
  anchor.rect.y: anchorWindow.height / 2 - root.height / 2

  signal clicked()

  Connections {
    target: root.target
    function onOpenLibrary() {
      root.menuOpen = true
    }
  }

  function parsePages(currentPage, totalPages) {
    if (currentPage < 10) {currentPage = "00" + currentPage}
    else if (currentPage < 100) {currentPage = "0" + currentPage}

    if (totalPages < 10) {totalPages = "00" + totalPages}
    else if (totalPages < 100) {totalPages = "0" + totalPages}

    return currentPage + "/" + totalPages
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
    implicitWidth: Metrics.popUpMenuWidth * 1.5

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
        text: "Available Books"
        color: Colors.text
        font {
          family: Metrics.textFont
          pixelSize: Metrics.textSize * Metrics.textSizeMult
          weight: 500
        }
      }
      Rectangle{height: 1; color: Colors.textDim; implicitWidth: parent.width; Layout.alignment: Qt.AlignHCenter; radius: 1; antialiasing: true}
      Item {}
          Repeater{
      model: bookData.length
      delegate: Rectangle{
        id: itemRect
        color:mouseArea.containsMouse ? Colors.overlay : Colors.surface
        border.color: mouseArea.containsMouse ? Colors.accent : Colors.border
        Layout.fillWidth: true
        radius: Metrics.roundingRadius
        implicitHeight: bookText.height + Metrics.spacingInMenu * 2

        Behavior on color {
          ColorAnimation{duration: Metrics.animationLength}
        }

        SequentialAnimation {
          id: flash
          ColorAnimation { target: itemRect; property: "color"; to: Colors.accent; duration: Metrics.animationLength }
          ColorAnimation { target: itemRect; property: "color"; to: Colors.surface; duration: Metrics.animationLength }
        }

        MouseArea{
          id:mouseArea
          anchors.fill: parent
          hoverEnabled: true
          onClicked: {
            flash.start()
            menuOpen = false
            root.chosenBook = index
            root.clicked()
          }
        }

        RowLayout{
          anchors.fill: parent
          anchors.margins: Metrics.spacingInMenu
          RowLayout{
            id: bookText
            spacing: Metrics.spacingInMenu

            Text{
              text: root.bookData.length > 0 ? root.bookData[index].title: ""
              color: Colors.text
              wrapMode: Text.WordWrap
              font.family: Metrics.textFont
              font.pixelSize: Metrics.textSize
            }
            Text{
              text: root.bookData.length > 0 ? "(" + root.bookData[index].author + ")" : ""
              color: Colors.textDim
              font.family: Metrics.textFont
              font.pixelSize: Metrics.textSize / Metrics.textSizeMult
            }
            Item{Layout.fillWidth: true}
            Text{
              text: root.bookData.length > 0 ? "[" + parsePages(bookData[index].currentPage, bookData[index].totalPages) + "]" : ""
              Layout.alignment: Qt.AlignVCenter
              color: Colors.text
              font.family: Metrics.numberFont
              font.pixelSize: Metrics.textSize
            }
            Item{}
          }
        }
      }
    }
    }
  }
}
