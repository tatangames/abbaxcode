//
//  ModeloItemsPlanAmigo.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 17/5/24.
//

import Foundation

class ModeloItemsPlanAmigo{
    
    
    var id: Int
    var idusuario: Int
    var idplanblockdeta: Int
    var completado: Int
    var titulo: String
    var fecha: String
    
    init(id: Int, idusuario: Int, idplanblockdeta: Int, completado: Int, titulo: String, fecha: String) {
        self.id = id
        self.idusuario = idusuario
        self.idplanblockdeta = idplanblockdeta
        self.completado = completado
        self.titulo = titulo
        self.fecha = fecha
    }
    
}
