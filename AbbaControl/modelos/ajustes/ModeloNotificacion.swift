//
//  ModeloNotificacion.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 14/3/24.
//

import Foundation

class ModeloNotificacion{
       
    var hayimagen: Int
    var imagen: String
    var nombre: String
  
    
    init(hayimagen: Int, imagen: String, nombre: String) {
        self.hayimagen = hayimagen
        self.imagen = imagen
        self.nombre = nombre
    }
          
    func getHayImagen() -> Int {
        return hayimagen
    }
    
    func getImagen() -> String {
        return imagen
    }
    
    func getNombre() -> String {
        return nombre
    }
    
}
