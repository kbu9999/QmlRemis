import QtQuick 2.2

Rectangle {
    id: main
    color: "white"
    radius: 20

    readonly property  string filter: textInput1.text
    property alias source: image1.source
    property alias validator: textInput1.validator

    onFocusChanged: if (focus) textInput1.focus = true

    signal returnPressed()

    activeFocusOnTab: true

    function setFilterText(text) {
        textInput1.text = text
        filterChanged(text)
    }

    TextInput {
        id: textInput1
        anchors.rightMargin: 1
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: image1.left
        anchors.left: parent.left
        font.pixelSize: 13
        clip: true

        //Keys.onReturnPressed: main.filter = text
        Keys.onReturnPressed: main.returnPressed();
    }

    Image {
        id: image1
        width: 18
        height: 18
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right

        MouseArea {
            anchors.fill: parent

            onClicked: main.filter = textInput1.text
        }
    }
}
