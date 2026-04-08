import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

import Themes 1.0
import Components 1.0

ApplicationWindow {
    id: root
    visible: true
    title: "Mapr"
    width: 1462
    height: 1004
    minimumWidth: 1280
    minimumHeight: 800
    flags: Qt.Window | Qt.FramelessWindowHint | Qt.CustomizeWindowHint
    color: "transparent"

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        WindowBar {
            Layout.fillWidth:       true
            Layout.preferredHeight: 48
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Theme.colorPrimary
        }
    }
}
