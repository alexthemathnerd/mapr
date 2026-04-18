import QtQuick
import QtQuick.Layouts

import Themes 1.0
import Components 1.0

Item {
    id: root
    property bool hasBottomBorder: true
    property bool expand: false
    property string sectionTitle: ""
    default property alias content: container.children

    Layout.fillHeight: root.expand
    implicitHeight: root.expand ? 0 : outerLayout.implicitHeight + outerLayout.spacing * 2

    BorderRectangle {
        anchors.fill: parent
        color: "transparent"
        borders.color: Theme.colorBorder
        borders.bottom.width: root.hasBottomBorder ? Theme.borderSM : 0

        ColumnLayout {
            id: outerLayout
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: root.expand ? parent.bottom : undefined
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
                Layout.fillHeight: root.expand
                spacing: 0
            }
        }
    }
}
