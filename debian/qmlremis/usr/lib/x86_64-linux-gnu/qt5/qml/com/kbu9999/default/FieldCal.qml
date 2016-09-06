import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

Item {
    property alias fecha: cal.selectedDate
    property alias icon: img.source

    width: edit.width + img.width
    height: 30
    z: 2

    TextField {
        id: edit
        text: cal.selectedDate.toLocaleString(Qt.locale(), "dd/MM/yyyy");
        inputMask: "99/99/9999"
        onEditingFinished: cal.selectedDate = Date.fromLocaleString(Qt.locale(), text, "dd/MM/yyyy");
        Keys.onEscapePressed: cal.visible = false
        style: TextFieldStyle {
            textColor: "black"
        }
    }
    Image {
        id: img
        anchors.right: parent.right
        anchors.verticalCenter: edit.verticalCenter
        width: 18; height: 18
        MouseArea {
            anchors.fill: parent
            onClicked: cal.visible = !cal.visible
        }
    }

    Calendar {
        id: cal
        anchors.top: edit.bottom
        anchors.left: edit.left
        weekNumbersVisible: false
        visible: false

        onClicked: visible = false
    }
}
