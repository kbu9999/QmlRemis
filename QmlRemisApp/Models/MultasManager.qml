pragma Singleton
import QtQuick 2.2
import OrmQuick 1.0

import qmlremis.DB.Meta 1.0
import com.kbu9999.SimpleDBSec 1.0

Item {

    property alias model: multas

    OrmModel {
        id: multas
        metaTable: MetaMulta

        loader.query: "SELECT * FROM Multas WHERE fin > NOW()"
    }

    function addMovil(movil, mins) {
        var end = new Date()
        end.setMinutes(end.getMinutes() +  mins)

        var nm = MetaMulta.create(this);
        nm.movil = movil
        nm.inicio = new Date()
        nm.fin = end

        movil.estado = 3

        multas.append(nm)
        multas.commit()

        //addLog("ha multado con "+mins+"Min al Movil: "+movil.idMovil)
    }

    Timer {
        id: timer
        interval: 1000
        onTriggered: {
            var d = new Date()
            for (var i in multas.count) {
                var m = multas.at(i).movil;
                m.restante = m.endMulta - d
                if (d >= m.endMulta) {
                    //m.endMulta = undefined
                    m.estado = 2
                    m.finMulta()
                    multas.remove(m)
                }
            }
        }
    }
}

