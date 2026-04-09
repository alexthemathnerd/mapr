pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
// Basic import forces the unstyled base control — no arrows, no platform hover chrome
import QtQuick.Controls.Basic

import Themes 1.0
import Components 1.0

Item {
    id: root

    readonly property var mockLayers: [
        {
            name: "Height",
            color: "#639922",
            state: MapLayer.Ready
        },
        {
            name: "Pressure",
            color: "#DD9B77",
            state: MapLayer.Empty
        },
        {
            name: "Temperature",
            color: "#E24B4A",
            state: MapLayer.Empty
        },
        {
            name: "Wind",
            color: "#FFD736",
            state: MapLayer.Empty
        },
        {
            name: "Current",
            color: "#378ADD",
            state: MapLayer.Locked
        },
        {
            name: "Climate",
            color: "#7F77DD",
            state: MapLayer.Locked
        },
        {
            name: "Climate",
            color: "#7F77DD",
            state: MapLayer.Locked
        },
        {
            name: "Climate",
            color: "#7F77DD",
            state: MapLayer.Locked
        },
    ]

    RowLayout {
        anchors.fill: parent
        spacing: Theme.paddingSM

        ListView {
            id: layerList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: root.mockLayers
            ScrollBar.vertical: scroll
            spacing: Theme.paddingMD

            highlightMoveDuration: 0

            highlight: Rectangle {
                color: Theme.colorTertiary
                radius: Theme.radiusMD
                border.color: Theme.colorBorder
            }

            delegate: MapLayer {
                required property var modelData
                required property int index

                width: layerList.width
                dotColor: modelData.color
                layerName: modelData.name
                status: modelData.state
                isSelected: ListView.isCurrentItem
                onClicked: layerList.currentIndex = index
            }
        }

        ScrollBar {
            id: scroll
            Layout.fillHeight: true
            policy: ScrollBar.AsNeeded

            contentItem: Rectangle {
                implicitWidth: 3
                radius: 2
                color: Theme.colorBorder
                opacity: scroll.pressed ? 1.0 : scroll.hovered ? 0.7 : 0.4
                Behavior on opacity {
                    NumberAnimation {
                        duration: 150
                    }
                }
            }

            background: Rectangle {
                implicitWidth: 3
                radius: 4
                color: Theme.colorPrimary
            }
        }
    }
}
