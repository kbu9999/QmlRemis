#!/usr/bin/python
from autobahn.twisted.websocket import WebSocketServerFactory, \
    WebSocketServerProtocol, listenWS

from datetime import datetime
from db import Movil, Alquiler

from plugin import IServerPlugin, RemisProtocol
from twisted.python import log
import json

class OperServerProtocol(RemisProtocol)  : 
    def updateParada(self, idParada) :
        self.sendCommand('onUpdateParada', { "idParada" : idParada })

    def updateEspera(self) :
        self.sendCommand('onUpdateEspera', None)
        
    
    def onUpdateEspera(self, data) :
        self.broadcast('updateEspera', data)
        
    def onUpdateParada(self, data) :
        self.broadcast('updateParada', data)
        self.broadcast('updateEspera', None)
        

class OperServerFactory(IServerPlugin) :
    
    protocol = OperServerProtocol
        
    def updateParada(self, conexiones, data) :
        for c in self._conexiones :
            c.updateParada(data.idParada)
        self.plugin("Movil", "colaChanged", { "idParada": data.idParada })
        
    """
    Asigna a los Primeros Moviles de cada Parada los Alquiler Pendiente
    hace que todos los operadores actualizen la lista de Alquileres en ESPERA
    """
    def updateEspera(self, conexiones, data) :
        #TODO cambiar por una consulta mejor, que solo mueste los primer alquiler de cada parada
        espera = self.session.query(Alquiler).filter(Alquiler.fechaAtencion == None).all()
        
        for alq in espera :
            movil = self.session.query(Movil).filter(Movil.idParada == alq.idParada)\
                .order_by(Movil.added).first()
            
            if movil :
                cl = self.session.query(alq.idCliente).filter(Cliente.idCliente == idCliente).first()
                #self.movilws.alquilerAssigned(movil.idMovil, alq, cl)
                self.plugin('Movil', 'assing', { 'idMovil': movil.idMovil, 'alquiler': alq, 'cliente': cl })
                
            else :
                log.msg("no hay movil en Parada %d" % alq.idParada)
                
        for c in self._conexiones :
            c.updateEspera()
    
            
