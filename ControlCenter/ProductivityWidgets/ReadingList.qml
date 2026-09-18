import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../../Config"

Rectangle{
  id: root
  required property int spanW
  required property int spanH
  radius: Metrics.roundingRadius
  implicitWidth: Functions.spanToWidth(spanW)
  implicitHeight: Functions.spanToHeight(spanH)
  color: Colors.surface
  border.color: Colors.border

  property int chosenBook: 0
  property var bookData: []
  signal clicked()
  signal openLibrary()


  Behavior on color {
    ColorAnimation {duration: Metrics.animationLength}
  }

  function openBookPopup(chosen) {
    root.chosenBook = chosen
    root.clicked()
  }

  FileView {
    id: readingListFile
    path: Qt.resolvedUrl("../../books.json")
    watchChanges: true
    onFileChanged: reload()


    onLoaded: {
      let parsedFile = JSON.parse(readingListFile.text())
      bookData = parsedFile.books
    }
  }

  function parsePages(currentPage, totalPages) {
    if (currentPage < 10) {currentPage = "00" + currentPage}
    else if (currentPage < 100) {currentPage = "0" + currentPage}

    if (totalPages < 10) {totalPages = "00" + totalPages}
    else if (totalPages < 100) {totalPages = "0" + totalPages}

    return currentPage + "/" + totalPages
  }

  ColumnLayout{
    anchors.fill: parent
    anchors.margins: Metrics.edgePadding
    spacing: Metrics.spacingInMenu
    Text{
      text: "Reading List"
      color: textMouseArea.containsMouse ? Colors.accent : Colors.text
      font{
        family: Metrics.textFont
        pixelSize: Metrics.textSize
        weight: 500
      }
      MouseArea{
        id: textMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.openLibrary()
      }
    }
    Rectangle{
      color: Colors.border
      height: Metrics.spacerWidth
      Layout.fillWidth: true
    }
    Repeater{
      model: Math.min(bookData.length, 3)
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
            console.log(index)
            flash.start()
            root.clicked()
            root.chosenBook = index
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
    Item{Layout.fillHeight: true}
  }
}
