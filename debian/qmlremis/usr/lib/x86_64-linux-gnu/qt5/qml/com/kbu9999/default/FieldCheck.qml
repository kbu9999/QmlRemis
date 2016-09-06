import QtQuick 2.0
import QtQuick.Controls 1.1

Item {
    id: main
    property string text: ""
    property bool value: false
    property string icon: ""

    width: 120
    height: 22

    Text {
        id: tag
        width: 100
        font.bold: true
        text: main.text
        anchors.verticalCenter: parent.verticalCenter
    }

    Item {
        id: zone
        width: clId.visible ? clId.width : clField.width
        height: 30
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: tag.right
        anchors.leftMargin: 3

        Text {
            id: clId;
            text: main.value ? "Si" : "No"
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
        }

        CheckBox {
            id: clField
            anchors.verticalCenter: parent.verticalCenter
            visible: !clId.visible
            checked: main.value

            onCheckedChanged: main.value = checked
        }
    }

    Image {
        id: imgs
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 3
        anchors.left: zone.right
        source: icon

        MouseArea {
            anchors.fill: parent;
            onClicked: {
                clId.visible = !clId.visible
            }
        }
    }
}
