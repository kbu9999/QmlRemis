import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1

Field {
    property string dateFormat: "dd/MM/yyyy"
    property string inputMask: "99/99/9999"
    property Component style

    showDelegate: Text {
        text: styleData.value.toLocaleString(Qt.locale(), styleData.field.dateFormat)
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        opacity: styleData.isCurrenIndex? 0.6 : 1.0
    }

    editorDelegate: TextField {
        //z: 10
        id: edit
        text: styleData.value.toLocaleString(Qt.locale(), styleData.field.dateFormat);
        inputMask: styleData.field.inputMask
        onEditingFinished: {
            var d = Date.fromLocaleString(Qt.locale(), text, styleData.field.dateFormat);
            cal.selectedDate = d
        }
        Keys.onEscapePressed: hideEditor()

        Calendar {
            id: cal
            anchors.top: parent.bottom
            anchors.left: parent.left
            weekNumbersVisible: false
            visible: true

            onSelectedDateChanged: {
                setValue(selectedDate)
                hideEditor()
            }
        }

        Component.onCompleted: {
            if (styleData.field.style)
                style = styleData.field.style
        }
    }
}


