// qmllint disable unqualified
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Dialogs

import Themes 1.0

Window {
    id: root

    signal clearRecentRequested

    property bool showOnStartup: true
    property string version: "v1.0.0"

    title: "Mapr"
    width: 500
    height: bg.height
    flags: Qt.Window | Qt.FramelessWindowHint | Qt.CustomizeWindowHint
    color: "transparent"
    modality: Qt.ApplicationModal

    x: Screen.width / 2 - width / 2
    y: Screen.height / 2 - height / 2

    // ── File pickers ──────────────────────────────────────────────
    FileDialog {
        id: newProjectPicker
        title: "Select Heightmap"
        nameFilters: ["Image files (*.png *.jpg *.jpeg *.tif *.tiff)", "All files (*)"]
        onAccepted: startupVM.newProject(selectedFile.toString())
    }

    FileDialog {
        id: openProjectPicker
        title: "Open Project"
        nameFilters: ["Mapr projects (*.mapr)", "All files (*)"]
        onAccepted: startupVM.openProject(selectedFile.toString())
    }

    // ── Background (layer clips children to rounded rect) ─────────
    Rectangle {
        id: bg
        width: parent.width
        height: mainColumn.implicitHeight
        radius: 12
        color: Theme.colorPrimary
        border.color: Theme.colorBorder
        border.width: 1
        layer.enabled: true

        // ── Content ───────────────────────────────────────────────
        ColumnLayout {
            id: mainColumn
            width: parent.width
            spacing: 0

            // ── Header ────────────────────────────────────────────
            Item {
                Layout.fillWidth: true
                implicitHeight: headerRow.implicitHeight + 44  // 24 top + 20 bottom

                MouseArea {
                    anchors.fill: parent
                    onPressed: root.startSystemMove()
                    cursorShape: Qt.SizeAllCursor
                }

                RowLayout {
                    id: headerRow
                    anchors.top: parent.top
                    anchors.topMargin: 24
                    anchors.left: parent.left
                    anchors.leftMargin: 24
                    anchors.right: parent.right
                    anchors.rightMargin: 24
                    spacing: 12

                    Rectangle {
                        width: 36
                        height: 36
                        radius: Theme.radiusMD
                        color: Theme.colorAccent

                        Item {
                            anchors.centerIn: parent
                            width: 18
                            height: 18

                            Shape {
                                width: 24
                                height: 24
                                scale: 18 / 24
                                transformOrigin: Item.TopLeft

                                ShapePath {
                                    strokeColor: Theme.textAccent
                                    strokeWidth: 2
                                    fillColor: "transparent"
                                    capStyle: ShapePath.RoundCap
                                    joinStyle: ShapePath.RoundJoin
                                    PathSvg {
                                        path: "M3 7l9-4 9 4-9 4-9-4z"
                                    }
                                }
                                ShapePath {
                                    strokeColor: Theme.textAccent
                                    strokeWidth: 2
                                    fillColor: "transparent"
                                    capStyle: ShapePath.RoundCap
                                    joinStyle: ShapePath.RoundJoin
                                    PathSvg {
                                        path: "M3 12l9 4 9-4"
                                    }
                                }
                                ShapePath {
                                    strokeColor: Theme.textAccent
                                    strokeWidth: 2
                                    fillColor: "transparent"
                                    capStyle: ShapePath.RoundCap
                                    joinStyle: ShapePath.RoundJoin
                                    PathSvg {
                                        path: "M3 17l9 4 9-4"
                                    }
                                }
                            }
                        }
                    }

                    ColumnLayout {
                        spacing: 2

                        Text {
                            text: "Welcome"
                            font.family: Theme.fontSans
                            font.pixelSize: Theme.fontSizeLG
                            font.weight: Font.Medium
                            color: Theme.textPrimary
                        }
                        Text {
                            text: "Start a new project or open an existing one"
                            font.family: Theme.fontSans
                            font.pixelSize: Theme.fontSizeMD
                            color: Theme.textSecondary
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Theme.colorBorder
                opacity: 0.5
            }

            // ── Action Buttons ────────────────────────────────────
            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 20
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                spacing: 10

                Rectangle {
                    Layout.fillWidth: true
                    height: 44
                    radius: Theme.radiusMD
                    color: newArea.containsMouse ? Theme.colorTertiary : Theme.colorSecondary
                    border.color: Theme.colorBorder
                    border.width: 1
                    Behavior on color {
                        ColorAnimation {
                            duration: 120
                        }
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 14
                        anchors.rightMargin: 14
                        spacing: 10

                        Item {
                            width: 16
                            height: 16
                            Shape {
                                width: 24
                                height: 24
                                scale: 16 / 24
                                transformOrigin: Item.TopLeft
                                ShapePath {
                                    strokeColor: Theme.textPrimary
                                    strokeWidth: 2
                                    fillColor: "transparent"
                                    capStyle: ShapePath.RoundCap
                                    joinStyle: ShapePath.RoundJoin
                                    PathSvg {
                                        path: "M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"
                                    }
                                }
                                ShapePath {
                                    strokeColor: Theme.textPrimary
                                    strokeWidth: 2
                                    fillColor: "transparent"
                                    capStyle: ShapePath.RoundCap
                                    joinStyle: ShapePath.RoundJoin
                                    PathSvg {
                                        path: "M14 2v6h6"
                                    }
                                }
                                ShapePath {
                                    strokeColor: Theme.textPrimary
                                    strokeWidth: 2
                                    fillColor: "transparent"
                                    capStyle: ShapePath.RoundCap
                                    joinStyle: ShapePath.RoundJoin
                                    PathSvg {
                                        path: "M12 18v-6"
                                    }
                                }
                                ShapePath {
                                    strokeColor: Theme.textPrimary
                                    strokeWidth: 2
                                    fillColor: "transparent"
                                    capStyle: ShapePath.RoundCap
                                    joinStyle: ShapePath.RoundJoin
                                    PathSvg {
                                        path: "M9 15h6"
                                    }
                                }
                            }
                        }

                        Text {
                            text: "New project"
                            font.family: Theme.fontSans
                            font.pixelSize: Theme.fontSizeMD
                            font.weight: Font.Medium
                            color: Theme.textPrimary
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                    }

                    MouseArea {
                        id: newArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: newProjectPicker.open()
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 44
                    radius: Theme.radiusMD
                    color: openArea.containsMouse ? Theme.colorTertiary : Theme.colorSecondary
                    border.color: Theme.colorBorder
                    border.width: 1
                    Behavior on color {
                        ColorAnimation {
                            duration: 120
                        }
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 14
                        anchors.rightMargin: 14
                        spacing: 10

                        Item {
                            width: 16
                            height: 16
                            Shape {
                                width: 24
                                height: 24
                                scale: 16 / 24
                                transformOrigin: Item.TopLeft
                                ShapePath {
                                    strokeColor: Theme.textPrimary
                                    strokeWidth: 2
                                    fillColor: "transparent"
                                    capStyle: ShapePath.RoundCap
                                    joinStyle: ShapePath.RoundJoin
                                    PathSvg {
                                        path: "M3 7a2 2 0 0 1 2-2h4l2 2h8a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"
                                    }
                                }
                            }
                        }

                        Text {
                            text: "Open project…"
                            font.family: Theme.fontSans
                            font.pixelSize: Theme.fontSizeMD
                            font.weight: Font.Medium
                            color: Theme.textPrimary
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                    }

                    MouseArea {
                        id: openArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: openProjectPicker.open()
                    }
                }
            }

            // ── Recent ────────────────────────────────────────────
            ColumnLayout {
                Layout.fillWidth: true
                Layout.topMargin: 20
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                Layout.bottomMargin: 24
                spacing: 10

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "Recent"
                        font.family: Theme.fontSans
                        font.pixelSize: Theme.fontSizeSM
                        font.weight: Font.Medium
                        font.capitalization: Font.AllUppercase
                        font.letterSpacing: 0.6
                        color: Theme.textSecondary
                    }
                    Item {
                        Layout.fillWidth: true
                    }
                    Text {
                        text: "Clear"
                        font.family: Theme.fontSans
                        font.pixelSize: Theme.fontSizeSM
                        color: Theme.textSecondary
                        visible: startupVM.recentProjects.length > 0
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.clearRecentRequested()
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: recentCol.implicitHeight
                    radius: Theme.radiusMD
                    color: Theme.colorSecondary

                    Column {
                        id: recentCol
                        width: parent.width

                        // Empty state
                        Item {
                            width: recentCol.width
                            height: 52
                            visible: startupVM.recentProjects.length === 0

                            Text {
                                anchors.centerIn: parent
                                text: "No recent projects"
                                font.family: Theme.fontSans
                                font.pixelSize: Theme.fontSizeMD
                                color: Theme.textTertiary
                            }
                        }

                        Repeater {
                            model: startupVM.recentProjects

                            delegate: Item {
                                id: row
                                required property var modelData
                                required property int index

                                width: recentCol.width
                                height: 52

                                Rectangle {
                                    anchors.fill: parent
                                    color: rowArea.containsMouse ? Qt.rgba(Theme.colorBorder.r, Theme.colorBorder.g, Theme.colorBorder.b, 0.4) : "transparent"
                                    Behavior on color {
                                        ColorAnimation {
                                            duration: 100
                                        }
                                    }
                                }

                                Rectangle {
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    height: 1
                                    color: Theme.colorBorder
                                    opacity: 0.5
                                    visible: row.index < startupVM.recentProjects.length - 1
                                }

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 12
                                    anchors.rightMargin: 12
                                    spacing: 12

                                    Rectangle {
                                        width: 32
                                        height: 32
                                        radius: Theme.radiusMD
                                        color: row.modelData.iconBg

                                        Item {
                                            anchors.centerIn: parent
                                            width: 14
                                            height: 14

                                            Shape {
                                                width: 24
                                                height: 24
                                                scale: 14 / 24
                                                transformOrigin: Item.TopLeft
                                                ShapePath {
                                                    strokeColor: row.modelData.iconStroke
                                                    strokeWidth: 2
                                                    fillColor: "transparent"
                                                    capStyle: ShapePath.RoundCap
                                                    joinStyle: ShapePath.RoundJoin
                                                    PathSvg {
                                                        path: "M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"
                                                    }
                                                }
                                                ShapePath {
                                                    strokeColor: row.modelData.iconStroke
                                                    strokeWidth: 2
                                                    fillColor: "transparent"
                                                    capStyle: ShapePath.RoundCap
                                                    joinStyle: ShapePath.RoundJoin
                                                    PathSvg {
                                                        path: "M14 2v6h6"
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 2

                                        Text {
                                            Layout.fillWidth: true
                                            text: row.modelData.name
                                            font.family: Theme.fontSans
                                            font.pixelSize: Theme.fontSizeMD
                                            font.weight: Font.Medium
                                            color: Theme.textPrimary
                                            elide: Text.ElideRight
                                        }
                                        Text {
                                            Layout.fillWidth: true
                                            text: row.modelData.path
                                            font.family: Theme.fontSans
                                            font.pixelSize: Theme.fontSizeSM
                                            color: Theme.textTertiary
                                            elide: Text.ElideRight
                                        }
                                    }

                                    Text {
                                        text: row.modelData.time
                                        font.family: Theme.fontSans
                                        font.pixelSize: Theme.fontSizeSM
                                        color: Theme.textTertiary
                                    }
                                }

                                MouseArea {
                                    id: rowArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: startupVM.openRecent(row.modelData.path)
                                }
                            }
                        }
                    }
                }
            }

            // ── Footer ────────────────────────────────────────────
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Theme.colorBorder
                opacity: 0.5
            }

            Rectangle {
                Layout.fillWidth: true
                height: 40
                color: Theme.colorSecondary
                bottomLeftRadius: 12
                bottomRightRadius: 12

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 24
                    anchors.rightMargin: 24

                    RowLayout {
                        spacing: 8

                        Rectangle {
                            width: 14
                            height: 14
                            radius: 3
                            color: root.showOnStartup ? Theme.textAccent : "transparent"
                            border.color: root.showOnStartup ? Theme.textAccent : Theme.colorBorder
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: "✓"
                                font.pixelSize: 9
                                font.family: Theme.fontSans
                                color: Theme.colorPrimary
                                visible: root.showOnStartup
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.showOnStartup = !root.showOnStartup
                            }
                        }

                        Text {
                            text: "Show on startup"
                            font.family: Theme.fontSans
                            font.pixelSize: Theme.fontSizeSM
                            color: Theme.textSecondary
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.showOnStartup = !root.showOnStartup
                            }
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Text {
                        text: root.version
                        font.family: Theme.fontSans
                        font.pixelSize: Theme.fontSizeSM
                        color: Theme.textTertiary
                    }

                    Text {
                        text: Theme.isDark ? "☀" : "☾"
                        font.pixelSize: Theme.fontSizeMD
                        color: themeToggle.containsMouse ? Theme.textPrimary : Theme.textTertiary
                        Behavior on color {
                            ColorAnimation {
                                duration: 120
                            }
                        }
                        MouseArea {
                            id: themeToggle
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Theme.toggleTheme()
                        }
                    }
                }
            }
        }
    }
}
