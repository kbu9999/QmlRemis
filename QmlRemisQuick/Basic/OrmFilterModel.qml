import QtQuick 2.0
import OrmQuick 1.0

import common.DB 1.0
import common.DB.Meta 1.0

Item {
    property alias metaTable: ld.metaTable
    property alias loadForeignKeys: ld.loadForeignKeys
    property string role
    property var filter

    property ListModel model: ListModel {
    }

    OrmModel {
        id: ld
    }

    function load() {
        model.clear()
        ld.load()

        filterChanged(filter)
    }

    function at(index) {
        var i = model.get(index).realIndex
        return ld.at(i)
    }

    onFilterChanged: {
        var filterRegExp = new RegExp(filter, 'i')
        model.clear();
        for(var i = 0; i < ld.result.length; i++) {
            var p = ld.at(i)
            if (filter === "" || filterRegExp.test(p[role])) {
                model.append(p)
                model.setProperty(model.count - 1, "realIndex", i)
            }
        }
    }
}

