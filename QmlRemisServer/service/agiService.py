#!/usr/bin/python
from twisted.application.internet import TCPServer
from twisted.application.service import Application
from twisted.web.resource import Resource

from twisted.python import log, logfile
import json

#----------------------------------------------------------------------------#
#--------------------------                   -------------------------------#
#----------------------------------------------------------------------------#
from twisted.internet.protocol import ReconnectingClientFactory
from autobahn.twisted.websocket import WebSocketClientFactory, \
    WebSocketClientProtocol, \
    connectWS

class OperClientProtocol(WebSocketClientProtocol):
    opened = False
    def onOpen(self):
        self.opened = True
        
    def onClose(self):
        self.opened = False
        
    def updateEspera(self):
        if self.opened : 
            self.sendMessage(json.dumps({ 'cmd' : 'updateEspera' }))
            log.msg("OPER: send updateEspera")
        else :
            log.err("OPER: socket not connected")
        
    def onMessage(self, payload, isBinary):
        if not isBinary:
            log.msg("OPER: Text message received: {}".format(payload.decode('utf8')))


class OperClientFactory(ReconnectingClientFactory, WebSocketClientFactory):
    protocol = OperClientProtocol
    
    maxDelay = 15
    #maxRetries = 5

    def startedConnecting(self, connector):
        log.msg('FACTORY ---- Started to connect.')

    def clientConnectionLost(self, connector, reason):
        log.msg('FACTORY ---- Lost connection. Reason: {}'.format(reason))
        ReconnectingClientFactory.clientConnectionLost(self, connector, reason)

    def clientConnectionFailed(self, connector, reason):
        log.msg('FACTORY ---- Connection failed. Reason: {}'.format(reason))
        ReconnectingClientFactory.clientConnectionFailed(self, connector, reason)



#------------------------------------------------------------------------------#

import settings
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.engine.url import URL

from starpy import fastagi
import agi

#start logging
logFile = logfile.LogFile.fromFullPath('/var/log/qmlremis/agi.log')
log.addObserver(log.FileLogObserver(logFile).emit)

#connect mysql 
engine = create_engine(URL(**settings.DATABASE))
Session = sessionmaker(bind=engine)
session = Session()

#connect websocket
ws = OperClientFactory("ws://localhost:9000/Oper")
connectWS(ws)

ragi = agi.RemisAgi(session, ws.protocol())
factory = fastagi.FastAGIFactory(ragi.main)

log.msg("start QmlRemis AGI Server")
application = Application("QmlRemis AGI Server")
srv = TCPServer(4573, factory)
srv.setServiceParent(application)
