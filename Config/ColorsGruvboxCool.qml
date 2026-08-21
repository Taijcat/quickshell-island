pragma Singleton
import QtQuick

QtObject {
  // Surfaces
  readonly property color base:       "#1d2021"
  readonly property color surface:    "#282828"
  readonly property color surfaceAlt: "#3c3836"
  readonly property color overlay:    "#504945"
  readonly property color border:     "#665c54"
  readonly property color muted:      "#7c6f64"

  // Text
  readonly property color text:      "#ebdbb2"
  readonly property color textDim:   "#bdae93"
  readonly property color textFaint: "#a89984"

  // Accent colors
  readonly property color red:    "#fb4934"
  readonly property color green:  "#b8bb26"
  readonly property color yellow: "#fabd2f"
  readonly property color blue:   "#83a598"
  readonly property color purple: "#d3869b"
  readonly property color aqua:   "#8ec07c"
  readonly property color orange: "#fe8019"
  readonly property color gray:   "#928374"

  // Semantic accent
  readonly property color accent:     "#8ec07c"
  readonly property color accentDim:  "#689d6a"
  readonly property color accentText: "#1d2021"

  // Semantic status colors
  readonly property color error:     "#fb4934"
  readonly property color success: "#b8bb26"
  readonly property color warn:    "#fabd2f"
  readonly property color info:    "#83a598"
  readonly property color hint:    "#fabd2f"
}
