pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import Themes 1.0
import Components 1.0

Item {
    id: root

    property string label: ""
    property alias value: base.value
    property alias defaultValue: base.defaultValue

    implicitHeight: 36 + Theme.paddingMD + 8

    readonly property var cmaps: [
        {
            name: "Viridis",
            stops: ["#440154", "#31688e", "#35b779", "#fde725"]
        },
        {
            name: "Plasma",
            stops: ["#0d0887", "#7e03a8", "#cc4778", "#f89540", "#f0f921"]
        },
        {
            name: "Inferno",
            stops: ["#000004", "#420a68", "#932667", "#dd513a", "#fca50a", "#f0f921"]
        },
        {
            name: "Greens",
            stops: ["#f7fcf5", "#74c476", "#00441b"]
        },
        {
            name: "Blues",
            stops: ["#f7fbff", "#6baed6", "#08306b"]
        }
    ]

    onValueChanged: gradientCanvas.requestPaint()

    // Top row: label + dropdown
    ParameterBase {
        id: base
        x: 0
        y: 0
        width: parent.width
        height: 36
        label: root.label

        Item {
            anchors.fill: parent

            Rectangle {
                id: cmapDropdownButton
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
                        text: {
                            let idx = root.value ?? 0;
                            return (idx >= 0 && idx < root.cmaps.length) ? root.cmaps[idx].name : "";
                        }
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
                    onClicked: cmapPopup.open()
                }

                Popup {
                    id: cmapPopup
                    parent: cmapDropdownButton
                    y: cmapDropdownButton.height + Theme.paddingSM
                    x: 0
                    width: cmapDropdownButton.width
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
                            model: root.cmaps

                            delegate: Item {
                                id: cmapDelegate
                                required property var modelData
                                required property int index

                                width: cmapPopup.width
                                height: 28

                                Rectangle {
                                    anchors.fill: parent
                                    anchors.leftMargin: Theme.paddingSM
                                    anchors.rightMargin: Theme.paddingSM
                                    color: cmapRowArea.containsMouse ? Theme.colorTertiary : "transparent"
                                    radius: Theme.radiusSM
                                }

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: Theme.paddingMD
                                    anchors.rightMargin: Theme.paddingMD
                                    spacing: Theme.paddingSM

                                    Text {
                                        Layout.fillWidth: true
                                        text: cmapDelegate.modelData.name
                                        color: Theme.textSecondary
                                        font.family: Theme.fontSans
                                        font.pixelSize: Theme.fontSizeSM
                                        verticalAlignment: Text.AlignVCenter
                                    }

                                    Text {
                                        text: "✓"
                                        visible: cmapDelegate.index === (root.value ?? 0)
                                        color: Theme.textAccent
                                        font.family: Theme.fontSans
                                        font.pixelSize: Theme.fontSizeSM
                                    }
                                }

                                MouseArea {
                                    id: cmapRowArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: {
                                        root.value = cmapDelegate.index;
                                        cmapPopup.close();
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Gradient strip below the row
    Item {
        x: Theme.paddingLG
        y: 36 + Theme.paddingMD
        width: parent.width - 2 * Theme.paddingLG
        height: 8

        Canvas {
            id: gradientCanvas
            anchors.fill: parent

            Component.onCompleted: requestPaint()

            onPaint: {
                const ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);
                const idx = root.value ?? 0;
                if (idx < 0 || idx >= root.cmaps.length)
                    return;
                const stops = root.cmaps[idx].stops;
                const grad = ctx.createLinearGradient(0, 0, width, 0);
                for (let i = 0; i < stops.length; i++)
                    grad.addColorStop(i / (stops.length - 1), stops[i]);

                // Draw rounded rectangle path so corners are truly rounded
                const r = 2;
                ctx.beginPath();
                ctx.moveTo(r, 0);
                ctx.lineTo(width - r, 0);
                ctx.arcTo(width, 0, width, r, r);
                ctx.lineTo(width, height - r);
                ctx.arcTo(width, height, width - r, height, r);
                ctx.lineTo(r, height);
                ctx.arcTo(0, height, 0, height - r, r);
                ctx.lineTo(0, r);
                ctx.arcTo(0, 0, r, 0, r);
                ctx.closePath();

                ctx.fillStyle = grad;
                ctx.fill();
            }
        }
    }
}
