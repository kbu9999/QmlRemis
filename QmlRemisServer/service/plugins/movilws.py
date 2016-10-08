#!/usr/bin/python

import Cookie

from autobahn.twisted.websocket import WebSocketServerFactory, \
    WebSocketServerProtocol, listenWS

from datetime import datetime
from db import Movil, Alquiler

from twisted.python import log
from plugin import IServerPlugin, RemisProtocol
import json

class MovilServerProtocol(RemisProtocol)  :     
    movil = None
    
    def colaChanged(self, cola, pos) :
        self.sendCommand('onColaChanged', { 'cola' : cola, 'pos' : pos })
    
    def assign(self, alquiler, cliente):
        self.sendCommand('onAssign', { 'alquiler': alquiler, 'cliente' : cliente })
    
    def onLogin(self, data):
        self.movil = self.session.query(Movil).filter(Movil.idMovil == data.idMovil).first()
        if not self.movil:
            self.sendClose()
            log.msg("no existe movil: %d" % data.idMovil)
        
    def onLogout(self, data):
        self.movil.idParada = None
        self.movil.added = None
        self.movil.estado = 0
        self.session.commit()
        
        self.movil = None
        self.sendClose()
        
    def onOcupado(self, data) :
        idParada = self.movil.idParada
        self.movil.idParada = None
        self.movil.added = None
        self.movil.estado = 2
        self.session.commit()
        
        self.plugin('Oper', 'updateParada', {'idParada' :idParada })
        log.msg("    ok - parada: %s, estado: %s" % (idParada, self.movil.estado))
            
    def onEnParada(self, data) :
        if self.movil.idParada :
            log.msg("    ok - movil %d esta en parada: %s" %(movi.idMovil, self.movil.idParada))
            return
        
        self.movil.idParada = data.idParada
        self.movil.added = datetime.now()
        self.movil.estado = 1
        self.session.commit()
        
        self.plugin('Oper', 'updateParada', {'idParada' : data.idParada })
        log.msg("    ok - parada: %s, estado: %s" % (data.idParada, self.movil.estado))
            
    def onAceptar(self, data) :
        alq = self.session.query(Alquiler).filter(Alquiler.idAlquiler == data.idAlquiler).first()
        if not alq : 
            return
        
        alq.idMovil = self.movil.idMovil
        alq.fechaAtencion = datetime.now()
        log.msg("    ok - assign alquiler: %s, atencion: %s" % (alq.idParada, alq.fechaAtencion))
        self.session.add(alq)
        self.session.commit()
        
        self.onOcupado()
        self.plugin('Oper', 'updateEspera', None)
        

class MovilServerFactory(IServerPlugin) :
    
    protocol = MovilServerProtocol
        
    def colaChanged(self, conexiones, data) : 
        self.session.commit()
        cola = self.session.query(Movil).filter(Movil.idParada == data.idParada)\
            .order_by(Movil.added).all()
        
        for c in conexiones :
            pos = cola.index(c.movil)
            log.msg("pos %d" % pos)
            if pos >= 0 :
                c.colaChanged(cola, pos)
            
            
    def assign(self, conexiones, data) :
        con = None
        for c in conexiones :
            if c.movil.idMovil == data.idMovil :
                con = c.movil
                break
            
        if con :
            con.assign(data.cliente, data.alquiler)
        
        
        
        
