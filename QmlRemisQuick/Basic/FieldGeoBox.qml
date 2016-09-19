import QtQuick 2.2
import QtLocation 5.2
import QtPositioning 5.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

import qmlremis.Style 1.0 as S
import com.kbu9999.FieldPanel 1.0

Field {
    id: geoSearch
    property string gpsRole
    property url mapIcon
    property url animLoading

    property ListModel gmodel:  ListModel {
    }


    signal searched()
    signal gpsSelected(string dir, string lat, string lon)

    editorDelegate: TextField {
        id: gsearch
        text: styleData.value?  styleData.value : ""
        property Field field: styleData.field
        property int status: 0

        style: TextFieldStyle { textColor: "black" }

        onStatusChanged: {
            switch(status) {
            case 1:
                loading.visible = true
                enabled = false
                break;
            case 2:
                loading.visible = false
                enabled = true
                popup.toggleShow()
                break;
            default:
                loading.visible = false
                enabled = true
                popup.clear()
                break;
            }
        }

        onTextChanged: {
            if (timer.running) timer.stop()
            timer.start()
        }

        Keys.onReturnPressed: timer.search()

        Keys.onEscapePressed: {
            timer.stop()
            loading.visible = false
        }

        Timer {
            id: timer; interval: 5000
            //onTriggered: search()
            onTriggered: gsearch.status = 0
            function search() {
                if (!geoSearch.editMode) return;

                gsearch.status = 1
                var tp = gsearch.text.replace(/ /, "+")
                var http = new XMLHttpRequest();
                http.onreadystatechange = function() {
                    if (http.readyState === XMLHttpRequest.DONE) {

                        if(xhr.status !== 200){  //check if "OK" (200)
                            console.log("error http request")
                            timer.stop()
                            gsearch.status = 0
                            return;
                        }

                        var a = JSON.parse(http.responseText);
                        var results = a.results;
                        gmodel.clear()
                        if (results.length === 1) {
                            //console.log("fgeo: es uno")
                            var p = results[0].geometry.location
                            geoSearch.gpsSelected(gsearch.text, p.lat, p.lng)
                            gsearch.status = 0
                            geoSearch.editMode = false
                            return;
                        }

                        gsearch.status = 2
                        for (var i in results) {
                            var r = results[i]
                            var pos = r.geometry.location
                            gmodel.append({ "address": r.formatted_address.replace(", Tucumán, Argentina", ""),
                                              "lat" :  pos.lat, "lon": pos.lng})
                        }
                        geoSearch.searched()
                    }
                }

                http.open("GET", "http://maps.googleapis.com/maps/api/geocode/json?address="+tp+",tucuman")
                //http.setRequestHeader("Content-Type", "application/json");
                //http.setRequestHeader("Accept", "application/json")
                http.send()
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
            //__visualItem: gsearch

            Instantiator {
                model: gmodel

                MenuItem {
                    text: address
                    onTriggered: {
                        gsearch.status = 0
                        geoSearch.editMode = false
                        geoSearch.gpsSelected(gsearch.text, lat, lon)
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
