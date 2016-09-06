import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1


Field {
    property string fkrole: ""
    property var model
    property Component style

    showDelegate: Text {
        text: styleData.value? styleData.value[styleData.field.fkrole] : ""
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        opacity: styleData.isCurrenIndex? 0.6 : 1.0
    }

    editorDelegate: ComboBox {
        model: styleData.field.model
        textRole: styleData.field.fkrole
        editText: styleData.value? styleData.value[textRole] : ""
        editable: true
        onAccepted: {
            var i = find(currentText);
            if (i < 0) return;

            //currentIndexChanged(i)
            var fk = model[currentIndex]
            if (!fk) fk = model.at(currentIndex)
            if (!fk) return

            setValue(fk)
            hideEditor()
        }
        /*onCurrentIndexChanged: {
            if (!model) return
            var fk = model[currentIndex]
            if (!fk) return

            setValue(fk)
            hideEditor()
        } //*/
        Keys.onEscapePressed: hideEditor()

        Component.onCompleted: {
            if (styleData.field.style)
                style = styleData.field.style
        }
    }
}
