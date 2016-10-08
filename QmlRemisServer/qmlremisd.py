#! /usr/bin/env python
"""Simple FastAGI server using starpy"""
from twisted.internet import reactor, defer
from zope.interface import implements
from twisted.cred import portal, checkers, credentials, error as credError
from twisted.web import static, resource, server
from twisted.web.resource import IResource
from twisted.web.guard import HTTPAuthSessionWrapper, BasicCredentialFactory, DigestCredentialFactory
from autobahn.twisted.resource import WebSocketResource

from autobahn.twisted.websocket import listenWS

from starpy import fastagi
#import logging, time

from qmlremis import agi
from remis import Remis 

import logging
log = logging.getLogger('yapsy')

from twisted.web.server import Site
from twisted.web.static import Data

class HttpPasswordRealm(object):
    implements(portal.IRealm)

    def __init__(self, myresource):
        self.myresource = myresource
    
    def requestAvatar(self, user, mind, *interfaces):
        print "--- %s" % user
        if IResource in interfaces:
            # myresource is passed on regardless of user
            return (IResource, self.myresource, lambda: None)
        raise NotImplementedError()
    
def createSOAPServer(myresource) :
    checker = checkers.InMemoryUsernamePasswordDatabaseDontUse()
    checker.addUser('admin','aaa')
    realm = HttpPasswordRealm(myresource)
    p = portal.Portal(realm, [checker])
    credentialFactory = BasicCredentialFactory('kbu9999')
    #credentialFactory = DigestCredentialFactory('md5', 'kbu9999')
    root = resource.Resource()
    #root.putChild('SOAP', HTTPAuthSessionWrapper(p, [credentialFactory]))
    root.putChild('SOAP', myresource)
    return server.Site(root)

from yapsy.PluginManager import PluginManager

if __name__ == "__main__":
        qmlremis = Remis()
        #FastAGI
	ragi = agi.RemisAgi(qmlremis)
	agi = fastagi.FastAGIFactory( ragi.main )
	reactor.listenTCP(4573, agi, 50, '127.0.0.1') # only binding on local interface
	
        # Establish a dummy root resource
        root = Data("", "text/plain")
        
        """
        factory1 = ws.OperServerFactory(qmlremis)
        factory1.startFactory()  # when wrapped as a Twisted Web resource, start the underlying factory manually
        resource1 = WebSocketResource(factory1)

        factory2 = ws.MovilServerFactory(qmlremis)
        factory2.startFactory()  # when wrapped as a Twisted Web resource, start the underlying factory manually
        resource2 = WebSocketResource(factory2)
        """
        
        ""
        manager = PluginManager()
        manager.setPluginPlaces(["plugins", "/usr/share/qmlremis/service/plugins"])
        manager.collectPlugins()
        
        print "init plugs"

        for plugin in manager.getAllPlugins():
            print plugin.url
            plo = plugin.plugin_object
            print plo.url()
            root.putChild(plo.url(), plo.createResource(qmlremis))
        ""

        """
        # and our WebSocket servers under different paths .. (note that
        # Twisted uses bytes for URIs)
        root.putChild(b"oper", resource1)
        root.putChild(b"movil",  resource2)
        """

        # both under one Twisted Web Site
        site = Site(root)
        reactor.listenTCP(9000, site)
	
	#SOAP
	#soap = createSOAPServer(soap.RemisSOAP(qmlremis) )
	#reactor.listenTCP(8801, soap)
        
	reactor.run()

