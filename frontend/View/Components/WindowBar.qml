import QtQuick
import QtQuick.Layouts

import Themes 1.0
import Components 1.0

Item {
    id: root

    BorderRectangle {
        anchors.fill: parent
        color: Theme.colorSecondary
        topLeftRadius: Window.window.visibility !== Window.Maximized ? Theme.radiusLG : 0
        topRightRadius: Window.window.visibility !== Window.Maximized ? Theme.radiusLG : 0
        borders.color: Theme.colorBorder
        borders.bottom.width: Theme.borderSM

        MouseArea {
            anchors.fill: parent

            property bool isDragging: false
            property real startWinX: 0
            property real startWinY: 0
            property real startCursorX: 0
            property real startCursorY: 0

            onPressed: isDragging = false

            onPositionChanged: {
                if (!pressed)
                    return;
                var cursor = mapToGlobal(mouseX, mouseY);

                if (!isDragging) {
                    isDragging = true;

                    if (Window.window.visibility === Window.Maximized) {
                        const barRatio = mouseX / width;
                        Window.window.showNormal();
                        Window.window.x = cursor.x - barRatio * Window.window.width;
                        Window.window.y = 0;
                    }

                    startWinX = Window.window.x;
                    startWinY = Window.window.y;
                    startCursorX = cursor.x;
                    startCursorY = cursor.y;
                    return;
                }

                Window.window.x = startWinX + (cursor.x - startCursorX);
                Window.window.y = startWinY + (cursor.y - startCursorY);
            }

            onReleased: {
                if (isDragging && Window.window.y <= 10)
                    Window.window.showMaximized();

                isDragging = false;
            }
        }

        RowLayout {
            anchors.fill: parent
            spacing: Theme.paddingLG

            WindowButton {
                id: burgerButton
                isLeftCorner: true
                icon: "\uE700"
                onClicked: Theme.toggleTheme()
            }

            Rectangle {
                width: 16
                height: 16
                radius: Theme.radiusMD
                color: Theme.colorLogo

                Text {
                    anchors.centerIn: parent
                    text: "\uE81E"
                    color: Theme.textPrimary
                    font.family: "Segoe Fluent Icons"
                    font.pixelSize: 8
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

            Item {
                Layout.fillWidth: true
            }

            Row {
                spacing: 0

                WindowButton {
                    id: minimizeButton
                    icon: "\uE921"
                    onClicked: Window.window.showMinimized()
                }

                WindowButton {
                    id: maximizeButton
                    icon: Window.window.visibility === Window.Maximized ? "\uE923" : "\uE922"
                    onClicked: {
                        if (Window.window.visibility === Window.Maximized)
                            Window.window.showNormal();
                        else
                            Window.window.showMaximized();
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
}
