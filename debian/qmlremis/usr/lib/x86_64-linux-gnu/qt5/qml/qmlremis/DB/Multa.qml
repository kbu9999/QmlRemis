import QtQuick 2.0
import OrmQuick 1.0

import "Meta"
import com.kbu9999.SimpleDBSec 1.0

OrmObject {
    id: main
    metaTable: MetaMulta

    property int idMulta
    property Movil movil
    property Usuario usuario
    property date inicio
    property date fin

    property date restante


    signal finMulta()
}
