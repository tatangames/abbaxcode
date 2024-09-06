//
//  ModeloPlanesAmigos.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 17/5/24.
//

import Foundation

class ModeloPlanesAmigos{
    
    var id: Int
    var idplanes: Int
    var fecha: String
    var imagen: String
    var titulo: String
    
    init(id: Int, idplanes: Int, fecha: String, imagen: String, titulo: String) {
        self.id = id
        self.idplanes = idplanes
        self.fecha = fecha
        self.imagen = imagen
        self.titulo = titulo
    }
    
    
}
