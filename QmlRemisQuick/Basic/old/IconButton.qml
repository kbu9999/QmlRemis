import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    width: 40
    height: 40

    property color color
    property color hoveredColor
    property url sourceIcon
    property alias hoverEnabled: ma.hoverEnabled

    signal clicked()

    Rectangle {
        id: rect
        anchors.fill: parent
        color: ma.containsMouse? parent.hoveredColor : parent.color
        visible: false
    }

    Image {
        id: icon
        source: parent.sourceIcon
        visible: false
    }

    OpacityMask {
        id: mask
        anchors.fill: parent
        source: rect
        maskSource: icon
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true

        onClicked: parent.clicked()
    }
}
