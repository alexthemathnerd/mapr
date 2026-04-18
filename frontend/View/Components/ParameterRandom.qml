import QtQuick
import QtQuick.Layouts

import Themes 1.0

Item {
    id: root

    property string label: ""
    property var value: undefined
    property var defaultValue: undefined
    property real min: 0
    property real max: 100

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

        Rectangle {
            Layout.preferredWidth: 67
            Layout.preferredHeight: 22
            radius: Theme.radiusMD
            color: Theme.colorTertiary
            border.color: Theme.colorBorder
            border.width: Theme.borderSM

            TextInput {
                id: valueInput
                anchors.fill: parent
                anchors.leftMargin: Theme.paddingSM
                anchors.rightMargin: Theme.paddingSM
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                color: Theme.textSecondary
                font.family: Theme.fontMono
                font.pixelSize: Theme.fontSizeMD
                selectByMouse: true
                clip: true

                Component.onCompleted: text = root.value !== undefined ? String(root.value) : String(root.min)

                onEditingFinished: {
                    let n = parseFloat(text);
                    if (!isNaN(n))
                        root.value = Math.max(root.min, Math.min(root.max, n));
                    text = root.value !== undefined ? String(root.value) : String(root.min);
                }

                Connections {
                    target: root
                    function onValueChanged() {
                        if (!valueInput.activeFocus)
                            valueInput.text = root.value !== undefined ? String(root.value) : String(root.min);
                    }
                }
            }
        }

        Rectangle {
            Layout.preferredWidth: 28
            Layout.preferredHeight: 22
            radius: Theme.radiusMD
            color: randomArea.containsMouse ? Theme.colorTertiary : "transparent"
            border.color: Theme.colorBorder
            border.width: Theme.borderSM

            Text {
                anchors.centerIn: parent
                text: "⚄"
                color: Theme.textSecondary
                font.family: Theme.fontSans
                font.pixelSize: Theme.fontSizeLG
            }

            MouseArea {
                id: randomArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.value = Math.round(root.min + Math.random() * (root.max - root.min))
            }
        }
    }
}
