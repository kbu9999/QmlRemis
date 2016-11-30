#!/bin/bash 

#create package

sudo checkinstall --pkgname qmlremis -pkgversion 0.2 --requires asterisk,mysql-server,openssh-server,libqt5qml5,libqt5sql5-mysql,qml-module-qtquick-controls,qml-module-qtgraphicaleffects,qml-module-qtwebsockets,qml-module-qtlocation,qml-module-qtpositioning,qml-module-qtquick-controls2,qml-module-qt-labs-settings,python-starpy,python-sqlalchemy,python-twisted,python-autobahn,python-pymysql,python-yapsy --maintainer kbu9999@gmail.com -y --install=no
