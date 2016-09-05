TEMPLATE = aux
TARGET = QmlRemis-Service

PyBase = __init__.py \
    qmlremisd.py \
    remis.py \
    settings.py \

PyPlugins = plugins/movilws.py \
    plugins/movil.yapsy-plugin \
    plugins/oper.yapsy-plugin \
    plugins/operadorws.py \

PyHelpers = qmlremis/__init__.py \
    qmlremis/agi.py \
    qmlremis/db.py \

AST = asterisk/extensions.conf \
    asterisk/queues.conf \
    asterisk/sip.conf


DISTFILES += qmlremis.service \
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

pyhelp.files += $$PyHelpers
pyhelp.path  = $$installPath/qmlremis

pyplugins.files += $$PyPlugins
pyplugins.path  = $$installPath/plugins

sysdservice.files += qmlremis.service
sysdservice.path = /lib/systemd/system/

sql.files = qmlremis.sql
sql.path  = /usr/share/qmlremis

ast.files = $$AST
ast.path = /usr/share/qmlremis/

sounds.files = $$SOUNDS
sounds.path = /usr/share/asterisk/sounds/custom

INSTALLS += pybase pyhelp pyplugins \
    sysdservice sql ast sounds


