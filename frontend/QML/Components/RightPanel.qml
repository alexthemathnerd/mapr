import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QML.Themes 1.0

Rectangle {
    color: Theme.sidebar

    readonly property var genConfigParams: [
        { label: "Seed",       type: "Random" },
        { label: "Iterations", type: "Number" },
    ]

    readonly property var displayConfigParams: [
        { label: "Colour Map",  type: "Cmap"    },
        { label: "Contours",    type: "Boolean" },
        { label: "Grid Lines",  type: "Boolean" },
        { label: "Graticules",  type: "Boolean" },
    ]

    ScrollView {
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true

        ColumnLayout {
            width:   parent.width
            spacing: 0

            // ── ALGORITHM ─────────────────────────────────────────
            SectionHeader {
                text:             "Algorithm"
                Layout.fillWidth: true
                Layout.topMargin: 4
            }

            Rectangle {
                Layout.fillWidth: true
                height:           1
                color:            Theme.border
            }

            // Algorithm dropdown placeholder
            Rectangle {
                Layout.fillWidth:    true
                Layout.leftMargin:   Theme.paddingMd
                Layout.rightMargin:  Theme.paddingMd
                Layout.topMargin:    6
                Layout.bottomMargin: 4
                height:              30
                radius:              Theme.radiusSm
                color:               Theme.hover
                border.color:        Theme.border
                border.width:        1

                RowLayout {
                    anchors { fill: parent; leftMargin: 10; rightMargin: 10 }
                    Text {
                        Layout.fillWidth: true
                        text:             "Perlin Noise"
                        color:            Theme.textSecondary
                        font.family:      Theme.fontLabel
                        font.pixelSize:   12
                    }
                    Text {
                        text:           "▾"
                        color:          Theme.textMuted
                        font.pixelSize: 10
                    }
                }
            }

            // Algorithm description
            Text {
                Layout.fillWidth:    true
                Layout.leftMargin:   Theme.paddingMd
                Layout.rightMargin:  Theme.paddingMd
                Layout.bottomMargin: 6
                text:                "Generates coherent noise using gradient interpolation."
                color:               Theme.textMuted
                font.family:         Theme.fontLabel
                font.pixelSize:      11
                wrapMode:            Text.WordWrap
            }

            // ── GENERATION CONFIGURATION ──────────────────────────
            Rectangle {
                Layout.fillWidth: true
                height:           1
                color:            Theme.border
                Layout.topMargin: 4
            }

            SectionHeader {
                text:             "Generation Configuration"
                Layout.fillWidth: true
            }

            Rectangle {
                Layout.fillWidth: true
                height:           1
                color:            Theme.border
            }

            Repeater {
                model: genConfigParams
                ParameterRow {
                    Layout.fillWidth: true
                    label:            modelData.label
                    paramType:        modelData.type
                }
            }

            // ── DISPLAY CONFIGURATION ─────────────────────────────
            Rectangle {
                Layout.fillWidth: true
                height:           1
                color:            Theme.border
                Layout.topMargin: 4
            }

            SectionHeader {
                text:             "Display Configuration"
                Layout.fillWidth: true
            }

            Rectangle {
                Layout.fillWidth: true
                height:           1
                color:            Theme.border
            }

            Repeater {
                model: displayConfigParams
                ParameterRow {
                    Layout.fillWidth: true
                    label:            modelData.label
                    paramType:        modelData.type
                }
            }

            // Spacer
            Item { Layout.fillHeight: true; implicitHeight: 12 }

            // Generate button
            Rectangle {
                Layout.fillWidth:    true
                Layout.leftMargin:   Theme.paddingMd
                Layout.rightMargin:  Theme.paddingMd
                Layout.bottomMargin: Theme.paddingMd
                height:              36
                radius:              Theme.radiusSm
                color:               "#2DD4BF"

                Text {
                    anchors.centerIn: parent
                    text:             "Generate"
                    color:            "#0D1F1A"
                    font.family:      Theme.fontLabel
                    font.pixelSize:   13
                    font.weight:      Font.DemiBold
                    font.letterSpacing: 0.5
                }
            }
        }
    }
}
