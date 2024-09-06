//
//  ModeloPendienteSoli.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 24/3/24.
//

import Foundation

class ModeloPendienteSoli{
    
    var tipo: Int
    var id: Int
    var fecha: String
    var correo: String
          

    init(tipo: Int, id: Int, fecha: String, correo: String) {
        self.tipo = tipo
        self.id = id
        self.fecha = fecha
        self.correo = correo
    }
}
