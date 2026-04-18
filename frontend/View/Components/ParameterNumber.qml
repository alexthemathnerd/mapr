import QtQuick

import Themes 1.0
import Components 1.0

ParameterBase {
    id: root

    property real step: 1
    property real min: -Infinity
    property real max: Infinity

    Rectangle {
        anchors.fill: parent
        anchors.topMargin: (parent.height - 22) / 2
        anchors.bottomMargin: (parent.height - 22) / 2
        radius: Theme.radiusMD
        color: Theme.colorTertiary
        border.color: Theme.colorBorder
        border.width: Theme.borderSM

        TextInput {
            id: valueInput
            anchors.fill: parent
            anchors.leftMargin: Theme.paddingSM
            anchors.rightMargin: Theme.paddingSM
            horizontalAlignment: TextInput.AlignRight
            verticalAlignment: TextInput.AlignVCenter
            color: Theme.textSecondary
            font.family: Theme.fontMono
            font.pixelSize: Theme.fontSizeMD
            selectByMouse: true
            clip: true

            Component.onCompleted: text = root.value !== undefined ? String(root.value) : "0"

            onEditingFinished: {
                let n = parseFloat(text);
                if (!isNaN(n))
                    root.value = Math.max(root.min, Math.min(root.max, n));
                text = root.value !== undefined ? String(root.value) : "0";
            }

            Connections {
                target: root
                function onValueChanged() {
                    if (!valueInput.activeFocus)
                        valueInput.text = root.value !== undefined ? String(root.value) : "0";
                }
            }
        }
    }
}
