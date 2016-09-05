import QtQuick 2.2
import QtQuick.Controls 1.1

//import common.Style 1.0 as S
import "../Style" as S

FocusScope{
    id: main
    property var value: ""
    property string icon: ""
    property bool isPass: false

    signal editingFinished(var value)

    width: 120
    height: 30
    activeFocusOnTab: true
    onFocusChanged: if (!focus) clId.visible = true

    Keys.onPressed: {
        switch(event.key) {
        case Qt.Key_Tab:
        case Qt.Key_Down:
        case Qt.Key_Backtab:
        case Qt.Key_Left:
        case Qt.Key_Right:
        case Qt.Key_Up: return;
        case Qt.Key_Return: if (KeyNavigation.tab) { focus: false; KeyNavigation.tab.focus = true }; return;
        }

        clId.visible = false
        clField.focus = true
        clField.selectAll()
        event.accepted = true
    }

    Item {
        height: 30
        anchors.rightMargin: 1
        anchors.right: img.left
        anchors.left: parent.left
        anchors.leftMargin: 0

        S.TextStyled {
            id: clId;
            text: main.isPass? "***********" : main.value
            horizontalAlignment: Text.AlignLeft
            anchors.fill: parent
        }

        TextField {
            id: clField
            text: main.value
            visible: !clId.visible
            enabled: visible
            anchors.fill: parent
            echoMode: main.isPass? TextInput.Password : TextInput.Normal

            Keys.onReturnPressed: {
                focus = false
                clId.visible = true
                main.editingFinished(text)
            }

            Keys.onEscapePressed: clId.visible = true
            font.family: "BellGothic BT"
        }
    }

    Image {
        id: img
        width: 16; height: 16
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        source: icon
        visible: clId.visible

        opacity: main.focus ? 0.6 : 1

        MouseArea {
            anchors.fill: parent;
            onClicked: {
                clId.visible = !clId.visible

                if (!clId.visible) clField.selectAll()
            }
        }
    }
}
