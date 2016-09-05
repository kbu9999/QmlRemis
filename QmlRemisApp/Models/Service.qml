pragma Singleton
import QtQuick 2.0
import QtWebSockets 1.0

WebSocket {
    id: wsOper
    active: true

    signal updateParada(var idParada)
    signal updateEspera()

    url: "ws://localhost:8889/oper"

    onTextMessageReceived: {
        console.log(message)
        var resp = JSON.parse(message)
        if (!resp) return;

        if (resp.cmd === "UPDATEPARADA") {
            updateParada(resp.idParada)
            return;
        }
        if (resp.cmd === "UPDATEESPERA") {
            updateEspera()
            return;
        }
    }

    onStatusChanged: {
        if (status == WebSocket.Open)
            console.log("conectado")
        if (status == WebSocket.Error)
            console.log("error: "+errorString)
    }

    function aceptar(idMovil, idAlquiler) {
        sendTextMessage('{ "cmd": "ACEPTARALQUILER",
                           "idMovil": "'+idMovil+',
                           "idAlquiler": "'+idAlquiler+'" }')
    }

    function esperaChanged() {
        sendTextMessage('{ "cmd": "UPDATEESPERA" }')
    }

    function paradaChanged(idParada) {
        sendTextMessage('{ "cmd": "UPDATEPARADA",
                           "idParada": "'+idParada+'" }')
    }
}
