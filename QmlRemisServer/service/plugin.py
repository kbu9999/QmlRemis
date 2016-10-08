#!/usr/bin/python
import db
import json
from collections import namedtuple
from twisted.python import log
from autobahn.twisted.websocket import WebSocketServerFactory, \
    WebSocketServerProtocol

def _json_object_hook(d): return namedtuple('X', d.keys())(*d.values())
def json2obj(data): return json.loads(data, object_hook=_json_object_hook)

class IServerPlugin(WebSocketServerFactory) :
    manager = None
    session = None
    
    def __init__(self):
        WebSocketServerFactory.__init__(self, debug=False)
        self._conexiones = [ ]
        #self.session = session

    def register(self, client):
        self._conexiones.append(client)

    def unregister(self, client):
        if self._conexiones.__contains__(client):
            self._conexiones.remove(client)
        #log.msg("unreg %d" % len(self._conexiones))

    def broadcast(self, cmd, data) :
        if type(data) == type({}) :
            data = _json_object_hook(data)
        
        func = getattr(self, cmd)
        if func :
            func(self._conexiones, data)
        else :
            log.msg("broadcast error: no have '%s' function " % cmd)
            

    def plugin(self, url, cmd, data) :
        plug = None
        for plugin in self.manager.getPluginsOfCategory("ServerPlugins"):
            if plugin.name == url :
                plug = plugin.plugin_object
                break
            
        if plug :
            plug.broadcast(cmd, data)
        else :
            log.msg("broadcast: no have '%s' plugin" % url)


class RemisProtocol(WebSocketServerProtocol)  :
    session = None
        
    def onConnect(self, request) :
        self.session = self.factory.session
        self.factory.register(self)
        
    def onClose(self, wasClean, code, reason) :
        self.factory.unregister(self)
        
    def onMessage(self, payload, isBinary) :  
        if isBinary:
            log.msg("protocol: no acept binary")
            return
        
        msg = json2obj(payload)
        
        func = getattr(self, msg.cmd)
        if func :
            func(msg.data)
        else :
            log.msg("protoco error: no have '%s' function " % msg.cmd)
            
    def sendCommand(self, cmd, data) :
        snd = json.dumps({ 'cmd' : cmd, 'data': data }, cls=db.AlchemyEncoder)
        self.sendMessage(snd)
        #log.msg('send cmd: %s' % cmd)
        
    def broadcast(self, cmd, data):
        self.factory.broadcast(cmd, data)
        
    def plugin(self, url, cmd, data):
        self.factory.plugin(url, cmd, data)
            
            
