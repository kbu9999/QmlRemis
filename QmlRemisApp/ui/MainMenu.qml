import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles  1.1
import OrmQuick 1.0

import com.kbu9999.SimpleDBSec 1.0
import com.kbu9999.default 1.0

import Models 1.0

Rectangle {
    id: bar
    implicitWidth: 1000
    height: 50
    color: "#211d1b"

    property alias model: toolbar.model
    property int __selectIndex: -1

    function reset() {
        __selectIndex = 0
    }

    signal pluginLoad(string source)

    on__SelectIndexChanged: {
        if (__selectIndex < 0) return;

        var pl = model.get(__selectIndex)
        if (!pl) {
            pluginLoad("")
            return
        }

        pluginLoad("../plugins/"+pl.title+"/main.qml")
    }

    Rectangle {
        id: rectangle1
        y: 70
        height: 10
        color: "#1d1916"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right

        Rectangle {
            height: 1
            color: "#14100f"
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.leftMargin: 0
        }
    }

}
