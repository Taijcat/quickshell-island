pragma Singleton
import QtQuick


// Hardcoded Values
QtObject {
  // Decorations
  readonly property real clockReservedHeight: 32 // Hardcoded value. Change later (I will never change ts)
  readonly property int islandPadding: 6
  readonly property int animationLength: 150
  readonly property real roundingRadius: 12 // Half the height of the island when only the clock is active
  readonly property int borderWidth: 150
  readonly property int spacingInMenu: 5

  // Fonts
  readonly property string textFont: "Google Sans Flex"
  readonly property string iconFont: "JetBrainsMono Nerd Font Propo"
  readonly property int iconSize: 25
  readonly property int textSize: 15

  // Config
  readonly property string terminal: "kitty"
  
}
