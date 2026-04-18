import QtQuick
import QtQuick.Layouts

import Themes 1.0
import Components 1.0

Item {
    id: root

    property string lastAction: ""
    property int zoomPercent: 100

    BorderRectangle {
        anchors.fill: parent
        color: Theme.colorSecondary
        borders.color: Theme.colorBorder
        borders.top.width: Theme.borderSM

        RowLayout {
            id: outerLayout
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: Theme.paddingLG
            anchors.rightMargin: Theme.paddingLG
            spacing: Theme.paddingMD

            Text {
                Layout.fillWidth: true
                text: root.lastAction.length > 0 ? "Last: " + root.lastAction : ""
                color: Theme.textTertiary
                font.family: Theme.fontSans
                font.pixelSize: Theme.fontSizeSM
                elide: Text.ElideRight
            }

            Text {
                text: "Zoom: " + root.zoomPercent + "%"
                color: Theme.textTertiary
                font.family: Theme.fontSans
                font.pixelSize: Theme.fontSizeSM
            }
        }
    }
}
