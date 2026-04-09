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
    color: "transparent"

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        WindowBar {
            Layout.fillWidth: true
            Layout.preferredHeight: 48
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

                    Rectangle {
                        border.color: Theme.colorBorder
                        radius: Theme.radiusMD
                        Layout.fillWidth: true
                        Layout.preferredHeight: 150
                        color: Theme.colorPrimary
                    }
                }
            }

            BorderRectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Theme.colorPrimary

                Text {
                    anchors.centerIn: parent
                    text: "Canvas will go here!"
                    font.family: Theme.fontMono
                    font.pixelSize: Theme.fontSizeSM
                    font.weight: Font.Bold
                    font.capitalization: Font.AllUppercase
                    color: Theme.textPrimary
                }
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
