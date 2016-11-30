import QtQuick 2.0
import QtQuick.Controls 2.0

Button {
    id: control
    background: Rectangle {
        color: control.enabled? control.color : "#bfbfbf"
        border.color: "#5c5c5c"
        border.width: 1
        //width: control.width; height: control.height
        anchors.fill: parent
    }

    contentItem : TextStyled {
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        //width: control.width; height: control.height
        text: control.text
        color: "white"
        font.bold: true
        font.pointSize: 10
        style: Text.Normal
    }
}

