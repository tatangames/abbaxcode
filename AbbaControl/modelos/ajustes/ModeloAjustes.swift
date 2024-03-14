//
//  ModeloAjustes.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 13/3/24.
//

import Foundation

class ModeloAjustes{
       
    var tipo: Int
    var id: Int
    var nombre: String
    var nombreImagen: String
  
    
    init(tipo: Int, id: Int, nombre: String, nombreImagen: String) {
        self.tipo = tipo
        self.id = id
        self.nombre = nombre
        self.nombreImagen = nombreImagen
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
    
    func getNombreImagen() -> String {
        return nombreImagen
    }
    
        
}
