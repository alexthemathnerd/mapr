import QtQuick
import QtQuick.Layouts

Rectangle {
    component Border: QtObject {
        property int width: 0
        property color color: "transparent"
    }

    component Borders: QtObject {
        id: root
        property int width: 0
        property color color: "transparent"
        property Border top: Border {
            width: root.width
            color: root.color
        }
        property Border right: Border {
            width: root.width
            color: root.color
        }
        property Border bottom: Border {
            width: root.width
            color: root.color
        }
        property Border left: Border {
            width: root.width
            color: root.color
        }
    }

    property Borders borders: Borders {}
    default property alias content: container.children

    id: root

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            height: root.borders.top.width
            color: root.borders.top.color
            visible: root.borders.top.width > 0
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            Rectangle {
                width: root.borders.left.width
                Layout.fillHeight: true
                color: root.borders.left.color
                visible: root.borders.left.width > 0
            }

            Item {
                id: container
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Rectangle {
                width: root.borders.right.width
                Layout.fillHeight: true
                color: root.borders.right.color
                visible: root.borders.right.width > 0
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: root.borders.bottom.width
            color: root.borders.bottom.color
            visible: root.borders.bottom.width > 0
        }

    }
}