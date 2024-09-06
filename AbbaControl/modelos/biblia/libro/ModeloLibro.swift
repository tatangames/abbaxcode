//
//  ModeloLibro.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 15/3/24.
//

import Foundation

class ModeloLibro{
    
    var tipo: Int
    var estado: Bool
    var titulo: String
    var detalle: [ModeloLibroSub]
    
    init(tipo: Int, estado: Bool, titulo: String, detalle: [ModeloLibroSub]) {
        self.tipo = tipo
        self.estado = estado
        self.titulo = titulo
        self.detalle = detalle
    }
    
    func getTipo() -> Int {
        return tipo
    }
          
    func getEstado() -> Bool {
        return estado
    }
    
    func getTitulo() -> String {
        return titulo
    }
    
    func getDetalle() -> [ModeloLibroSub] {
        return detalle
    }
    
}
