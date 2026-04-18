pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

import Themes 1.0

Item {
    id: root

    property int value: 0

    readonly property var algorithms: [
        {
            name: "Perlin Noise",
            description: "Generates smooth, natural-looking terrain using gradient noise. Well-suited for continental landmasses and organic coastlines.",
            requirements: ["Seed", "Scale", "Season"]
        },
        {
            name: "Simplex",
            description: "An improved noise algorithm with fewer directional artifacts and better performance for high-dimensional terrain outputs.",
            requirements: ["Seed", "Scale", "Islands"]
        },
        {
            name: "Voronoi",
            description: "Produces cell-based patterns ideal for simulating tectonic plates and generating region-based geographic features.",
            requirements: ["Seed", "Biome"]
        }
    ]

    implicitHeight: layout.implicitHeight

    ColumnLayout {
        id: layout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        spacing: Theme.paddingMD

        // ── Algorithm dropdown ──────────────────────────────────────────
        Rectangle {
            id: algoDropdown
            Layout.fillWidth: true
            Layout.leftMargin: Theme.paddingLG
            Layout.rightMargin: Theme.paddingLG
            Layout.topMargin: Theme.paddingSM
            Layout.preferredHeight: 22
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
                    text: root.algorithms[root.value].name
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
                onClicked: algoPopup.open()
            }

            Popup {
                id: algoPopup
                parent: algoDropdown
                x: 0
                y: algoDropdown.height + Theme.paddingSM
                width: algoDropdown.width
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
                        model: root.algorithms

                        delegate: Item {
                            id: algoDelegate
                            required property var modelData
                            required property int index

                            width: algoPopup.width
                            height: 28

                            Rectangle {
                                anchors.fill: parent
                                anchors.leftMargin: Theme.paddingSM
                                anchors.rightMargin: Theme.paddingSM
                                color: algoArea.containsMouse ? Theme.colorTertiary : "transparent"
                                radius: Theme.radiusSM
                            }

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: Theme.paddingMD
                                anchors.rightMargin: Theme.paddingMD
                                spacing: Theme.paddingSM

                                Text {
                                    Layout.fillWidth: true
                                    text: algoDelegate.modelData.name
                                    color: Theme.textSecondary
                                    font.family: Theme.fontSans
                                    font.pixelSize: Theme.fontSizeSM
                                    verticalAlignment: Text.AlignVCenter
                                }

                                Text {
                                    text: "✓"
                                    visible: algoDelegate.index === root.value
                                    color: Theme.textAccent
                                    font.family: Theme.fontSans
                                    font.pixelSize: Theme.fontSizeSM
                                }
                            }

                            MouseArea {
                                id: algoArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    root.value = algoDelegate.index;
                                    algoPopup.close();
                                }
                            }
                        }
                    }
                }
            }
        }

        // ── Description + Requirements ──────────────────────────────────
        Rectangle {
            id: descRect
            Layout.fillWidth: true
            Layout.leftMargin: Theme.paddingLG
            Layout.rightMargin: Theme.paddingLG
            Layout.bottomMargin: Theme.paddingMD
            Layout.preferredHeight: descContent.implicitHeight + Theme.paddingMD * 2
            radius: Theme.radiusMD
            color: Theme.colorTertiary
            border.color: Theme.colorBorder
            border.width: Theme.borderSM

            Column {
                id: descContent
                x: Theme.paddingMD
                y: Theme.paddingMD
                width: descRect.width - 2 * Theme.paddingMD
                spacing: Theme.paddingSM

                Text {
                    width: parent.width
                    text: root.algorithms[root.value].description
                    color: Theme.textTertiary
                    font.family: Theme.fontSans
                    font.pixelSize: Theme.fontSizeSM
                    wrapMode: Text.WordWrap
                    lineHeight: 1.4
                }

                Text {
                    width: parent.width
                    text: root.algorithms[root.value].requirements.join("  ·  ")
                    color: Theme.textSecondary
                    font.family: Theme.fontMono
                    font.pixelSize: Theme.fontSizeSM
                    wrapMode: Text.WordWrap
                }
            }
        }
    }
}
