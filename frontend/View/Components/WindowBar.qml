import QtQuick
import QtQuick.Layouts

import Themes 1.0
import Components 1.0

BorderRectangle {
    color: Theme.colorSecondary
    topLeftRadius: Theme.radiusLG
    topRightRadius: Theme.radiusLG
    borders.color: Theme.colorBorder
    borders.bottom.width: Theme.borderSM


    MouseArea {
        anchors.fill: parent
        onPressed:    Window.window.startSystemMove()
    }

    RowLayout {
        anchors.fill: parent
        spacing: Theme.paddingLG

        WindowButton {
            id: burgerButton
            isLeftCorner: true
            icon: "\uE700"
        }
        
        Rectangle {
            width: 24
            height: 24
            radius: Theme.radiusMD
            color:  "#2DD4BF"

            Text {
                anchors.centerIn: parent
                text: "\uE81E"
                color: Theme.textPrimary
                font.family: "Segoe Fluent Icons"
                font.pixelSize: 12
                font.weight: Font.Bold
            }

        }

        Text {
            text: "Mapr"
            color: Theme.textPrimary
            font.family: Theme.fontSans
            font.pixelSize: Theme.fontSizeLG
            font.weight: Font.Medium
        }

        Text {
            text: "/"
            color: Theme.textSecondary
            font.family: Theme.fontMono
            font.pixelSize: Theme.fontSizeMD
        }

        Text {
            text: "Untitled Project" // Connect to ViewModel
            color: Theme.textSecondary
            font.family: Theme.fontMono
            font.pixelSize: Theme.fontSizeMD
        }

        Item { Layout.fillWidth: true }

        Row {
            spacing: 0

            WindowButton {
                id: minimizeButton
                icon: "\uE921"
                onClicked: Window.window.showMinimized()
            }

            WindowButton {
                id: maximizeButton
                icon: "\uE922"
                onClicked: {
                    if (Window.window.visibility === Window.Maximized) {
                        Window.window.showNormal()
                        maximizeButton.icon = "\uE922"
                    } else {
                        Window.window.showMaximized()
                        maximizeButton.icon = "\uE923"
                    }
                }
            }

            WindowButton {
                id: closeButton
                isRightCorner: true
                icon: "\uE8BB"
                onClicked: Window.window.close()
            }
        }
    }
}