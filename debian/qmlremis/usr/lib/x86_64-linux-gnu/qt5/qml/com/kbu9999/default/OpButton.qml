import QtQuick 2.0

Item {
    id: item1
    width: 150
    height: 30

    property string text: ""

    signal clicked()

    Rectangle {
        id: rectangle1
        //color: "black"
        color: "#27ae60"
        border.width: 1
        anchors.fill: parent
        opacity: 0.45

        radius: 4
    }

    Text {
        id: text1
        color: "white"
        text: item1.text
        font.bold: true
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 13
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            text1.color = "#f67400"
            rectangle1.opacity = 0.20
        }
        onExited: {
            text1.color = "white"
            rectangle1.opacity = 0.45
        }

        onClicked: item1.clicked()
    }
}
