import QtQuick 2.0
import QtQuick.Controls 1.1

Image {
    id: imgs

    property string icon: ""

    signal clicked()

    source: "../"+icon

    MouseArea {
        anchors.fill: parent;
        onClicked:  parent.clicked()
    }
}
