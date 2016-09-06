import QtQuick 2.4
import QtGraphicalEffects 1.0

Item {
    id: item

    property alias source: mask.source
    property color color
    property color hoveredColor
    property alias hoverEnabled: ma.hoverEnabled

    signal clicked();

    Rectangle {
        id: btt1
        anchors.fill: parent
        visible: false
        color: ma.containsMouse? item.hoveredColor : item.color

        Behavior on color { ColorAnimation { duration: 150 } }
    }

    Image {
        id: mask
        anchors.fill: parent
        visible: false
    }

    OpacityMask {
        anchors.fill: parent
        source: btt1
        maskSource: mask
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true

        onClicked: item.clicked();
    }
}
