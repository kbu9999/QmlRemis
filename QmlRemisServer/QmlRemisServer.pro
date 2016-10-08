TEMPLATE = aux
TARGET = QmlRemis-Service

PyBase = service/__init__.py \
    service/settings_example.py \
    service/db.py \
    service/plugin.py \
    service/agi.py \
    service/agiService.py \
    service/socketService.py

PyPlugins = service/plugins/movilws.py \
    service/plugins/movil.yapsy-plugin \
    service/plugins/oper.yapsy-plugin \
    service/plugins/operadorws.py \

AST = asterisk/extensions.conf \
    asterisk/queues.conf \
    asterisk/sip.conf


DISTFILES += qmlremisAgi.service \
    qmlremisSocket.service \
    qmlremis.sql \
    $$PyBase \
    $$PyHelpers \
    $$PyPlugins \
    $$AST \

SOUNDS += sounds/espere.ulaw \
    sounds/gracias.ulaw \
    sounds/ivr.ulaw \
    sounds/llegara.ulaw

installPath = /usr/share/qmlremis/service

pybase.files += $$PyBase
pybase.path  = $$installPath

pyplugins.files += $$PyPlugins
pyplugins.path  = $$installPath/plugins

sysdservice.files += qmlremisAgi.service qmlremisSocket.service
sysdservice.path = /lib/systemd/system/

sql.files = qmlremis.sql sflphoned.yml
sql.path  = /usr/share/qmlremis

ast.files = $$AST
ast.path = /usr/share/qmlremis/

sounds.files = $$SOUNDS
sounds.path = /usr/share/asterisk/sounds/custom

INSTALLS += pybase pyplugins \
    sysdservice sql ast sounds


