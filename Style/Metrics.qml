pragma Singleton
import QtQuick


// Hardcoded Values
QtObject {
  readonly property int islandPadding: 6
  readonly property real clockReservedHeight: 32 // Hardcoded value. Change later (I will never change ts)
  readonly property int animationLength: 150
  readonly property real roundingRadius: 11.5 // Half the height of the island when only the clock is active
  readonly property int borderWidth: 150
  readonly property int spacingInMenu: 5
}
