import QtQuick
import QtQuick.Layouts

import Themes 1.0
import Components 1.0

Item {
    id: root
    property alias layerName: canvasBar.layerName
    property string lastAction: ""

    MapCanvasViewModel {
        id: viewModel
    }

    Component.onCompleted: {
        if (typeof devTestImagePath !== "undefined" && devTestImagePath !== "")
            viewModel.loadImageFromPath(devTestImagePath)
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        CanvasBar {
            id: canvasBar
            Layout.fillWidth: true
            Layout.preferredHeight: 32
            onZoomIn: viewModel.zoomIn()
            onZoomOut: viewModel.zoomOut()
            onZoomToFit: viewModel.zoomToFit()
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            MapCanvasItem {
                id: canvasItem
                anchors.fill: parent
                viewModel: viewModel
                backgroundColor: Theme.colorPrimary
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor

                property real startX: 0
                property real startY: 0
                property real startPanX: 0
                property real startPanY: 0

                onPressed: mouse => {
                    startX = mouse.x
                    startY = mouse.y
                    startPanX = viewModel.panX
                    startPanY = viewModel.panY
                }

                onPositionChanged: mouse => {
                    viewModel.setPan(
                        startPanX + mouse.x - startX,
                        startPanY + mouse.y - startY
                    )
                }
            }

            WheelHandler {
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                onWheel: event => {
                    const factor = event.angleDelta.y > 0 ? 1.15 : (1.0 / 1.15)
                    viewModel.zoomAtPoint(factor, event.x, event.y)
                }
            }
        }

        CanvasFooter {
            lastAction: root.lastAction
            zoomPercent: viewModel.zoomPercent
            Layout.fillWidth: true
            Layout.preferredHeight: 24
        }
    }
}
