//
//  ModeloIdioma.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 13/3/24.
//

import Foundation

class ModeloIdioma{
       
    var id: Int
    var nombre: String
  
    
    init(id: Int, nombre: String) {
        self.id = id
        self.nombre = nombre
    }
          
    func getId() -> Int {
        return id
    }
    
    func getNombre() -> String {
        return nombre
    }
    
}
