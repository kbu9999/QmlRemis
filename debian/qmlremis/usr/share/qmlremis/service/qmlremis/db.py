#!/usr/bin/env python3
from sqlalchemy import Column, String, Integer, ForeignKey, DateTime, Time
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime

import json
 
Base = declarative_base()

import json
from sqlalchemy.ext.declarative import DeclarativeMeta


class AlchemyEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj.__class__, DeclarativeMeta):
            # an SQLAlchemy class
            fields = {}
            for field in [x for x in dir(obj) if not x.startswith('_') and x != 'metadata']:
                data = obj.__getattribute__(field)
                try:
                    json.dumps(data) # this will fail on non-encodable values, like other classes
                    fields[field] = data
                except TypeError:
                    fields[field] = None
            # a json-encodable dict
            return fields

        return json.JSONEncoder.default(self, obj)

class Cliente(Base):
    __tablename__ = "Cliente"
    idCliente = Column(Integer, primary_key=True)
    telefono = Column(Integer, index=True, nullable=False)
    nombre = Column(String(45))
    direccion = Column(String(45))
    descripcion = Column(String(45))
    gps_pos = Column(String(45))
    
    def __init__(self, telefono, nombre):
        self.nombre = nombre
        self.telefono = telefono
        
    def checkGps(self) :
        if not self.gps_pos : 
            return False
        
        gps = self.gps_pos.split(',')
        try:
            arr = (float(gps[0]), float(gps[1]))
            if arr[0] == 0 or arr[1] == 0 :
                return False
            else :
                return True
        except (IndentationError, ValueError) :
            return False
        
class Llamadas(Base):
    __tablename__ = "Llamadas"
    idLlamadas =  Column(Integer, primary_key=True)
    fecha = Column(DateTime)
    telefono = Column(Integer, nullable=False)
    duracion = Column(Time)
    grabacion = Column(String(100))
    
    def __init__(self, telefono):
        self.telefono = telefono
        self.fecha = datetime.now()
        
class Alquiler(Base):
    __tablename__ = "Alquiler"
    idAlquiler = Column(Integer, primary_key=True)
    idParada = Column(Integer)
    idCliente = Column(Integer, ForeignKey("Cliente.idCliente"))
    idLlamadas = Column(Integer, ForeignKey("Llamadas.idLlamadas"))
    telefono = Column(Integer, ForeignKey("Llamadas.telefono"))
    fecha = Column(DateTime, ForeignKey("Llamadas.fecha"))
    origen = Column(String(45), ForeignKey("Cliente.direccion"))
    origen_gps = Column(String(45), ForeignKey("Cliente.gps_pos"))
    fechaAtencion = Column(DateTime)
    #cliente = relationship("Cliente", foreign_keys="idCliente")
    #llamada = relationship("Llamadas")
    
    def __init__(self, llamada, cliente, idParada) :
        self.llamada = llamada
        self.cliente = cliente
        self.idParada = idParada
        self.idCliente = cliente.idCliente
        self.idLlamadas = llamada.idLlamadas
        self.telefono = llamada.telefono
        self.fecha = llamada.fecha
        self.origen = cliente.direccion
        self.origen_gps = cliente.gps_pos
        
class Movil(Base):
    __tablename__ = "Movil"
    idMovil = Column(Integer, primary_key=True)
    idParada = Column(Integer)
    modelo = Column(String(45))
    ultimaPos = Column(String(45))
    estado = Column(Integer)
    added = Column(DateTime)
    
    
class Parada(Base) :
    __tablename__ = "Parada"
    idParada = Column(Integer, primary_key=True)
    gps_pos = Column(String(45))
        
        
  
