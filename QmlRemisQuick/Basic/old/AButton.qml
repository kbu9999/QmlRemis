import QtQuick 2.0

FocusScope {
    id: main

    width: 100
    height: 30

    property string text: ""
    property color color

    signal clicked()


    Rectangle {
        id: rect1
        anchors.fill: main

        color: main.color
        radius: 2

        MouseArea {
            anchors.fill: parent
            onClicked: {
                main.clicked()
            }
            hoverEnabled: true

            //onHoveredChanged: main.focus = true
        }

        Text {
            text: main.text

            color: main.focus ? "red" : "white"
            anchors.fill: parent
            font.pointSize: 11
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            font.family: "BellGothic BT"
            font.bold: true
        }


    }
}
