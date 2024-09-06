//
//  ModeloComunidadAceptados.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 23/3/24.
//

import Foundation

class ModeloComunidadAceptados{
    
    var tipo: Int
    var id: Int
    var nombre: String
    var iglesia: String
    var correo: String
    var pais: String
    var idpais: Int
      

    init(tipo: Int, id: Int, nombre: String, iglesia: String, correo: String, pais: String, idpais: Int) {
        self.tipo = tipo
        self.id = id
        self.nombre = nombre
        self.iglesia = iglesia
        self.correo = correo
        self.pais = pais
        self.idpais = idpais
    }
    
}
