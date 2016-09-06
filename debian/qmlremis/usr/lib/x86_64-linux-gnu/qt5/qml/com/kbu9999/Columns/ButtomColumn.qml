import QtQuick 2.0

import QtQuick.Controls 1.3

TableViewColumn {
    id: btn
    width: 24

    property url source

    signal clicked(int row);

    delegate: Image {
        fillMode: Image.PreserveAspectFit
        source: btn.source
        opacity: ma1.containsMouse? 1 : 0.5
        anchors.verticalCenter: btn.verticalCenter
        MouseArea {
            id: ma1
            anchors.fill: parent
            hoverEnabled: true
            onClicked: btn.clicked(styleData.row)
        }
    }
}

