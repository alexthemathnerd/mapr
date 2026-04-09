import QtQuick
import QtQuick.Layouts

import Themes 1.0
import Components 1.0

Item {

    implicitHeight: outerLayout.implicitHeight + outerLayout.spacing * 2

    BorderRectangle {
        anchors.fill: parent
        color: Theme.colorSecondary
        borders.color: Theme.colorBorder
        borders.top.width: Theme.borderSM

        RowLayout {
            id: outerLayout
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
        }
    }
}
