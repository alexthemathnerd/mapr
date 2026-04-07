pragma Singleton
import QtQuick

QtObject {
    property bool darkMode: true

    property QtObject dark:  DarkTheme  {}
    property QtObject light: LightTheme {}

    readonly property QtObject current: darkMode ? dark : light

    readonly property color background:    current.background
    readonly property color sidebar:       current.sidebar
    readonly property color hover:         current.hover
    readonly property color border:        current.border

    readonly property color textPrimary:   current.textPrimary
    readonly property color textSecondary: current.textSecondary
    readonly property color textMuted:     current.textMuted

    readonly property string fontLabel: "IBM Plex Sans"
    readonly property string fontMono:  "IBM Plex Mono"
    readonly property int    paddingSm: 8
    readonly property int    paddingMd: 12
    readonly property int    radiusSm:  4
}
