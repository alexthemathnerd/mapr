import QtQuick
import QtQuick.Layouts

import Themes 1.0

Item {
    id: root

    property string label: ""
    property var value: undefined
    property var defaultValue: undefined
    default property alias control: controlSlot.children

    implicitHeight: 36

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.paddingLG
        anchors.rightMargin: Theme.paddingLG
        spacing: Theme.paddingMD

        Text {
            Layout.fillWidth: true
            text: root.label
            color: Theme.textSecondary
            font.family: Theme.fontSans
            font.pixelSize: Theme.fontSizeMD
            verticalAlignment: Text.AlignVCenter
        }

        Item {
            id: controlSlot
            Layout.preferredWidth: 100
            Layout.fillHeight: true
        }
    }
}
