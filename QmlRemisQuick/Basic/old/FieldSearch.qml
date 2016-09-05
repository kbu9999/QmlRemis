import QtQuick 2.0
import QtLocation 5.2
import QtPositioning 5.2
import QtQuick.Controls 1.1

import "../Style" as S
import "../.."

FocusScope {
    id: geosearch1
    width: 210
    height: field.height + details.height

    property alias text: field.text
    property GeocodeModel geoModel
    property variant gps: QtPositioning.coordinate(0, 0)
    property string query: ""
    property url mapIcon
    property int status: geoModel && geoModel.fieldSearch === this ? geoModel.status : 0

    QtObject {
        id: priv
        property bool located: false

        function showLoading() {
            details.height = 100
            menu.visible = false
        }
        function showList() {
            details.height = geoModel.count * 40 + 10
            menu.visible = true
        }
        function select() {
            if (menu.currentIndex < 0 ||  menu.currentIndex >= geoModel.count) return;

            var l = geoModel.get(menu.currentIndex)
            geosearch1.gps = l.locationData.coordinate
            located = true
            hide()
        }
    }

    function hide() {
        details.height = 0
        geoModel.reset()
    }

    onFocusChanged:  {
        if (focus) {
            if (geoModel.count > 0 && geoModel.fieldSearch === geosearch1)
                priv.showList()
        }
        else {
            hide()
        }
    }

    onGpsChanged: {
        if (gps.latitude)
            priv.located = true
    }

    onStatusChanged: {
        switch(status) {
            case 2: priv.showLoading(); break;
            case 1: priv.showList(); break;
            default: hide(); break;
        }
    }

    Keys.onDownPressed: {
        if (menu.currentIndex < showModel.count)
            menu.currentIndex++
        else menu.currentIndex = 0
    }

    Keys.onUpPressed: {
        if (menu.currentIndex >= 0)
            menu.currentIndex--
        else menu.currentIndex = showModel.count - 1
    }

    Keys.onReturnPressed: priv.select()
    Keys.onEscapePressed: hide();
    Keys.onBacktabPressed: hide();

    Row {
        id: row1
        width: parent.width
        height: 30
        spacing: 1
        anchors.margins: 5

        TextField {
            id: field
            width: parent.width - gps.width - 10
            font.family: "BellGothic BT"
            focus: geosearch1.focus

            Keys.onEscapePressed: focus = false
            Keys.onReturnPressed: {
                var tx = text.replace("S/N,", "")
                if (tx.length <= 0) return;

                var find = tx+", Tucuman, Argentina";
                if (geoModel.query === find) return;

                priv.located = false
                geoModel.fieldSearch = geosearch1
                geoModel.query = find
                geoModel.update()
            }
        }

        Image {
            id: gps
            width: 20; height: 20
            anchors.verticalCenter: field.verticalCenter
            source: priv.located? "icons:/object-locked.png" :
                              "icons:/object-unlocked.png"
        }

    }

    Item {
        id: details
        width: parent.width
        height: 0
        anchors.top: row1.bottom
        anchors.margins: 5
        clip: true

        ListView {
            id: menu
            anchors.fill: parent
            anchors.rightMargin: 10
            //model: geosearch1.showModel
            model: geosearch1.geoModel

            highlight: Rectangle {
                color: "#dd4814"
                radius: 5
            }

            delegate: Item {
                width: menu.width
                height: 40
                anchors.margins: 10

                S.TextStyled {
                    id: txt2
                    anchors.fill: parent
                    anchors.margins: 10
                    text: locationData.address.text
                    font.italic: true

                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    maximumLineCount: 2

                    color: "#212121"
                    styleColor: "grey"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (menu.currentIndex == index) priv.select()
                        else menu.currentIndex = index
                    }
                }
            }
        }

        Item {
            anchors.fill: parent
            visible: !menu.visible
            AnimatedImage {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                source: "assets:/loading.gif"
            }
        }

        Behavior on height { NumberAnimation { duration: 100 } }
    }

}
