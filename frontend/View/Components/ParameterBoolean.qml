import QtQuick

import Themes 1.0
import Components 1.0

ParameterBase {
    id: root

    Item {
        anchors.fill: parent

        Rectangle {
            id: track
            width: 50
            height: 20
            radius: 10
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            color: root.value ? Theme.colorAccent : Theme.colorBorder

            Behavior on color {
                ColorAnimation {
                    duration: 150
                }
            }

            Rectangle {
                width: 14
                height: 14
                radius: 7
                y: 3
                x: root.value ? 32 : 3
                color: root.value ? Theme.textAccent : Theme.textSecondary

                Behavior on x {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.InOutQuad
                    }
                }
                Behavior on color {
                    ColorAnimation {
                        duration: 150
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.value = !root.value
            }
        }
    }
}
