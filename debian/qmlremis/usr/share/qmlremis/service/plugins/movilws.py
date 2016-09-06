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

class MovilServerProtocol(WebSocketServerProtocol) :
    _cbtid = None
    
    def onConnect(self, request) :
        protocol, headers = None, {}
        
        if 'cookie' in request.headers:
            try:
                cookie = Cookie.SimpleCookie()
                cookie.load(str(request.headers['cookie']))
            except Cookie.CookieError:
                pass
            else:
                if 'cbtid' in cookie:
                    cbtid = cookie['cbtid'].value
                    if cbtid in self.factory._cookies:
                        self._cbtid = cbtid
                        #log.msg("Cookie already set: %s" % self._cbtid)

        if self._cbtid is None :
            self._cbtid = newid()
            maxAge = 86400

            cbtData = {'created': utcnow(),
                       'movil': None,
                       'maxAge': maxAge,
                       'connection': None}
            self.factory._cookies[self._cbtid] = cbtData
            
            headers['Set-Cookie'] = 'cbtid=%s;max-age=%d' % (self._cbtid, maxAge)
            #log.msg("Setting new cookie: %s" % self._cbtid)

        print " sid: %s " % self._cbtid
        c = self.__cookie()
        c['connection'] = self

        return (protocol, headers)

    def onOpen(self) :
        c = self.__cookie()
        movil = c['movil']
        if not movil:
            self.sendMessage(json.dumps({'cmd': 'AUTHENTICATION_REQUIRED'}))
        else:
            self.sendMessage(json.dumps({'cmd': 'AUTHENTICATED', 'Movil': movil.idMovil}))

    def onClose(self, wasClean, code, reason) :
        if self._cbtid is None :
            return
        c = self.__cookie()
        c['connection'] = None
        #if not c['connection']:
        #    log.msg("All connection for {} gone".format(self._cbtid))

    def onMessage(self, payload, isBinary) :
        if isBinary:
            return
        
        msg = json.loads(payload)
        print payload
        
        cmd = msg['cmd']
        if cmd == 'AUTHENTICATE':
            self.__auth(msg['idMovil'])
        elif cmd == 'LOGOUT':
            self.__logout(msg)
        elif cmd == 'OCUPADO' :
            self.__ocupado()
        elif cmd == 'ENPARADA' :
            self.__enParada(msg['idParada'])
        elif cmd == 'MOVILGPS' :
            self.__movilGps(msg['gps'])
        elif cmd == 'ACEPTAR' :
            self.__acetar(msg['idAlquiler'])
        #else:
        #    log.msg("unknown command {}".format(msg))

    def __cookie(self) :
        return self.factory._cookies[self._cbtid]
        
    def __auth(self, idMovil) :
        for ckid in self.factory._cookies :
            ck = self.factory._cookies[ckid]
            if ck['movil'] and ck['movil'].idMovil == idMovil :
                self.__close("ya hay un movil: %s" % idMovil)
                return   
            
        movil = self.factory.qremis.findMovil(idMovil)
        if not movil :
            self.__close("no existe un movil: %s" % idMovil)
            return
                
        c = self.__cookie()
        c['movil'] = movil
        msg = json.dumps({'cmd': 'AUTHENTICATED', 'idMovil': movil.idMovil})
        if c['connection'] : 
            self.sendMessage(msg)
            cola = self.factory.qremis.cola(movil.idParada)
            pos = cola.index(movil)
            self.colachanged(cola, pos)
        #for proto in c['connection'] : proto.sendMessage(msg)
        
    def colachanged(self, cola, pos) :
        self.sendMessage(json.dumps({ 
                    'cmd': 'COLACHANGED', 
                    'cola' : cola, 
                    'pos' : pos }, cls=db.AlchemyEncoder))
            
    def __logout(self, msg) :
        movil = self.__cookie()['movil']
        if movil :
            self.__cookie()['movil'] = False
            self.__close("logout desde el movil")
            
            idParada = movil.idParada
            movil.idParada = None
            movil.added = None
            movil.estado = 0
            self.factory.session.commit()
            if idParada :
                self.factory.qremis.updateCola(int(idParada))
            print "    ok - parada: %s, estado: %s" % (idParada, movil.estado)
            
            #msg = json.dumps({'cmd': 'LOGGED_OUT'})
            #if c['connection'] : 
            #    c['connection'].sendMessage(msg)
                
    def __close(self, reason) :
        self.sendMessage(json.dumps({'cmd': 'AUTHENTICATION_FAILED', 'reason': reason}))
        self.sendClose()
        
    def __ocupado(self) :
        movil = self.__cookie()['movil']
        if movil :
            idParada = movil.idParada
            movil.idParada = None
            movil.added = None
            movil.estado = 2
            self.factory.session.commit()
            self.factory.qremis.updateCola(idParada)
            print "    ok - parada: %s, estado: %s" % (idParada, movil.estado)
            
    def __enParada(self, idParada) :
        movil = self.__cookie()['movil']
        print "enParada - Parada: %s" % idParada
        if movil :
            if movil.idParada :
                print "    ok - esta en parada: %s" %movil.idParada
                return
            movil.idParada = idParada
            movil.added = datetime.now()
            movil.estado = 1
            self.factory.session.commit()
            self.factory.qremis.updateCola(int(idParada))
            print "    ok - parada: %s, estado: %s" % (idParada, movil.estado)
            
    def __aceptar(self, idAlquiler) :
        movil = self.__cookie()['movil']
        if self.qremis.aceptarAlquiler(movil, idAlquiler) :
            self.__ocupado()

class MovilServerFactory(WebSocketServerFactory) :
    protocol = MovilServerProtocol
    
    def __init__(self, qremis) :
        WebSocketServerFactory.__init__(self, debug=False)
        self.qremis = qremis
        self.session = qremis.session
        # map of cookies
        self._cookies = {}
        #print url
        
    def colaChanged(self, idParada, cola) : 
        for ckid in self._cookies :
            ck = self._cookies[ckid]
            if ck['connection'] and ck['movil'].idParada == int(idParada) :
                #TODO q pasa aqui
                pos = cola.index(ck['movil'])
                ck['connection'].colachanged(cola, pos)
                
    def alquilerAssigned(self, idMovil, alquiler, cliente) :
        for ckid in self._cookies :
            ck = self._cookies[ckid]
            if ck['movil'].idMovil == idMovil :
                ck['connection'].sendMessage(json.dumps({
                    'cmd': 'ALQUILERASSIGNED',
                    'alquiler' : alquiler,
                    'cliente' : cliente
                    }, cls=db.AlchemyEncoder))
                return

from yapsy.IPlugin import IPlugin

class MovilPlugin(IPlugin):
    def createResource(self, qmlremis):
        factory = MovilServerFactory(qmlremis)
        factory.startFactory()
        return WebSocketResource(factory)
        
    def url(self) :
        return "movil"
