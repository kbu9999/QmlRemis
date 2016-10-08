#! /usr/bin/env python
"""Simple FastAGI server using starpy"""
#------------------------------------------------------------------------------#

from twisted.web import static, resource, server
from twisted.application.service import Application
from twisted.application.internet import TCPServer
from autobahn.twisted.resource import WebSocketResource

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.engine.url import URL

from yapsy.PluginManager import PluginManager
from twisted.python import log, logfile

from plugin import IServerPlugin
import settings

#start logging
import logging
logging.basicConfig(level=logging.DEBUG)

logFile = logfile.LogFile.fromFullPath('/var/log/qmlremis/webocket.log')
log.addObserver(log.FileLogObserver(logFile).emit)

#connect mysql 
engine = create_engine(URL(**settings.DATABASE))
Session = sessionmaker(bind=engine)
session = Session()

log.msg("start QmlRemis WebSocket Server")
root = static.Data("", "text/plain")

log.msg("sockets: init plugs")
manager = PluginManager()
manager.setPluginPlaces(["plugins", "/usr/share/qmlremis/service/plugins"])
manager.setCategoriesFilter({ "ServerPlugins" : IServerPlugin })
manager.collectPlugins()

for plugin in manager.getPluginsOfCategory("ServerPlugins"):
    log.msg("sockets: load %s plugin" % plugin.name)
    factory = plugin.plugin_object
    factory.session = session
    factory.manager = manager
    factory.startFactory()
    root.putChild(plugin.name, WebSocketResource(factory))


application = Application("QmlRemis AGI Server")
srv = TCPServer(9000, server.Site(root))
srv.setServiceParent(application)
