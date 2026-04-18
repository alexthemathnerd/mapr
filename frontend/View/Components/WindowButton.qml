import QtQuick

import Themes 1.0

Item {
    id: root
    property string icon: "\uF142"
    property bool isLeftCorner: false
    property bool isRightCorner: false
    signal clicked
    implicitWidth: 46
    implicitHeight: 32

    Rectangle {
        anchors.fill: parent
        color: burgerArea.containsMouse ? Theme.colorTertiary : "transparent"

        // Corner radii follow the WindowBar — when maximized the bar has no
        // radius so neither should the button hover highlight.
        topLeftRadius: root.isLeftCorner && Window.window.visibility !== Window.Maximized ? Theme.radiusLG : 0
        topRightRadius: root.isRightCorner && Window.window.visibility !== Window.Maximized ? Theme.radiusLG : 0

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
            font.pixelSize: 13
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            lineHeight: 0
            font.weight: burgerArea.containsMouse ? Font.Bold : Font.Normal
        }
    }
}
