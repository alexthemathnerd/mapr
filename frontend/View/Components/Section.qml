import QtQuick
import QtQuick.Layouts

import Themes 1.0
import Components 1.0

Item {
    property bool hasBottomBorder: true
    property string sectionTitle: ""
    default property alias content: container.children

    id: root

    implicitHeight: outerLayout.implicitHeight + outerLayout.spacing * 2

    BorderRectangle {
        anchors.fill: parent
        color: "transparent"
        borders.color: Theme.colorBorder
        borders.bottom.width: root.hasBottomBorder ? Theme.borderSM : 0

        ColumnLayout {
            id: outerLayout
            // Anchor left/right/top only — no bottom anchor.
            // This lets the layout grow to fit its children instead of
            // being forced to fill the parent height.
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: Theme.paddingLG
            spacing: Theme.paddingLG

            Text {
                Layout.fillWidth: true
                text: root.sectionTitle
                font.family: Theme.fontSans
                font.pixelSize: Theme.fontSizeSM
                font.weight: Font.Medium
                font.capitalization: Font.AllUppercase
                color: Theme.textPrimary
            }

            ColumnLayout {
                id: container
                Layout.fillWidth: true
                spacing: 0
            }
        }
    }
}
