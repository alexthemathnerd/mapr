import QtQuick
import QML.Themes 1.0

Item {
    property string text: ""

    implicitHeight: label.implicitHeight + Theme.paddingSm * 2
    implicitWidth:  label.implicitWidth

    Text {
        id: label
        anchors {
            left:            parent.left
            right:           parent.right
            verticalCenter:  parent.verticalCenter
            leftMargin:      Theme.paddingMd
        }
        text:                 parent.text
        color:                Theme.textMuted
        font.family:          Theme.fontLabel
        font.pixelSize:       10
        font.letterSpacing:   1.5
        font.capitalization:  Font.AllUppercase
        font.weight:          Font.Medium
    }
}
