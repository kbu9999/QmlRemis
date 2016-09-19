pragma Singleton
import QtQuick 2.0
import OrmQuick 1.0

import qmlremis.DB 1.0
import qmlremis.DB.Meta 1.0
//import QmlRemis 1.0
import org.nemomobile.dbus 2.0

Item {
    id: mh

    OrmModel {
        id: ldAtendidos
        metaTable: MetaAlquiler
        loader.loadForeignKeys: true
        loader.query: "SELECT * FROM Alquiler ORDER BY fechaAtencion desc LIMIT 10"
    }

    OrmModel {
        id: ldEspera
        metaTable: MetaAlquiler
        loader.loadForeignKeys: true
        loader.query: "SELECT * FROM VEspera"
    }

    Component.onCompleted: {
        ldEspera.load()
        ldAtendidos.load()
    }

    OrmLoader {
        id: ldCall
        table: MetaLlamadas
    }

    OrmLoader {
        id: ldCls
        table: MetaCliente
        query: "SELECT * FROM Cliente WHERE telefono = :telefono LIMIT 1"

        function find(from) {
            addBindValue(":telefono", from);
            var cl = ldCls.load()
            if (cl.length <= 0) {
                var ncl = MetaCliente.create(pr.llamada)
                ncl.telefono = from
                return ncl;
            }
            else
                return cl[0]
        }
    }

    QtObject {
        id: pr
        property Cliente cliente: Cliente {
        }

        property Llamadas llamada
        property Alquiler alquiler
        property string callid
    }

    readonly property alias atendidos: ldAtendidos
    property alias queue: ldEspera

    readonly property alias cliente: pr.cliente
    readonly property alias llamada: pr.llamada
    readonly property alias alquiler: pr.alquiler

    function contestar() {
        //console.log("accept")
        callManager.accept()

        pr.llamada.contestar()
        pr.alquiler = MetaAlquiler.create(mh)
        pr.alquiler.llamadas = pr.llamada
        pr.alquiler.cliente = pr.cliente
        //pr.alquiler.fecha = new Date()
        pr.alquiler.origen = pr.cliente.direccion
        pr.alquiler.origen_gps = pr.cliente.gps
    }

    function colgar() {
        //console.log("hungup")
        if (!pr.llamada) return
        callManager.hangUp()
    }

    function pushCurrentAlquiler() {
        if (!pr.alquiler) return;

        pr.alquiler.fecha = new Date()
        ldEspera.append(pr.alquiler)
        pr.alquiler.save()
        callManager.hangUp()
        pr.alquiler = null
    }

    function asignMovil(index) {
        var alq = ldEspera.at(index)
        if (!alq) return;
        if (!alq.parada) return;
        var movil = alq.parada.moviles[0]

        if (!movil) return;
        alq.movil = movil;
        alq.fechaAtencion = new Date()
        movil.estado = 2
        alq.save()

        ldEspera.remove(alq)
        ldAtendidos.append(alq)
    }

    DBusInterface {
        id: callManager
        service:         'org.sflphone.SFLphone'
        path:            '/org/sflphone/SFLphone/CallManager'
        iface:           'org.sflphone.SFLphone.CallManager'
        signalsEnabled:  true
        //propertiesEnabled: true

        function incomingCall(accountID, callID, from) {
            if (pr.llamada) return;

            //var idLlamada = from.replace(/<sip:(\d+)@.*>/,'$1')
            var idLlamada = from.replace(/<(\d+)@.*>/,'$1')
            var tmp = ldCall.loadOne(idLlamada)
            pr.callid = callID
            if (!tmp)  {
                console.log("Error no se encuentra el ID de la LLamada ", idLlamada)
                callManager.hangUp()
                return;
            }

            //console.log("incoming: "+idLlamada)
            pr.llamada = tmp
            // set Operador pr.llamada =
            pr.llamada.llamando()
            pr.cliente = ldCls.find(llamada.telefono)
        }

        function callStateChanged(callid, state) {
            //console.log("callestate", state)
            if (state === "HUNGUP") {
                pr.llamada.colgar()
                pr.llamada.save()
                pr.llamada.deleteLater()

                pr.callid = ""
                pr.llamada = null
                pr.alquiler = null
            }
        }

        function hangUp() {
            if (pr.callid == "") return;

            /*typedCall("hangUp", { "type": "s", "value" : pr.callid },
                      function(r) { console.log("hangUp ", r) },
                      function() { console.log("error hangUp ") }) //*/
            call("hangUp", pr.callid)
        }

        function accept() {
            if (pr.callid == "") return;
            call("accept", pr.callid)
        }
    }
}

