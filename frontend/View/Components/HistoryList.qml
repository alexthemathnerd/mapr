pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import Themes 1.0
import Components 1.0

Item {
    id: root

    readonly property string lastAction: mockActions.length > 0 ? mockActions[mockActions.length - 1].action : ""

    readonly property var mockActions: [
        {
            action: "Project Created",
            timestamp: Date.now()
        },
        {
            action: "Height Generated",
            timestamp: Date.now()
        },
    ]

    RowLayout {
        anchors.fill: parent
        spacing: Theme.paddingSM

        ListView {
            id: historyList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: root.mockActions
            ScrollBar.vertical: scroll
            spacing: Theme.paddingMD

            delegate: HistoryItem {
                required property var modelData
                required property int index

                width: historyList.width
                actionName: modelData.action
                timestamp: modelData.timestamp
            }
        }

        ScrollBar {
            id: scroll
            Layout.fillHeight: true
            visible: historyList.contentHeight > historyList.height
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
