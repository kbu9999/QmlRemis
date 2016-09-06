import QtQuick 2.0
import QtQuick.Controls 1.1

Item {
    id: main
    property alias text: tit.text
    property alias value: clField.text
    property alias icon: iconb.source

    signal editingFinished(string text);

    width: 120
    height: 30

    Row {
        id: row
        anchors.fill: parent
        spacing: 2

        Text {
            id: tit
            width: 100
            font.bold: true
            text: main.text
            anchors.verticalCenter: parent.verticalCenter
        }

        Item {
            width: 100;
            height: 30
            anchors.verticalCenter: parent.verticalCenter

            Text {
                id: clId;
                text: clField.text
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                anchors.fill: parent
            }

            TextField {
                id: clField
                visible: !clId.visible
                anchors.fill: parent

                Keys.onEscapePressed: clId.visible = true
                onEditingFinished:  {
                    text: main.value
                    main.editingFinished(text)
                    clId.visible = true
                }
            }
        }

        Image {
            id: iconb
            anchors.verticalCenter: parent.verticalCenter

            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    clId.visible = !clId.visible
                    if (!clId.visible) clField.selectAll()
                }
            }
        }
    }
}
