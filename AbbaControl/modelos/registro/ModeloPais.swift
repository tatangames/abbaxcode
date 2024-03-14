//
//  ModeloPais.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 10/3/24.
//

import UIKit

class ModeloPais{
       
    var id: Int
    var nombre: String
    var imagen: UIImage?
    
    init(id: Int, nombre: String, imagen: UIImage? = nil) {
         self.id = id
         self.nombre = nombre
         self.imagen = imagen
    }
        
    
    func getId() -> Int {
        return id
    }
    
    func getNombre() -> String {
        return nombre
    }
}
