import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

import "../../Styles" as S

FocusScope {
    id: direccion
    height: secTitle.height + secMore.height

    property bool showMore: false
    property string text: ""
    //property real infoHeight: info? ld.item.height : 150
    property real infoHeight: 180
    property Component info

    onFocusChanged: {
        showMore = focus
        if (focus) secMore.contentItem.focus = true
    }

    Seccion1 {
        id: secTitle
        height: 50
        width: parent.width

        Row {
            id: row1
            spacing: 10
            anchors.fill: parent
            anchors.margins: 10

            S.TextStyled {
                id: sectxt1
                height: parent.height
                text: direccion.text

                selectedColor: "#e0392e"
                color: "white"
                selected: direccion.focus
                style: Text.Normal
                font.pixelSize: 16

                horizontalAlignment: Text.AlignHCenter
            }

            Item {
                width: 20
                height: parent.height
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    source: "../../../assets/arrow-down-small-prelight.png"

                    rotation: direccion.showMore ? 180 : 0



                    Behavior on rotation { NumberAnimation {} }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: direccion.showMore = !direccion.showMore
                }
            }
        }
    }


    ScrollView {
        id: secMore
        height: direccion.showMore ? infoHeight : 0
        x: 0
        width: parent.width - 5
        anchors.top: secTitle.bottom

        flickableItem.interactive: true

        Seccion2 {
            anchors.fill: parent
        }

        clip: true

        Behavior on height {NumberAnimation {}}

        /*contentItem: Loader {
            id: ld
            anchors.fill: parent
            sourceComponent: info

            onHeightChanged: infoHeight = height
        }*/

        style: ScrollViewStyle {
            transientScrollBars: true
            incrementControl: null
            decrementControl: null
            handle: Rectangle {
                color: "#221e1c"
                x: 1
                implicitWidth: 6
                implicitHeight: 6
            }
            scrollBarBackground: Item {
                x: 1
                implicitWidth: 6
                implicitHeight: 6
            }//*/
        }

        contentItem: info.createObject(secMore)

    }
}
