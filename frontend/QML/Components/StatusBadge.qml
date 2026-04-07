import QtQuick
import QML.Themes 1.0

Rectangle {
    property string state: "empty"   // "ready" | "empty" | "locked"

    implicitWidth:  label.implicitWidth + 10
    implicitHeight: 16
    radius:         Theme.radiusSm

    color: {
        switch (state) {
            case "ready":  return "#1A3A34"
            case "locked": return "#2A2A1A"
            default:       return "transparent"
        }
    }

    border.color: {
        switch (state) {
            case "ready":  return "#2DD4BF"
            case "locked": return "#8A6A2A"
            default:       return Theme.border
        }
    }
    border.width: 1

    Text {
        id: label
        anchors.centerIn: parent
        text:             parent.state.charAt(0).toUpperCase() + parent.state.slice(1)
        color: {
            switch (parent.state) {
                case "ready":  return "#2DD4BF"
                case "locked": return "#C97D4A"
                default:       return Theme.textMuted
            }
        }
        font.family:    Theme.fontLabel
        font.pixelSize: 9
        font.weight:    Font.Medium
        font.letterSpacing: 0.5
        font.capitalization: Font.AllUppercase
    }
}
