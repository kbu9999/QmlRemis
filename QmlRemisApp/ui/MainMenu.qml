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
    height: 60
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

    ListView {
        id: toolbar
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.right: row.left
        anchors.left: parent.left
        //clip: true
        orientation: ListView.Horizontal
        spacing: 10

        currentIndex: bar.__selectIndex

        delegate: Item {
            id: item1
            implicitHeight: bar.height
            implicitWidth: 70
            width: txt.width + 20

            Rectangle {
                color: "#dd4814"
                anchors.bottom: parent.bottom
                visible: toolbar.currentIndex == index
                height: 4
                width: parent.width
            }

            Text {
                id: txt
                text: title
                //anchors.fill: parent
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                //anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                color: "white"
                font.pointSize: 11
                font.bold: true
                font.family: "BellGothic BT"
                horizontalAlignment: Text.AlignHCenter
            }

            MouseArea {
                anchors.fill: parent
                onClicked: bar.__selectIndex = index
            }
        }
    }

    Row {
        id: row
        x: 900
        y: 14
        anchors.verticalCenterOffset: -2
        anchors.verticalCenter: parent.verticalCenter
        spacing: 5
        layoutDirection: Qt.RightToLeft
        anchors.right: parent.right
        anchors.rightMargin: 10

        IconButton {
            width: 40; height: 40
            color: "white"
            hoveredColor: "#e0392e"
            source: "../assets/icons/system-shutdown.png"

            onClicked: loginManager.logout()
        }

        IconButton {
            width: 40; height: 40
            color: db.connected? "#37b44b" : "#e0392e"
            hoverEnabled: false
            source: "../assets/icons/network-wireless.png"
        }

        IconButton {
            width: 40; height: 40
            color: config.visible? "#37b44b" : "#e0392e"
            hoveredColor: "white"
            source: "../assets/icons/configure.png"

            onClicked:  config.visible = !config.visible
        }

        IconButton {
            width: 40; height: 40
            color: window.state === "map_centro"? "#37b44b" : "#e0392e"
            hoveredColor: "white"
            source: "../assets/icons/web-browser-tree.png"
            property string oldState: ""

            onClicked: {
                window.state =  window.state === "map_centro"? "" : "map_centro"
            }
        }
    }    
}
