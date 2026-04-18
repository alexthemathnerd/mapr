import QtQuick
import QtQuick.Window

Item {
    z: 100

    readonly property int grip: 6

    MouseArea {
        width: parent.grip
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        cursorShape: Qt.SizeHorCursor
        onPressed: Window.window.startSystemResize(Qt.LeftEdge)
    }

    MouseArea {
        width: parent.grip
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        cursorShape: Qt.SizeHorCursor
        onPressed: Window.window.startSystemResize(Qt.RightEdge)
    }

    MouseArea {
        height: parent.grip
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        cursorShape: Qt.SizeVerCursor
        onPressed: Window.window.startSystemResize(Qt.TopEdge)
    }

    MouseArea {
        height: parent.grip
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        cursorShape: Qt.SizeVerCursor
        onPressed: Window.window.startSystemResize(Qt.BottomEdge)
    }

    MouseArea {
        width: parent.grip
        height: parent.grip
        anchors {
            top: parent.top
            left: parent.left
        }
        cursorShape: Qt.SizeFDiagCursor
        onPressed: Window.window.startSystemResize(Qt.TopEdge | Qt.LeftEdge)
    }

    MouseArea {
        width: parent.grip
        height: parent.grip
        anchors {
            top: parent.top
            right: parent.right
        }
        cursorShape: Qt.SizeBDiagCursor
        onPressed: Window.window.startSystemResize(Qt.TopEdge | Qt.RightEdge)
    }

    MouseArea {
        width: parent.grip
        height: parent.grip
        anchors {
            bottom: parent.bottom
            left: parent.left
        }
        cursorShape: Qt.SizeBDiagCursor
        onPressed: Window.window.startSystemResize(Qt.BottomEdge | Qt.LeftEdge)
    }

    MouseArea {
        width: parent.grip
        height: parent.grip
        anchors {
            bottom: parent.bottom
            right: parent.right
        }
        cursorShape: Qt.SizeFDiagCursor
        onPressed: Window.window.startSystemResize(Qt.BottomEdge | Qt.RightEdge)
    }
}
