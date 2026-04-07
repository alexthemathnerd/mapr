import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QML.Themes 1.0

Rectangle {
    color: Theme.sidebar

    readonly property var layerData: [
        { name: "Height",      color: "#7B9E87", state: "ready"  },
        { name: "Pressure",    color: "#8A6BBE", state: "empty"  },
        { name: "Temperature", color: "#C97D4A", state: "empty"  },
        { name: "Wind",        color: "#5BA3C9", state: "empty"  },
        { name: "Current",     color: "#3B8A8A", state: "locked" },
        { name: "Climate",     color: "#9E7B5A", state: "locked" },
    ]

    readonly property var paramData: [
        { label: "Smooth",     type: "Boolean" },
        { label: "Octaves",    type: "Number"  },
        { label: "Season",     type: "Season"  },
        { label: "Style",      type: "Enum"    },
        { label: "Seed",       type: "Random"  },
        { label: "Colour Map", type: "Cmap"    },
    ]

    ScrollView {
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true

        ColumnLayout {
            width:   parent.width
            spacing: 0

            // ── MAP LAYERS ────────────────────────────────────────
            SectionHeader {
                text:             "Map Layers"
                Layout.fillWidth: true
                Layout.topMargin: 4
            }

            Rectangle {
                Layout.fillWidth: true
                height:           1
                color:            Theme.border
            }

            Repeater {
                model: layerData
                MapLayerButton {
                    Layout.fillWidth: true
                    dotColor:         modelData.color
                    mapName:          modelData.name
                    badgeState:       modelData.state
                }
            }

            // ── PARAMETERS ────────────────────────────────────────
            Rectangle {
                Layout.fillWidth: true
                height:           1
                color:            Theme.border
                Layout.topMargin: 4
            }

            SectionHeader {
                text:             "Parameters"
                Layout.fillWidth: true
            }

            Rectangle {
                Layout.fillWidth: true
                height:           1
                color:            Theme.border
            }

            Repeater {
                model: paramData
                ParameterRow {
                    Layout.fillWidth: true
                    label:            modelData.label
                    paramType:        modelData.type
                }
            }

            // ── HISTORY ───────────────────────────────────────────
            Rectangle {
                Layout.fillWidth: true
                height:           1
                color:            Theme.border
                Layout.topMargin: 4
            }

            SectionHeader {
                text:             "History"
                Layout.fillWidth: true
            }

            Rectangle {
                Layout.fillWidth: true
                height:           1
                color:            Theme.border
            }

            // Placeholder history entries
            Repeater {
                model: [
                    { name: "Generated Height map", time: "12:04" },
                    { name: "Changed seed",         time: "12:01" },
                    { name: "Opened project",       time: "11:58" },
                ]
                Item {
                    Layout.fillWidth: true
                    implicitHeight:   28

                    RowLayout {
                        anchors {
                            fill:        parent
                            leftMargin:  Theme.paddingMd
                            rightMargin: Theme.paddingMd
                        }
                        Text {
                            Layout.fillWidth: true
                            text:             modelData.name
                            color:            Theme.textSecondary
                            font.family:      Theme.fontLabel
                            font.pixelSize:   12
                            elide:            Text.ElideRight
                        }
                        Text {
                            text:           modelData.time
                            color:          Theme.textMuted
                            font.family:    Theme.fontMono
                            font.pixelSize: 11
                        }
                    }
                }
            }

            // Bottom spacer
            Item { Layout.fillHeight: true; implicitHeight: 8 }
        }
    }
}
