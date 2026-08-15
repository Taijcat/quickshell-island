pragma Singleton
import QtQuick
import "palettes"

QtObject {
    readonly property QtObject palette: GruvboxDark

    // Surfaces
    readonly property color base:       palette.bg0_h
    readonly property color surface:    palette.bg0
    readonly property color surfaceAlt: palette.bg1
    readonly property color overlay:    palette.bg2
    readonly property color border:     palette.bg3
    readonly property color muted:      palette.bg4

    // Text
    readonly property color text:      palette.fg1
    readonly property color textDim:   palette.fg3
    readonly property color textFaint: palette.fg4

    // Accent colors (raw palette hues, for anyone who wants a specific one)
    readonly property color red:    palette.redBright
    readonly property color green:  palette.greenBright
    readonly property color yellow: palette.yellowBright
    readonly property color blue:   palette.blueBright
    readonly property color purple: palette.purpleBright
    readonly property color aqua:   palette.aquaBright
    readonly property color orange: palette.orangeBright
    readonly property color gray:   palette.gray

    // Semantic accent — the "brand" color of this theme's UI.
    readonly property color accent:     palette.orangeBright
    readonly property color accentDim:  palette.orange
    readonly property color accentText: palette.bg0_h

    // Semantic status colors — map to whatever hue each theme uses for that meaning
    readonly property color error:     palette.redBright
    readonly property color success: palette.greenBright
    readonly property color warn:    palette.yellowBright
    readonly property color info:    palette.blueBright
    readonly property color hint:    palette.yellowBright
}
