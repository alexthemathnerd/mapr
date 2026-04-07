import QtQuick
import QtQuick.Layouts
import QML.Themes 1.0

Rectangle {
    property string layerBreadcrumb: "Height · v1"
    property int    zoomPercent:     100

    color: Theme.sidebar

    // Bottom border
    Rectangle {
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
        height: 1
        color:  Theme.border
    }

    RowLayout {
        anchors {
            fill:        parent
            leftMargin:  Theme.paddingMd
            rightMargin: Theme.paddingMd
        }
        spacing: 8

        // Layer breadcrumb
        Text {
            text:           layerBreadcrumb
            color:          Theme.textPrimary
            font.family:    Theme.fontLabel
            font.pixelSize: 13
            font.weight:    Font.Medium
        }

        // Spacer
        Item { Layout.fillWidth: true }

        // Zoom out
        Rectangle {
            width:  24
            height: 24
            radius: Theme.radiusSm
            color:  "transparent"
            border.color: Theme.border
            border.width: 1

            Text {
                anchors.centerIn: parent
                text:             "−"
                color:            Theme.textSecondary
                font.pixelSize:   14
            }
        }

        // Zoom percent
        Text {
            text:           zoomPercent + "%"
            color:          Theme.textSecondary
            font.family:    Theme.fontMono
            font.pixelSize: 12
            Layout.minimumWidth: 36
            horizontalAlignment: Text.AlignHCenter
        }

        // Zoom in
        Rectangle {
            width:  24
            height: 24
            radius: Theme.radiusSm
            color:  "transparent"
            border.color: Theme.border
            border.width: 1

            Text {
                anchors.centerIn: parent
                text:             "+"
                color:            Theme.textSecondary
                font.pixelSize:   14
            }
        }

        // Fit button
        Rectangle {
            implicitWidth:  fitLabel.implicitWidth + 16
            height:         24
            radius:         Theme.radiusSm
            color:          "transparent"
            border.color:   Theme.border
            border.width:   1

            Text {
                id:             fitLabel
                anchors.centerIn: parent
                text:           "Fit"
                color:          Theme.textSecondary
                font.family:    Theme.fontLabel
                font.pixelSize: 12
            }
        }
    }
}
