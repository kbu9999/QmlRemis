import QtQuick 2.0
import QtQuick.Controls 1.3

TableViewColumn {
    property string fkrole: ""
    delegate: Label {
        text: styleData.value? (styleData.value[fkrole]? styleData.value[fkrole] : "" ) : ""

        anchors.fill: parent
        //anchors.leftMargin: 10

        //selected: styleData.selected
        horizontalAlignment: styleData.textAlignment
        verticalAlignment: Qt.AlignVCenter
    }
}

