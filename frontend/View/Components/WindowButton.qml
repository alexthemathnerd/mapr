import QtQuick

import Themes 1.0

Rectangle {
    property string icon: "\uF142"
    property bool isLeftCorner: false
    property bool isRightCorner: false
    signal clicked()

    id: root
    width: 48
    height: 48
    color: burgerArea.containsMouse ? Theme.colorTertiary : "transparent"
    topLeftRadius: root.isLeftCorner ? Theme.radiusLG : 0
    topRightRadius: root.isRightCorner ? Theme.radiusLG : 0


    MouseArea {
        id: burgerArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
    }

    Text {
        anchors.centerIn: parent
        text: root.icon
        color: Theme.textPrimary
        font.family: "Segoe Fluent Icons"
        font.pixelSize: 15
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        lineHeight: 0
        font.weight:  burgerArea.containsMouse ? Font.Bold : Font.Normal
    }
}
