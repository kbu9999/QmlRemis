import QtQuick 2.0

import "code39.js" as Code39

Canvas {
    id: canvas
    width: 300
    height: 200

    property int weight: 2
    property color color: "black"
    property color background: "white"

    property string data
    property string format: "CODE39"

    onDataChanged: {
        requestPaint()
    }

    function encoded(content) {
        switch(format) {
        case "CODE39": return Code39.encoded(data);
        default: return "";
        }
    }

    Component.onCompleted: data = "123"

    onPaint: {
        var binary = encoded(data);
        if (binary.length <= 0) return;

        var ctx = canvas.getContext("2d");
        ctx.fillStyle = background
        ctx.fillRect(0, 0, width, height);

        ctx.fillStyle = color;
        var w = parseInt(width/binary.length)
        for(var i=0;i < binary.length; i++){
            var x = i * w;
            if(binary[i] == "1")
                ctx.fillRect(x, 0, w, canvas.height);
        }
    }
}
