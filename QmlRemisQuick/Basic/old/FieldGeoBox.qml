import QtQuick 2.2
import QtLocation 5.2
import QtPositioning 5.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

import common.Style 1.0 as S
import common.MyQuick.FieldPanel 1.0

Field {
    id: geoSearch
    property GeocodeModel model
    property string gpsRole
    property url mapIcon
    property url animLoading

    editorDelegate: TextField {
        id: gsearch
        text: styleData.value?  styleData.value : ""
        property Field field: styleData.field
        property int status: field.model.fieldSearch === gsearch? field.model.status : 0

        function setGps(coord) {
            if (!styleData.object) return;
            styleData.object[field.gpsRole] = coord
        }

        style: TextFieldStyle { textColor: "black" }

        onStatusChanged: {
            switch(status) {
                case 2:
                    loading.visible = true
                    enabled = false
                    break;
                case 1:
                    loading.visible = false
                    enabled = true
                    field.model.mapIcon = field.mapIcon
                    popup.toggleShow()
                    break;
                default:
                    field.model.fieldSearch = null
                    loading.visible = false
                    enabled = true
                    popup.clear()
                    break;
            }
        }

        onTextChanged: {
            styleData.field.model.query = text+", Tucuman";
            if (timer.running) timer.stop()
            timer.start()
        }

        Keys.onEscapePressed: {
            timer.stop()
            loading.visible = false
        }

        Timer {
            id: timer; interval: 900
            onTriggered: {
                field.model.fieldSearch = gsearch
                field.model.update()
            }
        }

        AnimatedImage {
            id: loading
            width: parent.height - 6; height: width
            anchors.right: parent.right
            anchors.rightMargin: 3
            anchors.verticalCenter: parent.verticalCenter
            source: styleData.field.animLoading
            visible: false
        }

        Menu {
            id: popup
            property int y: gsearch.height
            __minimumWidth: gsearch.width - 2
            __visualItem: gsearch

            Instantiator {
                model: styleData.field.model

                MenuItem {
                    text: locationData.address.text
                    onTriggered: {
                        field.model.fieldSearch = null
                        gsearch.setGps(locationData.coordinate)
                    }
                }

                onObjectAdded: popup.insertItem(0, object)
                onObjectRemoved: popup.removeItem(object)
            }

            function toggleShow() {
                if (popup.__popupVisible) {
                    popup.__dismissMenu()
                    popup.__destroyAllMenuPopups()
                } else {
                    if (Qt.application.layoutDirection === Qt.RightToLeft)
                        __popup(Qt.rect(gsearch.width, y, 0, 0), 0)
                    else
                        __popup(Qt.rect(0, y, 0, 0), 0)
                }
            }
        }
    }

}
