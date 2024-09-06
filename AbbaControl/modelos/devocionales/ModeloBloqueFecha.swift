//
//  ModeloBloqueFecha.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 20/3/24.
//

class ModeloBloqueFecha{
    
    var id: Int
    var textoPersonalizado: String
    var detalle: [ModeloBloqueFechaSub]

    init(id: Int, textoPersonalizado: String, detalle: [ModeloBloqueFechaSub]) {
        self.id = id
        self.textoPersonalizado = textoPersonalizado
        self.detalle = detalle
    }
}
