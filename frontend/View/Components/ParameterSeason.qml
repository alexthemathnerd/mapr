import QtQuick
import QtQuick.Layouts

import Themes 1.0
import Components 1.0

ParameterBase {
    id: root

    Rectangle {
        anchors.fill: parent
        anchors.topMargin: (parent.height - 22) / 2
        anchors.bottomMargin: (parent.height - 22) / 2
        radius: Theme.radiusMD
        color: "transparent"
        border.color: Theme.colorBorder
        border.width: Theme.borderSM
        clip: true

        RowLayout {
            anchors.fill: parent
            spacing: 0

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: root.value === true ? Theme.colorAccent : "transparent"

                Text {
                    anchors.centerIn: parent
                    text: "☀"
                    color: root.value === true ? Theme.textAccent : Theme.textTertiary
                    font.family: Theme.fontSans
                    font.pixelSize: Theme.fontSizeLG
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.value = true
                }
            }

            Rectangle {
                Layout.preferredWidth: Theme.borderSM
                Layout.fillHeight: true
                color: Theme.colorBorder
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: root.value !== true ? Theme.colorAccent : "transparent"

                Text {
                    anchors.centerIn: parent
                    text: "❄"
                    color: root.value !== true ? Theme.textAccent : Theme.textTertiary
                    font.family: Theme.fontSans
                    font.pixelSize: Theme.fontSizeLG
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.value = false
                }
            }
        }
    }
}
