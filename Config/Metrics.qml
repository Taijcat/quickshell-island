pragma Singleton
import QtQuick


// Hardcoded Values
QtObject {
  // Decorations
  readonly property int islandVertPadding: 6
  readonly property int islandHorizPadding: 14
  readonly property int borderWidth: 150
  readonly property int spacingInMenu: 5
  readonly property int buttonHeight: 56
  readonly property int buttonWidth: 56
  readonly property int buttonPadding: 3
  readonly property int edgePadding: 8
  readonly property int osdWidth: 150
  readonly property int popUpMenuWidth: 260

  property int islandHeight: 0
  property real roundingRadius: islandHeight / 2 // Half the height of the island when only the clock is active
  property real clockReservedHeight: islandHeight + edgePadding

  // Fonts
  readonly property string textFont: "Google Sans Flex"
  readonly property string iconFont: "JetBrainsMono Nerd Font Propo"
  readonly property int iconSize: 25
  readonly property int textSize: 15
  readonly property real iconSizeMult: 1.25
  readonly property real textSizeMult: 1.25
  readonly property int fontBold: 600


  // Config
  readonly property string terminal: "kitty"
  readonly property int avBarSpacingHome: 3
  readonly property int avBarHeightHome: 5
  readonly property int avBarWidthHome: 100
  readonly property int waveAmp: 3
  readonly property int waveLength: 25
  readonly property int waveSpeed: 1200

  // Animations
  readonly property int animationLength: 300
  readonly property real easingHeadroom: 1.15


}
