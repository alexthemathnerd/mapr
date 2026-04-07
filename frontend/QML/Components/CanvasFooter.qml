import QtQuick
import QtQuick.Layouts
import QML.Themes 1.0

Rectangle {
    property string recentAction: "Ready"
    property string layerName:    "Height"
    property string season:       "Summer"
    property int    zoomPercent:  100

    color: Theme.sidebar

    // Top border
    Rectangle {
        anchors { left: parent.left; right: parent.right; top: parent.top }
        height: 1
        color:  Theme.border
    }

    RowLayout {
        anchors {
            fill:        parent
            leftMargin:  Theme.paddingMd
            rightMargin: Theme.paddingMd
        }

        Text {
            text:           recentAction
            color:          Theme.textMuted
            font.family:    Theme.fontLabel
            font.pixelSize: 11
        }

        Item { Layout.fillWidth: true }

        Text {
            text:           layerName + "  ·  " + season + "  ·  " + zoomPercent + "%"
            color:          Theme.textMuted
            font.family:    Theme.fontMono
            font.pixelSize: 11
        }
    }
}
