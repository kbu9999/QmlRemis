import QtQuick 2.0
import com.kbu9999.FieldPanel 1.0

Panel {
    id: edAlq
    editIcon: "qrc:/assets/icons/document-edit.png"

    titleDelegate: TextStyled {
        text: styleData.title
        selectedColor: "#e0392e"
        selected: styleData.isCurrentIndex
        font.bold: true
    }

    showDelegate: TextStyled {
        text: styleData.value? styleData.value : ""
        selectedColor: "#e0392e"
    }

}
