import QtQuick 2.0
import OrmQuick 1.0

import "Meta"

OrmLoader {
    id: ld
    table: MetaUsuario
    query: "SELECT * FROM sec_Usuario WHERE user = :user AND pass = md5(:pass)"

    property Usuario usuario

    readonly property bool connected: usuario? true : false

    onUsuarioChanged: {
        if (usuario) logged()
        else loose()
    }

    signal logged();
    signal loose();
    signal error(string msg)

    function logout() {
        ld.usuario = null
    }

    function login(user, pass) {
        addBindValue(":user", user)
        addBindValue(":pass", pass)
        var users = load();
        if (users.length <= 0) {
            error("no user or pass")
            return;
        }

        usuario = users[0]
    }
}

