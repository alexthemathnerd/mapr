pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import Components 1.0

Item {
    id: root

    property var mockParameters: []

    implicitHeight: paramLayout.implicitHeight

    ColumnLayout {
        id: paramLayout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        spacing: 0

        Repeater {
            model: root.mockParameters

            Loader {
                id: paramLoader
                required property var modelData
                Layout.fillWidth: true

                sourceComponent: {
                    switch (paramLoader.modelData.type) {
                    case "number":
                        return numberComp;
                    case "boolean":
                        return boolComp;
                    case "season":
                        return seasonComp;
                    case "enum":
                        return enumComp;
                    case "cmap":
                        return cmapComp;
                    case "random":
                        return randomComp;
                    default:
                        return null;
                    }
                }

                onLoaded: {
                    const data = paramLoader.modelData;
                    // qmllint disable missing-property
                    item["label"] = data.label;

                    if (data.value !== undefined)
                        item["value"] = data.value;
                    if (data.defaultValue !== undefined)
                        item["defaultValue"] = data.defaultValue;
                    if (data.min !== undefined && typeof item["min"] !== "undefined")
                        item["min"] = data.min;
                    if (data.max !== undefined && typeof item["max"] !== "undefined")
                        item["max"] = data.max;
                    if (data.step !== undefined && typeof item["step"] !== "undefined")
                        item["step"] = data.step;
                    if (data.options !== undefined && typeof item["options"] !== "undefined")
                        item["options"] = data.options;
                    // qmllint enable missing-property
                }
            }
        }
    }

    Component {
        id: numberComp
        ParameterNumber {}
    }
    Component {
        id: boolComp
        ParameterBoolean {}
    }
    Component {
        id: seasonComp
        ParameterSeason {}
    }
    Component {
        id: enumComp
        ParameterEnum {}
    }
    Component {
        id: cmapComp
        ParameterCmap {}
    }
    Component {
        id: randomComp
        ParameterRandom {}
    }
}
