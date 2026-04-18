import QtQuick
import QtQuick.Layouts

import Themes 1.0
import Components 1.0

Item {
    id: root
    property alias layerName: canvasBar.layerName
    property string lastAction: ""

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        CanvasBar {
            id: canvasBar
            Layout.fillWidth: true
            Layout.preferredHeight: 32
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Theme.colorPrimary
        }

        CanvasFooter {
            lastAction: root.lastAction
            Layout.fillWidth: true
            Layout.preferredHeight: 24
        }
    }
}
