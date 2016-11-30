import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1

import com.kbu9999.SimpleDBSec 1.0
import com.kbu9999.default 1.0

MenuView {
    id: toolbar
    height: 50
    property int currentIndex: -1

    background: Rectangle {
        color: "#211d1b"

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

    delegate: Item {
        id: item1
        implicitHeight: toolbar.height
        implicitWidth: 70
        width: txt.width + 10

        Rectangle {
            color: "#dd4814"
            anchors.bottom: parent.bottom
            visible: toolbar.currentIndex == index
            height: 4
            width: parent.width
        }

        Text {
            id: txt
            text: modelData.text
            //anchors.fill: parent
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            //anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            font.pointSize: 10
            font.bold: true
            font.family: "BellGothic BT"
            horizontalAlignment: Text.AlignHCenter
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                //window.source = "./plugins/"+folder+"/"+modelData.file
                modelData.triggered()
                toolbar.currentIndex = index
            }
        }
    }


    Item {
        Layout.fillWidth: true
    }

    Text {
        color: "#ffffff"
        text: user? user.nombre : "User"
        Layout.minimumWidth: 50
        font.bold: true
        font.italic: true
        //verticalAlignment: Text.AlignVCenter
        font.pixelSize: 15
    }

    IconButton {
        width: 32; height: 32
        color: window && window.state === "map_centro"? "#37b44b" : "#e0392e"
        hoveredColor: "white"
        source: "../assets/icons/web-browser-tree.png"

        property string  __oldstate
        property int setstate: 0
        property var __wstates: ["map_centro", "map_plug"]

        onClicked: {
            if (window.state !== __wstates[setstate]) {
                __oldstate = window.state
                window.state = __wstates[setstate]
            }
            else {
                window.state = __oldstate
                __oldstate = ""
            }
        }
    }

    IconButton {
        width: 32; height: 32
        color: db.connected? "#37b44b" : "#e0392e"
        hoverEnabled: false
        source: "../assets/icons/network-wireless.png"
    }

    IconButton {
        width: 32; height: 32
        color: showConfig? "#37b44b" : "#e0392e"
        hoveredColor: "white"
        source: "../assets/icons/configure.png"

        onClicked:  showConfig = !showConfig
    }

    IconButton {
        width: 32; height: 32
        hoveredColor: "white"
        color: "#e0392e"
        source: "../assets/icons/system-shutdown.png"

        onClicked: logout()
    }

}
