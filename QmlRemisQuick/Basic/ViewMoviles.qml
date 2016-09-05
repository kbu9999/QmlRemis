import QtQuick 2.2
import QtQuick.Controls 1.2
import OrmQuick 1.0

import qmlremis.DB 1.0
import qmlremis.DB.Meta 1.0

GridView {
    id: tbView
    anchors.margins: 10

    property var colors: ["grey", "#eca817", "red", "black", "purple"]
    property bool enableDrag: false
    property alias role: movilModel.filterProperty
    property string filter

    function commint(){ rmodel.commit() }
    function addMovil(){ rmodel.insertRows(rmodel.count - 1, 1) }

    OrmFilterModel {
        id: movilModel

        filterRegExp: new RegExp(tbView.filter)
        sourceModel: OrmModel {
            id: rmodel
            metaTable: MetaMovil
            loader.loadForeignKeys: true
        }

        Component.onCompleted: sourceModel.load()
    }

    model: movilModel

    cellHeight: 50
    cellWidth: 50
    delegate: Rectangle {
        id: rect2
        x: 5; y: 5
        width: 40
        height: 40
        color: tbView.colors[estado]
        clip: true

        //Drag.keys: [ parada ]
        Drag.active: ma.drag.active

        Text {
            anchors.fill: parent

            text: idMovil
            color: "white"
            font.pointSize: 20
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: "BellGothic BT"
        }

        MouseArea {
            id: ma
            anchors.fill: parent
            onClicked:  tbView.movilChanged(movilModel.at(index));
            onDoubleClicked: tbView.doubleClicked(movilModel.at(index));

            drag.target: tbView.enableDrag? parent : null

            property int _x: 0
            property int _y: 0
            onPressed: {
                _x = rect2.x
                _y = rect2.y
            }

            onReleased: {
                var t = rect2.Drag.target
                //console.log(t)
                if (t) {
                    var m = movilModel.at(index)
                    m.setParada(t.parada)
                }

                rect2.x = _x; rect2.y = _y
            }
        }

        states: State {
            when: ma.drag.active
            PropertyChanges { target: rect2; opacity: 0.7 }
        }
    }

    signal movilChanged(Movil movil)
    signal doubleClicked(Movil movil)
}
