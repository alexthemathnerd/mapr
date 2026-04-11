import QtQuick
import QtQuick.Layouts

import Themes 1.0

Item {
    id: root

    property string actionName: ""
    property var timestamp: Date.now()

    implicitHeight: 36
    implicitWidth: 200

    RowLayout {
        anchors.fill: parent
        anchors.margins: Theme.paddingLG
        spacing: Theme.paddingLG

        Text {
            Layout.fillWidth: true
            text: root.actionName
            color: Theme.textSecondary
            font.family: Theme.fontSans
            font.pixelSize: Theme.fontSizeMD
            elide: Text.ElideRight
        }

        Text {
            text: new Date(root.timestamp).toLocaleTimeString(Qt.locale(), "hh:mm")
            color: Theme.textTertiary
            font.family: Theme.fontSans
            font.pixelSize: Theme.fontSizeSM
        }
    }
}
