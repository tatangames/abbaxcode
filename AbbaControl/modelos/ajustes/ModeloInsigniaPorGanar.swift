//
//  ModeloInsigniaPorGanar.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 14/3/24.
//

import Foundation

class ModeloInsigniaPorGanar{
       
    var imagen: String
    var nombre: String
    var descripcion: String
    
    init(imagen: String, nombre: String, descripcion: String) {
        self.imagen = imagen
        self.nombre = nombre
        self.descripcion = descripcion
    }
          
    func getImagen() -> String {
        return imagen
    }
    
    func getNombre() -> String {
        return nombre
    }
    
    func getDescripcion() -> String {
        return descripcion
    }
}
