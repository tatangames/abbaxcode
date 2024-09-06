//
//  ModeloComuAmigosIniciar.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 20/3/24.
//

import Foundation

class ModeloComuAmigosIniciar{
    
    var id: Int
    var estado: Bool
    var idusuario: Int
    var idpais: Int
    var nombre: String
    var correo: String
    var nombrepais: String
     
    
    init(id: Int, idusuario: Int, idpais: Int, nombre: String, correo: String, nombrepais: String, estado: Bool) {
        self.id = id
        self.idusuario = idusuario
        self.idpais = idpais
        self.nombre = nombre
        self.correo = correo
        self.nombrepais = nombrepais
        self.estado = estado
    }
    
    func getId() -> Int {
        return id
    }
    
    
    func getIdUsuario() -> Int {
        return idusuario
    }
    
    func getIdPais() -> Int {
        return idpais
    }
    
    func getNombre() -> String {
        return nombre
    }
    
    func getCorreo() -> String {
        return correo
    }
    
    func getNombrePais() -> String {
        return nombrepais
    }
  
    func getEstado() -> Bool {
        return estado
    }
  
}
