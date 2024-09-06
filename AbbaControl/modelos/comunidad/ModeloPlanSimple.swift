//
//  ModeloPlanSimple.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 21/6/24.
//

import Foundation

class ModeloPlanSimple{
       
    var titulo: String
    var imagen: String
    var idplanes: Int
    
    init(idplanes: Int, titulo: String, imagen: String) {
        self.idplanes = idplanes
        self.titulo = titulo
        self.imagen = imagen
    }
    
    
}
