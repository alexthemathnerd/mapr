import QtQuick
import QtQuick.Layouts
import QML.Themes 1.0

Rectangle {
    property color  dotColor:  "#888888"
    property string mapName:   "Layer"
    property string badgeState: "empty"

    implicitHeight: 36
    color:          "transparent"

    RowLayout {
        anchors {
            fill:        parent
            leftMargin:  Theme.paddingMd
            rightMargin: Theme.paddingMd
        }
        spacing: 8

        Rectangle {
            width:  10
            height: 10
            radius: 5
            color:  dotColor
        }

        Text {
            Layout.fillWidth: true
            text:             mapName
            color:            Theme.textPrimary
            font.family:      Theme.fontLabel
            font.pixelSize:   13
            elide:            Text.ElideRight
        }

        StatusBadge {
            state: badgeState
        }
    }
}
