import QtQuick
import QtQuick.Layouts

import Components 1.0

Item {
    id: root

    property alias seed: seedParam.value
    property alias iterations: iterationsParam.value

    implicitHeight: layout.implicitHeight

    ColumnLayout {
        id: layout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        spacing: 0

        ParameterRandom {
            id: seedParam
            Layout.fillWidth: true
            label: "Seed"
            value: 0
            defaultValue: 0
            min: 0
            max: 999999
        }

        ParameterNumber {
            id: iterationsParam
            Layout.fillWidth: true
            label: "Iterations"
            value: 10
            defaultValue: 10
            min: 1
            max: 1000
            step: 1
        }
    }
}
