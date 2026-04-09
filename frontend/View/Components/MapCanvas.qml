import QtQuick
import QtQuick.Layouts

import Themes 1.0
import Components 1.0

Item {
    property alias layerName: canvasBar.layerName

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
            Layout.fillWidth: true
            Layout.preferredHeight: 24
        }
    }
}
