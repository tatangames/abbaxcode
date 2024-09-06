//
//  ModeloBiblia.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 15/3/24.
//

import Foundation

class ModeloBiblia{
       
    var tipo: Int // 1: titulo, 2: datos, 3: no hay biblias
    var id: Int
    var nombre: String
    var imagen: String
      
    init(tipo: Int, id: Int, nombre: String, imagen: String) {
        self.tipo = tipo
        self.id = id
        self.nombre = nombre
        self.imagen = imagen
    }

    func getTipo() -> Int {
        return tipo
    }
    
    func getId() -> Int {
        return id
    }
    
    
    
    func getNombre() -> String {
        return nombre
    }
    
}
