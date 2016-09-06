import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Field {
    property Component style
    property int echoMode: TextInput.Normal
    editorDelegate: TextField {
        text: styleData.value? styleData.value : ""
        echoMode: styleData.field.echoMode
        onEditingFinished: {
            setValue(text)
            hideEditor()
        }
        Keys.onEscapePressed: {
            text = styleData.item.text
            hideEditor()
        }

        onFocusChanged: if (!focus) hideEditor()

        Component.onCompleted: {
            if (styleData.field.style)
                style = styleData.field.style
        }
    }
}
