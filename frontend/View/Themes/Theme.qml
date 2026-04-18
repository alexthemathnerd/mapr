pragma Singleton
import QtQuick

QtObject {

    property bool isDark: true
    function toggleTheme() {
        isDark = !isDark;
    }

    readonly property BaseTheme _dark: DarkTheme {}
    readonly property BaseTheme _light: LightTheme {}
    readonly property BaseTheme theme: isDark ? _dark : _light

    readonly property color colorPrimary: theme.colorPrimary
    readonly property color colorSecondary: theme.colorSecondary
    readonly property color colorTertiary: theme.colorTertiary
    readonly property color colorBorder: theme.colorBorder
    readonly property color textPrimary: theme.textPrimary
    readonly property color textSecondary: theme.textSecondary
    readonly property color textTertiary: theme.textTertiary

    readonly property color textAccent: theme.textAccent
    readonly property color colorAccent: theme.colorAccent
    readonly property color colorLogo: theme.colorLogo

    readonly property color teal900: theme.teal900
    readonly property color teal800: theme.teal800
    readonly property color teal600: theme.teal600
    readonly property color teal400: theme.teal400
    readonly property color teal200: theme.teal200
    readonly property color teal50: theme.teal50

    readonly property string fontSans: "IBM Plex Sans"
    readonly property string fontMono: "IBM Plex Mono"

    readonly property int fontSizeLG: 14
    readonly property int fontSizeMD: 12
    readonly property int fontSizeSM: 10

    readonly property int paddingLG: 10
    readonly property int paddingMD: 5
    readonly property int paddingSM: 2

    readonly property int radiusLG: 7
    readonly property int radiusMD: 4
    readonly property int radiusSM: 2

    readonly property int borderLG: 3
    readonly property int borderMD: 2
    readonly property int borderSM: 1
}
