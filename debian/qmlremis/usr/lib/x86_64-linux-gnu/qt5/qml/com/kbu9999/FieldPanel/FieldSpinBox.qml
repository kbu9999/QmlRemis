import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1


Field {
    property int decimals: 0
    property string prefix: ""
    property Component style

    showDelegate: Text {
        property int __d: styleData.field.decimals
        property string __p: styleData.field.prefix
        text: styleData.value? __p+styleData.value.toFixed(__d) : __p+"0,00"
        opacity: styleData.isCurrenIndex? 0.6 : 1.0
    }

    editorDelegate: SpinBox {
        decimals: styleData.field.decimals
        prefix: styleData.field.prefix
        value: styleData.value? styleData.value : 0
        onEditingFinished: {
            setValue(value)
            hideEditor()
        }
        Keys.onEscapePressed: {
            value = parseFloat(styleData.item.text)
            hideEditor()
        }

        Component.onCompleted: {
            if (styleData.field.style)
                style = styleData.field.style
        }
    }
}
