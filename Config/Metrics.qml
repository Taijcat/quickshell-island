pragma Singleton
import QtQuick


// Hardcoded Values
QtObject {
  // Decorations
  readonly property int islandVertPadding: 6
  readonly property int animationLength: 150
  readonly property int borderWidth: 150
  readonly property int spacingInMenu: 5
  readonly property int buttonHeight: 56
  readonly property int buttonWidth: 56
  readonly property int buttonPadding: 3
  readonly property int edgePadding: 8

  property int islandHeight: 0
  property real roundingRadius: islandHeight / 2 // Half the height of the island when only the clock is active
  property real clockReservedHeight: islandHeight + edgePadding

  // Fonts
  readonly property string textFont: "Google Sans Flex"
  readonly property string iconFont: "JetBrainsMono Nerd Font Propo"
  readonly property int iconSize: 25
  readonly property int textSize: 15
  readonly property real iconSizeMult: 1.25

  // Config
  readonly property string terminal: "kitty"
  
}
