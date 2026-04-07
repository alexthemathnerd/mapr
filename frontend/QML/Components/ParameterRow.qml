import QtQuick
import QtQuick.Layouts
import QML.Themes 1.0

Item {
    property string label:     ""
    property string paramType: ""

    implicitHeight: 28
    implicitWidth:  200

    RowLayout {
        anchors {
            fill:        parent
            leftMargin:  Theme.paddingMd
            rightMargin: Theme.paddingMd
        }
        spacing: 8

        Text {
            Layout.fillWidth: true
            text:             label
            color:            Theme.textSecondary
            font.family:      Theme.fontLabel
            font.pixelSize:   12
            elide:            Text.ElideRight
        }

        Text {
            text:           "—"
            color:          Theme.textMuted
            font.family:    Theme.fontMono
            font.pixelSize: 12
        }
    }
}
