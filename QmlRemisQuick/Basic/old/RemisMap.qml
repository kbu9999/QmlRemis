import QtQuick 2.0
import QtPositioning 5.3
import QtLocation 5.3
import QtQuick.Controls 1.1

Map {
    id: mapView
    property QtObject alquiler
    readonly property alias geoModel:  geoM
    property variant parada:  QtPositioning.coordinate()
    property variant origen:  alquiler? alquiler.origen_gps : QtPositioning.coordinate()
    property variant destino: alquiler? alquiler.destino_gps : QtPositioning.coordinate()
    property real distanceParOrig: 0
    property real distanceOrigDest: 0
    property real distanceDesPar: 0
    property int timeParOrig: 0
    property int timeOrigDest: 0
    property int timeDestPar: 0
    property real distanceTotal: distanceParOrig + distanceOrigDest + distanceDesPar
    property int timeTotal: timeParOrig + timeOrigDest + timeDestPar

    onOrigenChanged: _updateRutaPrincipal()
    onDestinoChanged: _updateRutaPrincipal()
    onParadaChanged: _updateRutaSecundarias()

    center: QtPositioning.coordinate(-26.841, -65.163)
    zoomLevel: 13

    plugin: Plugin  {
        id: osm
        name: "osm"
    }    

    MapItemView {
        id: dirs
        model: GeocodeModel {
            id: geoM
            plugin: osm
            autoUpdate: false

            property Item fieldSearch
            property url mapIcon
        }

        delegate: MapQuickItem {
            id: mqi
            anchorPoint.x: img.width/2
            anchorPoint.y: img.height/2
            coordinate: locationData.coordinate
            sourceItem:  Image {
                id: img
                source: geoM.mapIcon

                MouseArea {
                    anchors.fill: parent
                    drag.target: mqi

                    onPressed: mapView.gesture.enabled = false
                    onReleased: mapView.gesture.enabled = true;

                    onDoubleClicked: {
                        mapView.gesture.enabled = true
                        geoM.fieldSearch.gps = coordinate
                        //geoM.fieldSearch.hide()
                    }
                }
            }
        }
    }

    //items inicio fin
    MapQuickItem {
        id: mapOrig
        anchorPoint.x: imgO.width/2
        anchorPoint.y: imgO.height/2
        coordinate: mapView.origen
        sourceItem:  Image {
            id: imgO
            source: "icons:flag-blue.png"
        }
    }

    MapQuickItem {
        id: mapDest
        anchorPoint.x: imgD.width/2
        anchorPoint.y: imgD.height/2
        coordinate: mapView.destino
        sourceItem:  Image {
            id: imgD
            source: "icons:flag-red.png"
        }
    }

    //Rutas
    function _updateRutaPrincipal() {
        if (!origen.latitude || !destino.latitude) return;

        qrouteAlq.clearWaypoints()
        qrouteAlq.addWaypoint(origen)
        qrouteAlq.addWaypoint(destino)
        routeAlquiler.update()
    }

    function _updateRutaSecundarias() {
        if (origen.latitude && parada.latitude) {
            qrouteDesdePar.clearWaypoints()
            qrouteDesdePar.addWaypoint(parada)
            qrouteDesdePar.addWaypoint(origen)
            routeDesdePar.update()
        }

        if (destino.latitude && parada.latitude) {
            qrouteHastaPar.clearWaypoints()
            qrouteHastaPar.addWaypoint(destino)
            qrouteHastaPar.addWaypoint(parada)
            routeHastaPar.update()
        }
    }

    MapItemView {
        id: alqItems
        model: RouteModel {
            id: routeAlquiler
            plugin: mapView.plugin
            autoUpdate: false
            query: RouteQuery {
                id: qrouteAlq
                segmentDetail: RouteQuery.NoSegmentData
                maneuverDetail: RouteQuery.NoManeuvers
            }
        }
        delegate:  MapRoute {
            route: routeData
            line.color: "#02cffd"
            line.width: 4
            smooth: false
            opacity: 1
            visible: alquiler? true : false

            onRouteChanged: {
                mapView.distanceOrigDest = routeData.distance
                mapView.timeOrigDest = routeData.travelTime * 1.4
            }
        }
    }

    MapItemView {
        id: desdeItems
        model: RouteModel {
            id: routeDesdePar
            plugin: mapView.plugin
            autoUpdate: false
            query: RouteQuery {
                id: qrouteDesdePar
                segmentDetail: RouteQuery.NoSegmentData
                maneuverDetail: RouteQuery.NoManeuvers
            }
        }
        delegate:  MapRoute {
            route: routeData
            line.color: "#f506ed"
            line.width: 5
            smooth: true
            opacity: 1

            onRouteChanged: {
                mapView.distanceParOrig = routeData.distance
                mapView.timeParOrig = routeData.travelTime * 1.4
            }
        }
    }

    MapItemView {
        id: hastaItems
        model: RouteModel {
            id: routeHastaPar
            plugin: mapView.plugin
            autoUpdate: false
            query: RouteQuery {
                id: qrouteHastaPar
                segmentDetail: RouteQuery.NoSegmentData
                maneuverDetail: RouteQuery.NoManeuvers
            }
        }
        delegate:  MapRoute {
            route: routeData
            line.color: "#17b764"
            line.width: 5
            smooth: true
            opacity: 1

            onRouteChanged: {
                mapView.distanceDesPar = routeData.distance
                mapView.timeDestPar = routeData.travelTime * 1.4
            }
        }
    }
}
