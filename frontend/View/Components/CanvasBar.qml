import QtQuick
import QtQuick.Layouts

import Themes 1.0
import Components 1.0

Item {
    id: root
    property string layerName: "Height"

    signal zoomIn()
    signal zoomOut()
    signal zoomToFit()

    implicitHeight: outerLayout.implicitHeight + outerLayout.spacing * 2

    BorderRectangle {
        anchors.fill: parent
        color: Theme.colorSecondary
        borders.color: Theme.colorBorder
        borders.bottom.width: Theme.borderSM

        RowLayout {
            id: outerLayout
            anchors.fill: parent
            spacing: Theme.paddingLG
            anchors.leftMargin: Theme.paddingLG

            Text {
                text: root.layerName
                color: Theme.textPrimary
                font.family: Theme.fontSans
                font.pixelSize: Theme.fontSizeMD
                font.weight: Font.Medium
            }

            Item {
                Layout.fillWidth: true
            }

            Row {
                spacing: 0

                WindowButton {
                    id: zoomOutButton
                    icon: "\uE71F"
                    onClicked: root.zoomOut()
                }

                WindowButton {
                    id: zoomInButton
                    icon: "\uE8A3"
                    onClicked: root.zoomIn()
                }

                WindowButton {
                    id: zoomFitButton
                    icon: "\uE9A6"
                    onClicked: root.zoomToFit()
                }
            }
        }
    }
}
