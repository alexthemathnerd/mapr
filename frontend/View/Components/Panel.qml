import QtQuick
import QtQuick.Layouts

import Themes 1.0
import Components 1.0

Item {
    id: root
    property bool hasLeftCorner: false
    property bool hasRightCorner: false
    default property alias content: container.children

    BorderRectangle {
        anchors.fill: parent
        color: Theme.colorSecondary
        bottomLeftRadius: root.hasLeftCorner && Window.window.visibility !== Window.Maximized ? Theme.radiusLG : 0
        bottomRightRadius: root.hasRightCorner && Window.window.visibility !== Window.Maximized ? Theme.radiusLG : 0
        borders.color: Theme.colorBorder
        borders.left.width: !root.hasLeftCorner ? Theme.borderSM : 0
        borders.right.width: !root.hasRightCorner ? Theme.borderSM : 0

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            ColumnLayout {
                id: container
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0
            }
        }
    }
}
