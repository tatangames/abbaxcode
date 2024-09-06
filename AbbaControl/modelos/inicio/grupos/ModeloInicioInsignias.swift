//
//  ModeloInicioInsignias.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 24/3/24.
//

import Foundation

class ModeloInicioInsignias{
    
    var idtipoinsignia: Int
    var titulo: String
    var descripcion: String
    var nivelvoy: Int
    var imagen: String
    
    init(idtipoinsignia: Int, titulo: String, descripcion: String, nivelvoy: Int, imagen: String) {
        self.idtipoinsignia = idtipoinsignia
        self.titulo = titulo
        self.descripcion = descripcion
        self.nivelvoy = nivelvoy
        self.imagen = imagen
    }
    
}
