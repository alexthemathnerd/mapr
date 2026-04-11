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

                    Rectangle {
                        border.color: Theme.colorBorder
                        radius: Theme.radiusMD
                        Layout.fillWidth: true
                        Layout.preferredHeight: 150
                        color: Theme.colorPrimary
                    }
                }

                Section {
                    Layout.fillWidth: true
                    sectionTitle: "History"
                    hasBottomBorder: false
                    expand: true

                    HistoryList {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                }
            }

            MapCanvas {
                id: canvas
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

                    Rectangle {
                        border.color: Theme.colorBorder
                        radius: Theme.radiusMD
                        Layout.fillWidth: true
                        Layout.preferredHeight: 150
                        color: Theme.colorPrimary
                    }
                }

                Section {
                    Layout.fillWidth: true
                    sectionTitle: "Generation Configuration"

                    Rectangle {
                        border.color: Theme.colorBorder
                        radius: Theme.radiusMD
                        Layout.fillWidth: true
                        Layout.preferredHeight: 150
                        color: Theme.colorPrimary
                    }
                }

                Section {
                    Layout.fillWidth: true
                    sectionTitle: "Display Configuration"

                    Rectangle {
                        border.color: Theme.colorBorder
                        radius: Theme.radiusMD
                        Layout.fillWidth: true
                        Layout.preferredHeight: 150
                        color: Theme.colorPrimary
                    }
                }
            }
        }
    }
}
