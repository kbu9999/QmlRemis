import QtQuick 2.0
import QtQuick.Controls.Styles 1.1

ButtonStyle {
    label: Item {
        implicitHeight: 24
        implicitWidth: 24
        Image { anchors.fill: parent; source: control.iconSource }
    }
    background: Rectangle {
        color: control.hovered? "#009dff" : "#bfbfbf"
        border.color: "#5c5c5c"
        border.width: 1
    }
}
