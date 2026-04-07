import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QML.Components 1.0
import QML.Themes 1.0

ApplicationWindow {
    id: root
    visible:       true
    title:         "Mapr"
    width:         1462
    height:        1004
    minimumWidth:  1280
    minimumHeight: 800
    flags:         Qt.Window | Qt.FramelessWindowHint

    color: Theme.background

    ColumnLayout {
        anchors.fill: parent
        spacing:      0

        WindowMenuBar {
            Layout.fillWidth:       true
            Layout.preferredHeight: 48
        }

        // Border under menu bar
        Rectangle {
            Layout.fillWidth: true
            height:           1
            color:            Theme.border
        }

        RowLayout {
            Layout.fillWidth:  true
            Layout.fillHeight: true
            spacing:           0

            LeftPanel {
                Layout.preferredWidth: 250
                Layout.fillHeight:     true
            }

            Rectangle {
                width:             1
                Layout.fillHeight: true
                color:             Theme.border
            }

            // Canvas column
            ColumnLayout {
                Layout.fillWidth:  true
                Layout.fillHeight: true
                spacing:           0

                CanvasMenuBar {
                    Layout.fillWidth:       true
                    Layout.preferredHeight: 36
                }

                MapDisplay {
                    Layout.fillWidth:  true
                    Layout.fillHeight: true
                }

                CanvasFooter {
                    Layout.fillWidth:       true
                    Layout.preferredHeight: 24
                }
            }

            Rectangle {
                width:             1
                Layout.fillHeight: true
                color:             Theme.border
            }

            RightPanel {
                Layout.preferredWidth: 280
                Layout.fillHeight:     true
            }
        }
    }
}
