//
//  ModeloPlanesOcultar.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 14/3/24.
//

import Foundation

class ModeloPlanesOcultar{
       
    var idplanes: Int
    var nombre: String
    var estado: Bool
    
    init(idplanes: Int, nombre: String, estado: Bool) {
        self.idplanes = idplanes
        self.nombre = nombre
        self.estado = estado
    }
          
    func getIdplanes() -> Int {
        return idplanes
    }
    
    func getNombre() -> String {
        return nombre
    }
    
    func getEstado() -> Bool {
        return estado
    }
}
