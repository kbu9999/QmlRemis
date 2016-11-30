import QtQuick 2.0
import QtQuick.Controls 2.0

Button {
    id: control
    property url iconSource
    hoverEnabled: true

    contentItem: Item {
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
