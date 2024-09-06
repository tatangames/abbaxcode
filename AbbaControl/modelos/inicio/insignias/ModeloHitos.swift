//
//  ModeloHitos.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 26/3/24.
//

import Foundation

class ModeloHitos{
    
    var tipo: Int
    var nivel: Int
    var fechaFormat: String
    
    init(tipo: Int, nivel: Int, fechaFormat: String) {
        self.tipo = tipo
        self.nivel = nivel
        self.fechaFormat = fechaFormat
    }
    
}
