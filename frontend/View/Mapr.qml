import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

import Themes 1.0
import Components 1.0

ApplicationWindow {
    id: root
    visible: true
    title: "Mapr"
    width: 1462
    height: 1004
    minimumWidth: 1280
    minimumHeight: 800
    flags: Qt.Window | Qt.FramelessWindowHint | Qt.CustomizeWindowHint
    color: root.visibility === Window.Maximized ? Theme.colorPrimary : "transparent"

    WindowResize {
        anchors.fill: parent
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        WindowBar {
            Layout.fillWidth: true
            Layout.preferredHeight: 32
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            Panel {
                id: leftPanel
                Layout.preferredWidth: 250
                Layout.fillHeight: true
                hasLeftCorner: true

                Section {
                    Layout.fillWidth: true
                    sectionTitle: "Map Layers"

                    MapLayerList {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 220
                        onSelect: layer => {
                            canvas.layerName = layer.layerName;
                        }
                    }
                }

                Section {
                    Layout.fillWidth: true
                    sectionTitle: "Parameters"

                    ParameterList {
                        Layout.fillWidth: true
                        mockParameters: [
                            {
                                type: "random",
                                label: "Seed",
                                value: 0,
                                defaultValue: 0,
                                min: 0,
                                max: 999999
                            },
                            {
                                type: "number",
                                label: "Scale",
                                value: 5.0,
                                defaultValue: 5.0,
                                min: 0.1,
                                max: 50.0,
                                step: 0.5
                            },
                            {
                                type: "boolean",
                                label: "Islands",
                                value: true,
                                defaultValue: true
                            },
                            {
                                type: "season",
                                label: "Season",
                                value: false,
                                defaultValue: false
                            },
                            {
                                type: "enum",
                                label: "Biome",
                                value: 0,
                                defaultValue: 0,
                                options: ["Temperate", "Desert", "Arctic", "Tropical"]
                            },
                            {
                                type: "cmap",
                                label: "Color Map",
                                value: 0,
                                defaultValue: 0
                            }
                        ]
                    }
                }

                Section {
                    Layout.fillWidth: true
                    sectionTitle: "History"
                    hasBottomBorder: false
                    expand: true

                    HistoryList {
                        id: projectHistory
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                }
            }

            MapCanvas {
                id: canvas
                lastAction: projectHistory.lastAction
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Panel {
                id: rightPanel
                Layout.preferredWidth: 250
                Layout.fillHeight: true
                hasRightCorner: true

                Section {
                    Layout.fillWidth: true
                    sectionTitle: "Algorithm"

                    AlgorithmConfig {
                        Layout.fillWidth: true
                    }
                }

                Section {
                    Layout.fillWidth: true
                    sectionTitle: "Generation Configuration"

                    GenConfig {
                        Layout.fillWidth: true
                    }
                }

                Section {
                    Layout.fillWidth: true
                    sectionTitle: "Display Configuration"
                    hasBottomBorder: false

                    DisplayConfig {
                        Layout.fillWidth: true
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.leftMargin: Theme.paddingLG
                    Layout.rightMargin: Theme.paddingLG
                    Layout.topMargin: Theme.paddingLG
                    Layout.preferredHeight: 28
                    radius: Theme.radiusMD
                    color: generateArea.containsMouse ? Theme.teal400 : Theme.teal600

                    Behavior on color {
                        ColorAnimation {
                            duration: 120
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Generate"
                        color: Theme.teal50
                        font.family: Theme.fontSans
                        font.pixelSize: Theme.fontSizeMD
                        font.weight: Font.Medium
                    }

                    MouseArea {
                        id: generateArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                    }
                }

                Item {
                    Layout.fillHeight: true
                }
            }
        }
    }
}
