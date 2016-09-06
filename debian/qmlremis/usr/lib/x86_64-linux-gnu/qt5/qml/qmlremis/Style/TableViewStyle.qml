
import QtQuick 2.0
import QtQuick.Controls.Styles 1.1


TableViewStyle {
    frame: null
    decrementControl: null
    incrementControl: null

    handle: Rectangle {
        color: "#1c1815"
        implicitWidth: 14
        implicitHeight: 14
    }

    /*scrollBarBackground: Rectangle {
        color: "#1c1815"
        width: styleData.horizontal ? control.width : 14
        height: styleData.horizontal ? 14 : control.height
    } //*/

    headerDelegate: Rectangle {
        color: "white"
        implicitHeight: 40
        //width: 40

        Rectangle {
            width: parent.width
            height: 1
            color: "#d9d9d9"
        }

        TextStyled {
            anchors.fill: parent
            anchors.leftMargin: 20

            text: styleData.value
            color: "black"
        }

        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: "#d9d9d9"
        }
    }

    rowDelegate: Rectangle {
        color: styleData.selected? "#dd4814" : "white"
        height: 50
        clip: true

        Rectangle {
            visible: styleData.row !== undefined
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: "#d9d9d9"
        }
    }

    itemDelegate: TextStyled {
        text: styleData.value? styleData.value : ""
        //wrapMode: Text.Wrap
        elide: Text.ElideRight

        anchors.fill: parent
        anchors.leftMargin: 10

        selected: styleData.selected
    }
}
