import QtQuick
import QtQuick.Layouts

import Themes 1.0

Item {
    id: root

    enum LayerStatus {
        Ready,   // 0
        Empty,   // 1
        Locked   // 2
    }

    property color  dotColor:   "#888888"
    property string layerName:  "Layer"
    property int    status:     MapLayer.Locked
    property bool   isSelected: false

    signal clicked()

    readonly property var _statusLabels:  ["ready",            "empty",            "locked"]
    readonly property var _statusTexts:   [Theme.textAccent,   Theme.textAccent,   Theme.textSecondary]
    readonly property var _statusColors:  [Theme.colorAccent,  Theme.colorAccent,  Theme.colorSecondary]
    readonly property var _statusBorders: ["transparent",      "transparent",      Theme.colorBorder]
    readonly property var _layerTexts:    [Theme.textPrimary,  Theme.textSecondary, Theme.textSecondary]

    implicitHeight: 36
    implicitWidth:  200

    // Hover background — hidden when selected so the ListView highlight shows through
    Rectangle {
        anchors.fill: parent
        radius:       Theme.radiusMD
        color:        mouse.containsMouse && !root.isSelected
                      ? Theme.colorTertiary
                      : "transparent"
    }

    RowLayout {
        anchors.fill:    parent
        anchors.margins: Theme.paddingLG
        spacing:         Theme.paddingLG

        // Coloured dot
        Rectangle {
            width:  8
            height: 8
            radius: width / 2
            color:  root.dotColor
        }

        // Layer name
        Text {
            Layout.fillWidth: true
            text:           root.layerName
            color:          root._layerTexts[root.status]
            font.family:    Theme.fontSans
            font.pixelSize: Theme.fontSizeMD
            elide:          Text.ElideRight
        }

        // Status badge
        Rectangle {
            width:        60
            height:       Theme.fontSizeMD + Theme.paddingSM * 2
            radius:       Theme.radiusMD
            color:        root._statusColors[root.status]
            border.color: root._statusBorders[root.status]

            Text {
                anchors.centerIn: parent
                text:           root._statusLabels[root.status]
                color:          root._statusTexts[root.status]
                font.family:    Theme.fontSans
                font.pixelSize: Theme.fontSizeSM
            }
        }
    }

    // MouseArea on top of everything to capture hover and click
    MouseArea {
        id:           mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape:  Qt.PointingHandCursor
        onClicked:    root.clicked()
    }
}
