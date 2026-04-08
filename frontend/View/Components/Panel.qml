import QtQuick
import QtQuick.Layouts

import Themes 1.0
import Components 1.0

Item {
    property bool hasLeftCorner: false
    property bool hasRightCorner: false
    default property alias content: container.children
    id: root
    width: 250

    BorderRectangle {
        anchors.fill: parent
        color: Theme.colorSecondary
        bottomLeftRadius: root.hasLeftCorner ? Theme.radiusLG: 0
        bottomRightRadius: root.hasRightCorner ? Theme.radiusLG : 0
        borders.color: Theme.colorBorder
        borders.left.width: !root.hasLeftCorner ? Theme.borderSM : 0
        borders.right.width: !root.hasRightCorner ? Theme.borderSM : 0

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // Children (Sections, etc.) stack here from the top
            ColumnLayout {
                id: container
                Layout.fillWidth: true
                spacing: 0
            }

            Item { Layout.fillHeight: true }
        }

    }
}



