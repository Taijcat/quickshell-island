pragma Singleton
import QtQuick

QtObject {
  // Surfaces
  readonly property color base:       "#11111b"
  readonly property color surface:    "#1e1e2e"
  readonly property color surfaceAlt: "#313244"
  readonly property color overlay:    "#45475a"
  readonly property color border:     "#585b70"
  readonly property color muted:      "#6c7086"

  // Text
  readonly property color text:      "#cdd6f4"
  readonly property color textDim:   "#bac2de"
  readonly property color textFaint: "#a6adc8"

  // Accent colors
  readonly property color red:    "#f38ba8"
  readonly property color green:  "#a6e3a1"
  readonly property color yellow: "#f9e2af"
  readonly property color blue:   "#89b4fa"
  readonly property color purple: "#cba6f7"
  readonly property color aqua:   "#94e2d5"
  readonly property color orange: "#fab387"
  readonly property color gray:   "#7f849c"

  // Semantic accent
  readonly property color accent:     "#89b4fa"
  readonly property color accentDim:  "#eba0ac"
  readonly property color accentText: "#11111b"

  // Semantic status colors
  readonly property color error:     "#f38ba8"
  readonly property color success: "#a6e3a1"
  readonly property color warn:    "#f9e2af"
  readonly property color info:    "#89b4fa"
  readonly property color hint:    "#f9e2af"
}
