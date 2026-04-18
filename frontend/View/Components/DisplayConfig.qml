import QtQuick
import QtQuick.Layouts

import Components 1.0

Item {
    id: root

    implicitHeight: layout.implicitHeight

    ColumnLayout {
        id: layout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        spacing: 0

        ParameterCmap {
            Layout.fillWidth: true
            label: "Color Map"
            value: 0
            defaultValue: 0
        }

        ParameterBoolean {
            Layout.fillWidth: true
            label: "Grid"
            value: false
            defaultValue: false
        }

        ParameterBoolean {
            Layout.fillWidth: true
            label: "Contours"
            value: false
            defaultValue: false
        }

        ParameterBoolean {
            Layout.fillWidth: true
            label: "Graticules"
            value: false
            defaultValue: false
        }
    }
}
