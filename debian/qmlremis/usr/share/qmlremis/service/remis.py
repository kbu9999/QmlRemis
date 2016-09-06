#!/usr/bin/env python3
from qmlremis import db
from qmlremis.db import Movil, Alquiler, Llamadas, Cliente
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.engine.url import URL
from datetime import datetime 
import json

import settings

engine = create_engine(URL(**settings.DATABASE))

def gps2Array(pos) :
    gps = pos.split(',')
    try:
        return [float(gps[0]), float(gps[1])]
    except (IndentationError, ValueError) :
        return [0, 0]

def dist(gps, p1) :
    return pow(gps[0]-p1[0],2)+pow(gps[1]-p1[1],2)

def paradaDist(parada, cliente) :
    clpos = gps2Array(cliente.gps_pos)
    ppos = gps2Array(parada.gps_pos)
    return dist(ppos, clpos)

class Remis(): 
    cliente = None
    llamada = None
    alqs = { }
    
    def __init__(self):
        Session = sessionmaker(bind=engine)
        self.session = Session()
    
    def findMovil(self, movil) :
        #print "    findMovil %s" % movil 
        return self.session.query(Movil)\
            .filter(Movil.idMovil == movil).first()

    def findCliente(self, idCliente) :
        #print "    findCliente %s" % idCliente
        return self.session.query(Cliente)\
            .filter(Cliente.idCliente == idCliente).first()
    
    def findAlquiler(self, idParada) :
        #print "    findAlquiler parada = %s" % idParada
        return self.session.query(Alquiler)\
            .filter(Alquiler.fechaAtencion == None, Alquiler.idParada == idParada)\
                .first()
            
    def cola(self, idParada) :
        #print "    cola de parada %s" % idParada
        return self.session.query(Movil).filter(Movil.idParada == idParada)\
            .order_by(Movil.added).all()
        
    "lalalla"
    
    def updateMovil(self, movil) :
        self.operws.updateMovil(movil)
        
    def updateCola(self, idParada) :
        cola = self.cola(idParada)
        self.operws.updateCola(idParada)
        self.movilws.colaChanged(idParada, cola)
        
    def updateEspera(self) :
        espera = self.session.query(Alquiler)\
            .filter(Alquiler.fechaAtencion == None).all()
        for alq in espera:
            movil = self.cola(alq.idParada).first()
            if movil :
                cl = self.findCliente(alq.idCliente)
                self.movilws.alquilerAssigned(movil.idMovil, alq, cl)
            else :
                print "no hay movil"
        self.operws.updateEspera()
    
    def aceptarAlquiler(self, movil, idAlquiler) :
        print "Aceptar - Alquiler: %s" % idAlquiler
        alq = self.session.query(Alquiler).filter(Alquiler.idAlquiler == idAlquiler).first()
        if alq : 
            alq.idMovil = movil.idMovil
            alq.fechaAtencion = datetime.now()
            self.session.commit()
            self.updateEspera()
            print "    ok - "
            return True
        
        return False

    """def update(self, idMovil) :
        self.session.commit()
        print "Update - Movil: %s" % idMovil
        movil = self.findMovil(idMovil)
        #(lst, pos) = self.calcCola(movil, cola)
        pos = -1
        cola = []
        if movil.idParada :
            cola = self.cola(movil.idParada)
            pos = cola.index(movil)
            if cola[0].idMovil == idMovil :
                alq = self.findAlquiler(movil.idParada)
        print "    ok1 - es el primero de la cola"
                if alq :
                    cl = self.findCliente(alq.idCliente)
                    print "    ok2 - id: %s, nombre: %s" % (cl.idCliente, cl.nombre)
        alq = None
        cl = None
        print "    info - cola: %s, pos: %s" % (len(cola), pos)
        return json.dumps({"cola" : cola,
                           "pos" : pos,
                           "alquiler" : alq,
                           "cliente" : cl }, cls=db.AlchemyEncoder)"""

