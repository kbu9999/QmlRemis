import QtQuick 2.0
import QtQuick.Controls.Styles 1.1

ButtonStyle {
    background: Rectangle {
        color: control.enabled? control.color : "#bfbfbf"
        border.color: "#5c5c5c"
        border.width: 1
        //width: control.width; height: control.height
        anchors.fill: parent
    }

    label: TextStyled {
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
