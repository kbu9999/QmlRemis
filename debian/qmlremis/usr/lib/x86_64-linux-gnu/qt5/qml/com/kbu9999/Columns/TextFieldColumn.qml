import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

EditingColumn {
    id: tvcp
    property string inputMask
    
    property string textRole: ""
    
    signal textChanged(int row, string text)
    
    editor: TextField {
        text: styleData? (tvcp.textRole.length > 0?
                  styleData.value[tvcp.textRole] : styleData.value) : ""
        inputMask: tvcp.inputMask
        Keys.onReturnPressed: {
            if (tvcp.textRole.length >= 0)
                styleData.value[tvcp.textRole] = text;

            tvcp.textChanged(styleData.row, text)
            showText = text.length > 0? text : defaultText
            hideEditor();
        }
        Keys.onEscapePressed: hideEditor()

        style: TextFieldStyle { textColor: "black" }
        //Component.onCompleted: { showText = text; }

        onTextChanged: showText = text
    }
}
