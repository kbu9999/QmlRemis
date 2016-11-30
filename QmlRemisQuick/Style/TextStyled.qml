import QtQuick 2.0
import QtQuick.Controls 2.0

Label {
    property bool selected: false
    property color selectedColor: "white"

    verticalAlignment: Text.AlignVCenter
    elide: Text.ElideRight
    //wrapMode: Text.Wrap

    font.pointSize: 9
    font.family: "BellGothic BT"

    color: selected? selectedColor : "#232323"
    style: selected? Text.Normal : Text.Raised
    styleColor: "white"
}
