#!/usr/bin/python

import sys
import json
import Cookie

from twisted.internet import reactor
from autobahn.util import newid, utcnow
from autobahn.websocket import http

from autobahn.twisted.websocket import WebSocketServerFactory, \
    WebSocketServerProtocol, listenWS

from autobahn.twisted.resource import WebSocketResource

from qmlremis import db
from datetime import datetime     

class OperServerProtocol(WebSocketServerProtocol)  :
    #def onOpen(self) :
    def onConnect(self, request) :
        self.factory._conexiones.append(self)
        
    def onClose(self, wasClean, code, reason) :
        if self.factory._conexiones.__contains__(self) :
            self.factory._conexiones.remove(self)
        
    def onMessage(self, payload, isBinary) :  
        if isBinary:
            return
        
        #print payload
        msg = json.loads(payload)
        if msg['cmd'] == "ACEPTARALQUILER" :
            self.__aceptar(msg['idMovil'], msg['idAlquiler'])
        elif msg['cmd'] == "UPDATEESPERA" :
            self.factory.remis.updateEspera()
            self.factory.updateEspera()
        elif msg['cmd'] == "UPDATEPARADA" :
            self.factory.updateParada(msg['idParada'])
        
    def updateCola(self, idParada) :
        self.sendMessage(json.dumps({ 'cmd' : 'UPDATEPARADA', "idParada" : idParada } ))

    def updateEspera(self) :
        self.sendMessage(json.dumps({ 'cmd' : 'UPDATEESPERA' } ))
        
    def __aceptar(self, idMovil, idAlquiler) :
        movil = self.qremis.findMovil(idMovil) 
        if movil :
            self.factory.remis.aceptarAlquiler(movil, idAlquiler)
        

class OperServerFactory(WebSocketServerFactory) :
    
    protocol = OperServerProtocol
    
    def __init__(self, qremis):
        #print url
        WebSocketServerFactory.__init__(self, debug=False)
        self.qremis = qremis
        self.session = qremis.session
        self._conexiones = [ ]
        
    def updateParada(self, idParada) :
        self.session.commit()
        cola = self.qremis.cola(idParada)
        self.qremis.movilws.colaChanged(idParada, cola)
        
    def updateCola(self, idParada) :
        for con in self._conexiones :
            con.updateCola(idParada)
    
    def updateEspera(self) :
        for con in self._conexiones :
            con.updateEspera()
            

from yapsy.IPlugin import IPlugin

class OperPlugin(IPlugin):
    def createResource(self, qmlremis):
        factory = OperServerFactory(qmlremis)
        factory.startFactory()
        return WebSocketResource(factory)
        
    def url(self) :
        return "oper"