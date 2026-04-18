pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import Themes 1.0
import Components 1.0

ParameterBase {
    id: root

    property var options: []

    Item {
        anchors.fill: parent

        Rectangle {
            id: dropdownButton
            anchors.fill: parent
            anchors.topMargin: (parent.height - 22) / 2
            anchors.bottomMargin: (parent.height - 22) / 2
            radius: Theme.radiusMD
            color: Theme.colorTertiary
            border.color: Theme.colorBorder
            border.width: Theme.borderSM

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Theme.paddingMD
                anchors.rightMargin: Theme.paddingMD
                spacing: 0

                Text {
                    Layout.fillWidth: true
                    text: (root.options && root.value !== undefined && root.value >= 0 && root.value < root.options.length) ? root.options[root.value] : ""
                    color: Theme.textSecondary
                    font.family: Theme.fontSans
                    font.pixelSize: Theme.fontSizeSM
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    text: "∨"
                    color: Theme.textTertiary
                    font.family: Theme.fontSans
                    font.pixelSize: Theme.fontSizeSM
                    verticalAlignment: Text.AlignVCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: optionsPopup.open()
            }

            Popup {
                id: optionsPopup
                parent: dropdownButton
                y: dropdownButton.height + Theme.paddingSM
                x: 0
                width: dropdownButton.width
                padding: 0
                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

                background: Rectangle {
                    color: Theme.colorSecondary
                    border.color: Theme.colorBorder
                    border.width: Theme.borderSM
                    radius: Theme.radiusMD
                }

                contentItem: Column {
                    spacing: 0
                    topPadding: Theme.paddingSM
                    bottomPadding: Theme.paddingSM

                    Repeater {
                        model: root.options

                        delegate: Item {
                            id: optionDelegate
                            required property string modelData
                            required property int index

                            width: optionsPopup.width
                            height: 28

                            Rectangle {
                                anchors.fill: parent
                                anchors.leftMargin: Theme.paddingSM
                                anchors.rightMargin: Theme.paddingSM
                                color: rowArea.containsMouse ? Theme.colorTertiary : "transparent"
                                radius: Theme.radiusSM
                            }

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: Theme.paddingMD
                                anchors.rightMargin: Theme.paddingMD
                                spacing: Theme.paddingSM

                                Text {
                                    Layout.fillWidth: true
                                    text: optionDelegate.modelData
                                    color: Theme.textSecondary
                                    font.family: Theme.fontSans
                                    font.pixelSize: Theme.fontSizeSM
                                    verticalAlignment: Text.AlignVCenter
                                }

                                Text {
                                    text: "✓"
                                    visible: optionDelegate.index === root.value
                                    color: Theme.textAccent
                                    font.family: Theme.fontSans
                                    font.pixelSize: Theme.fontSizeSM
                                }
                            }

                            MouseArea {
                                id: rowArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    root.value = optionDelegate.index;
                                    optionsPopup.close();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
