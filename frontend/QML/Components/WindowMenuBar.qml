import QtQuick
import QtQuick.Layouts
import QML.Themes 1.0

Rectangle {
    color: Theme.sidebar

    MouseArea {
        anchors.fill: parent
        onPressed:    Window.window.startSystemMove()
    }

    RowLayout {
        anchors {
            fill:        parent
            leftMargin:  0
            rightMargin: 0
        }

        spacing: 0

        Text {
            text:           "\uE700"
            color:          Theme.textSecondary
            font.family:    "Segoe Fluent Icons"
            font.pixelSize: 16
        }

        Rectangle {
            width:  24
            height: 24
            radius: Theme.radiusSM
            color:  "#2DD4BF"

            Text {
                anchors.centerIn: parent
                text:             "M"
                color:            "#0D1F1A"
                font.family:      Theme.fontLabel
                font.pixelSize:   12
                font.weight:      Font.Bold
            }
        }

        // Application name
        Text {
            text:           "Mapr"
            color:          Theme.textPrimary
            font.family:    Theme.fontLabel
            font.pixelSize: 14
            font.weight:    Font.DemiBold
        }

        // Separator
        Text {
            text:           "/"
            color:          Theme.textMuted
            font.family:    Theme.fontLabel
            font.pixelSize: 14
        }

        // Project name
        Text {
            text:           "Untitled Project"
            color:          Theme.textSecondary
            font.family:    Theme.fontLabel
            font.pixelSize: 13
        }

        Item { Layout.fillWidth: true }

        // ── Window controls ────────────────────────────────────────
        Row {
            spacing: 0

            // Minimize — U+E921
            Rectangle {
                width:  46
                height: 48
                color:  minimizeArea.containsMouse ? Theme.hover : "transparent"

                Text {
                    anchors.centerIn: parent
                    text:             "\uE921"
                    color:            Theme.textSecondary
                    font.family:      "Segoe Fluent Icons"
                    font.pixelSize:   10
                }

                MouseArea {
                    id:           minimizeArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:    Window.window.showMinimized()
                }
            }

            // Maximize / Restore — U+E922 / U+E923
            Rectangle {
                width:  46
                height: 48
                color:  maximizeArea.containsMouse ? Theme.hover : "transparent"

                Text {
                    anchors.centerIn: parent
                    text: Window.window && Window.window.visibility === Window.Maximized
                          ? "\uE923" : "\uE922"
                    color:            Theme.textSecondary
                    font.family:      "Segoe Fluent Icons"
                    font.pixelSize:   10
                }

                MouseArea {
                    id:           maximizeArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        var w = Window.window
                        w.visibility === Window.Maximized ? w.showNormal() : w.showMaximized()
                    }
                }
            }

            // Close — U+E8BB, Windows-style red on hover
            Rectangle {
                width:  46
                height: 48
                color:  closeArea.containsMouse ? "#C42B1C" : "transparent"

                Text {
                    anchors.centerIn: parent
                    text:             "\uE8BB"
                    color:            closeArea.containsMouse ? "#FFFFFF" : Theme.textSecondary
                    font.family:      "Segoe Fluent Icons"
                    font.pixelSize:   10
                }

                MouseArea {
                    id:           closeArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:    Window.window.close()
                }
            }
        }
    }
}
