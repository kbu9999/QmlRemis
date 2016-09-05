import QtQuick 2.0
import OrmQuick 1.0

import qmlremis.DB 1.0
import qmlremis.DB.Meta 1.0

OrmModel {
    id: model
    metaTable: MetaParada

    readonly property Parada parada: currentIndex < count? at(currentIndex) : null
    readonly property Movil movil: parada? (parada.moviles.length > 0? parada.moviles[0] : null) : null
    property int currentIndex: 0

    function next() {
        currentIndex++
        if (currentIndex > count - 1)
            currentIndex = 0;
    }

    function back() {
        currentIndex--;
        if (currentIndex < 0)
            currentIndex = count - 1;
    }

    Component.onCompleted: load()
}

