#! /usr/bin/env python
"""Simple FastAGI server using starpy"""
from starpy import fastagi
from twisted.python import log
from datetime import datetime
import time

from db import Parada, Alquiler, Llamadas, Cliente

class MySeq(fastagi.InSequence) :
    cliente = None
    llamada = None
    
    def insert(self, index, function, *args, **named):
        self.actions.insert(index, (function, args, named))
        
    def lastResult(self) :
        return self.results[ len(self.results) - 1 ]

class RemisAgi() :
    def __init__(self, session, ws)  :
        self.session = session
        self.ws = ws
        log.msg(ws)
        ws.updateEspera()
    
    def checkLlamada(self, seq, telefono) :
        #print telefono
        seq.llamada = Llamadas(telefono)
        lst = self.session.query(Cliente).filter(Cliente.telefono == telefono)
        if lst :
            seq.cliente = lst.first()
        if seq.cliente :
            if seq.cliente.checkGps() is False:
                seq.cliente = None
        self.session.add(seq.llamada)
        self.session.commit()
        
    def fin(self, seq) :
        if seq.llamada :
            seq.llamada.duracion = datetime.now() - seq.llamada.fecha
            self.session.commit()
        
    def addAlquiler(self, seq) :
        paradas = self.session.query(Parada).all()
        p = paradas[0]
        d = paradaDist(p, seq.cliente)
        paradas.pop(0)
        for pi in paradas :
            d2 = paradaDist(pi, seq.cliente)
            if d2 < d :
                d = d2
                p = pi
        alquiler = Alquiler(seq.llamada, seq.cliente, p.idParada)
        self.session.add(alquiler)
        self.session.commit()
        self.remis.updateEspera()
        
    "agis methods"
    
    def onFailure(self, reason, seq, agi):
        print "RemisAgi: Failure - %s" % reason.getTraceback()
        self.fin(seq)
        agi.finish()
                    
    def main(self, agi ): 
        sequence = MySeq()
        self.checkLlamada(sequence, agi.variables['agi_callerid'])
        if not sequence.cliente :
            sequence.append( self.seq_queue, sequence, agi)
        else :
            sequence.append( self.seq_menu, sequence, agi)
        sequence.append( self.fin, sequence )
        sequence.append( agi.execute, "PLAYBACK", "custom/gracias")
        sequence.append( agi.finish )
        return sequence().addErrback( self.onFailure, sequence, agi )
        
    def seq_queue(self, seq, agi ):
        llid = seq.llamada.idLlamadas
        seq.insert(0, agi.execute, "PLAYBACK", "custom/espere")
        seq.insert(1, agi.setVariable, "MONITOR_FILENAME", "Operadoras/%s" % llid)
        seq.insert(2, agi.setCallerID, llid)
        seq.insert(3, agi.execute, "QUEUE", "Operadoras")
        
    def seq_menu(self, seq, agi) :
        seq.insert(0, agi.execute, "PLAYBACK", "custom/ivr")
        seq.insert(1, agi.waitForDigit, 5)
        seq.insert(2, self.digit, seq, agi)
        
    def digit(self, seq, agi) :
        op = int(seq.lastResult()) - 48
        seq.insert(0, agi.execute, "PLAYBACK", "custom/espere")
        if op == 1 :
            seq.insert(1, self.addAlquiler, seq )
        else :
            seq.insert(1, self.seq_queue, seq, agi )
    
