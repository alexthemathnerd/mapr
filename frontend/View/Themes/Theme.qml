pragma Singleton
import QtQuick

QtObject {

    readonly property BaseTheme theme: LightTheme {}

    readonly property color colorPrimary: theme.colorPrimary
    readonly property color colorSecondary: theme.colorSecondary
    readonly property color colorTertiary: theme.colorTertiary
    readonly property color colorBorder: theme.colorBorder
    readonly property color textPrimary: theme.textPrimary
    readonly property color textSecondary: theme.textSecondary
    readonly property color textTertiary: theme.textTertiary

    readonly property string fontSans: "IBM Plex Sans"
    readonly property string fontMono:  "IBM Plex Mono"
    
    readonly property int fontSizeLG: 18
    readonly property int fontSizeMD: 12
    readonly property int fontSizeSM: 10

    readonly property int    paddingLG: 10
    readonly property int    paddingMD: 5
    readonly property int    paddingSM: 2

    readonly property int    radiusLG: 7
    readonly property int    radiusMD: 4
    readonly property int    radiusSM: 2

    readonly property int    borderLG: 3
    readonly property int    borderMD: 2
    readonly property int    borderSM: 1
}
