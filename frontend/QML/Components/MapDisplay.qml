import QtQuick
import QML.Themes 1.0

Rectangle {
    color: Theme.background

    Image {
        anchors.fill: parent
        source:       ""
        fillMode:     Image.PreserveAspectCrop
        visible:      source !== ""
    }

    Text {
        anchors.centerIn: parent
        text:             "Canvas"
        color:            Theme.textMuted
        font.family:      Theme.fontLabel
        font.pixelSize:   13
        opacity:          0.4
    }
}
