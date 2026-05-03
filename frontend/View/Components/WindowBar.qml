// qmllint disable unqualified
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import Themes 1.0
import Components 1.0

Item {
    id: root

    property string projectName: ""

    signal saveRequested()

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
                icon: ""
                onClicked: burgerMenu.open()

                Popup {
                    id: burgerMenu
                    parent: burgerButton
                    x: 0
                    y: burgerButton.height + Theme.paddingSM
                    width: 180
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

                        // ── File section ────────────────────────────────
                        Text {
                            leftPadding: Theme.paddingMD
                            rightPadding: Theme.paddingMD
                            topPadding: Theme.paddingXS
                            bottomPadding: Theme.paddingXS
                            text: "File"
                            color: Theme.textTertiary
                            font.family: Theme.fontSans
                            font.pixelSize: Theme.fontSizeSM
                            font.weight: Font.Medium
                        }

                        Item {
                            width: parent.width
                            height: 1

                            Rectangle {
                                anchors.fill: parent
                                anchors.leftMargin: Theme.paddingSM
                                anchors.rightMargin: Theme.paddingSM
                                color: Theme.colorBorder
                            }
                        }

                        Item {
                            id: saveItem
                            width: burgerMenu.width
                            height: 28

                            Rectangle {
                                anchors.fill: parent
                                anchors.leftMargin: Theme.paddingSM
                                anchors.rightMargin: Theme.paddingSM
                                color: saveArea.containsMouse ? Theme.colorTertiary : "transparent"
                                radius: Theme.radiusSM
                            }

                            Row {
                                anchors.fill: parent
                                anchors.leftMargin: Theme.paddingMD
                                anchors.rightMargin: Theme.paddingMD

                                Text {
                                    width: parent.width - shortcutText.width
                                    height: parent.height
                                    text: "Save"
                                    color: Theme.textSecondary
                                    font.family: Theme.fontSans
                                    font.pixelSize: Theme.fontSizeSM
                                    verticalAlignment: Text.AlignVCenter
                                }

                                Text {
                                    id: shortcutText
                                    height: parent.height
                                    text: "Ctrl+S"
                                    color: Theme.textTertiary
                                    font.family: Theme.fontMono
                                    font.pixelSize: Theme.fontSizeSM
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            MouseArea {
                                id: saveArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    burgerMenu.close();
                                    root.saveRequested();
                                }
                            }
                        }

                        // ── Divider ─────────────────────────────────────
                        Item {
                            width: parent.width
                            height: Theme.paddingSM
                        }

                        Item {
                            width: parent.width
                            height: 1

                            Rectangle {
                                anchors.fill: parent
                                anchors.leftMargin: Theme.paddingSM
                                anchors.rightMargin: Theme.paddingSM
                                color: Theme.colorBorder
                            }
                        }

                        Item {
                            width: parent.width
                            height: Theme.paddingSM
                        }

                        // ── Theme ────────────────────────────────────────
                        Item {
                            id: themeItem
                            width: burgerMenu.width
                            height: 28

                            Rectangle {
                                anchors.fill: parent
                                anchors.leftMargin: Theme.paddingSM
                                anchors.rightMargin: Theme.paddingSM
                                color: themeArea.containsMouse ? Theme.colorTertiary : "transparent"
                                radius: Theme.radiusSM
                            }

                            Text {
                                anchors.fill: parent
                                anchors.leftMargin: Theme.paddingMD
                                anchors.rightMargin: Theme.paddingMD
                                text: Theme.isDark ? "Switch to Light Theme" : "Switch to Dark Theme"
                                color: Theme.textSecondary
                                font.family: Theme.fontSans
                                font.pixelSize: Theme.fontSizeSM
                                verticalAlignment: Text.AlignVCenter
                            }

                            MouseArea {
                                id: themeArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    burgerMenu.close();
                                    Theme.toggleTheme();
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                width: 16
                height: 16
                radius: Theme.radiusMD
                color: Theme.colorLogo

                Text {
                    anchors.centerIn: parent
                    text: ""
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
                text: root.projectName || "Untitled Project"
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
                    icon: ""
                    onClicked: Window.window.showMinimized()
                }

                WindowButton {
                    id: maximizeButton
                    icon: Window.window.visibility === Window.Maximized ? "" : ""
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
                    icon: ""
                    onClicked: Window.window.close()
                }
            }
        }
    }
}
