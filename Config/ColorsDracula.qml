pragma Singleton
import QtQuick

QtObject {
  // Surfaces
  readonly property color base:       "#191a21"
  readonly property color surface:    "#282a36"
  readonly property color surfaceAlt: "#343746"
  readonly property color overlay:    "#44475a"
  readonly property color border:     "#6272a4"
  readonly property color muted:      "#6272a4"

  // Text
  readonly property color text:      "#f8f8f2"
  readonly property color textDim:   "#bfbfbf"
  readonly property color textFaint: "#6272a4"

  // Accent colors
  readonly property color red:    "#ff5555"
  readonly property color green:  "#50fa7b"
  readonly property color yellow: "#f1fa8c"
  readonly property color blue:   "#8be9fd"
  readonly property color purple: "#bd93f9"
  readonly property color aqua:   "#8be9fd"
  readonly property color orange: "#ffb86c"
  readonly property color gray:   "#6272a4"

  // Semantic accent
  readonly property color accent:     "#bd93f9"
  readonly property color accentDim:  "#9776c7"
  readonly property color accentText: "#282a36"

  // Semantic status colors
  readonly property color error:     "#ff5555"
  readonly property color success: "#50fa7b"
  readonly property color warn:    "#f1fa8c"
  readonly property color info:    "#8be9fd"
  readonly property color hint:    "#f1fa8c"
}
