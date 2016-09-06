import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1

Field {
    property string fkrole: ""
    showDelegate: Text {
        text: styleData.value? styleData.value[styleData.field.fkrole] : ""
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
        //anchors.fill: parent
        opacity: parent.focus? 0.6 : 1.0
    }
}
