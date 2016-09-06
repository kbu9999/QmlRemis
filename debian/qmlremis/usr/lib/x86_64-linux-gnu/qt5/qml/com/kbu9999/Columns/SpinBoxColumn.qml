import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

EditingColumn {
    id: tvcp
    
    signal valueChanged(int row,real value)
    
    property int decimals: 2
    property string prefix

    editor: SpinBox {
        value: styleData? styleData.value : 0
        decimals: tvcp.decimals
        prefix: tvcp.prefix
        maximumValue: 999999
        minimumValue: -99999
        Keys.onReturnPressed: {
            tvcp.valueChanged(styleData.row, value)
            showText = prefix+value.toFixed(decimals)
            hideEditor()
        }
        Keys.onEscapePressed: hideEditor()
        Component.onCompleted: showText = prefix+value.toFixed(decimals)

        style: SpinBoxStyle { textColor: "black" }
    }
}
