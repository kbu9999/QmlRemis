import QtQuick 2.1
import QtQuick.Controls 1.1

import "../../Styles" as S

Grid {
    columns: 2
    columnSpacing: 15
    spacing: 8

    verticalItemAlignment: Grid.AlignVCenter
    anchors.margins: 10

    property string direccion: ""
    property bool _ei: false

    onFocusChanged: {
        if (focus) {
            calle.forceActiveFocus()
            calle.selectAll()
        }
    }

    function parse() {
        _ei = true
        direccion = calle.text + ", " + city.text + ", " + prov.text;
        _ei = false
    }
    onDireccionChanged:  {
        if (_ei) return;


        var lst = direccion.split(',')
        calle.text = lst[0]
        city.text = lst.length > 1? lst[1] : ""
        prov.text = lst.length > 2? lst[2] : ""
    }

    S.TextStyled {
        text: "Calle"
        font.pointSize: 10
    }

    TextField {
        id: calle
        text: "San Martin 526"
        font.family: "BellGothic BT"

        onAccepted: { parse(); city.focus = true; }

        //style: TextFieldStyle { }
    }

    S.TextStyled {
        text: "Ciudad"
        font.pointSize: 10
    }

    TextField {
        id: city
        text: "Banda del Rio Sali"
        font.family: "BellGothic BT"

        onAccepted: { parse(); prov.focus = true; }
    }

    S.TextStyled {
        text: "Provincia"
        font.pointSize: 10
    }

    TextField {
        id: prov
        text: "Tucuman"

        onAccepted: parse()
    }

    Button {
        text: "Guardar"
        onClicked: parent.guardar()
    }

    Button {
        text: "Buscar"
        onClicked: parent.buscar()
    }

    signal buscar()
    signal guardar()
}
