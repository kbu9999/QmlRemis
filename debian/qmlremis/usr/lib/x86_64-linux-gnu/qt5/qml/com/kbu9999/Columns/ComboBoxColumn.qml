import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

EditingColumn {
    id: tvcp
    property string textRole
    property string comboRole
    property var comboModel

    editor: ComboBox {
        model: tvcp.comboModel
        textRole: tvcp.comboRole
        currentIndex: -1
        Component.onCompleted: {
            showText = styleData.value[tvcp.comboRole]?
                        styleData.value[tvcp.comboRole][tvcp.textRole]:
                        ""
        }
        onCurrentIndexChanged: terminar()
        Keys.onReturnPressed:  terminar()
        Keys.onEscapePressed: hideEditor();
        onFocusChanged: if (!focus) terminar()

        function terminar() {
            var o = comboModel.at(currentIndex)
            styleData.value[tvcp.comboRole] = o
            showText = o[textRole]
            hideEditor()
        }
    }
}
