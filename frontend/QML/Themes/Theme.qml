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
    readonly property color textTertiary:     current.textTertiary

    readonly property string fontSans: "IBM Plex Sans"
    readonly property string fontMono:  "IBM Plex Mono"
    
    readonly property int    paddingLG: 10
    readonly property int    paddingMD: 5
    readonly property int    paddingSM: 2

    readonly property int    radiusLG: 7
    readonly property int    radiusMD: 3.5
    readonly property int    radiusSM: 1.5
}
