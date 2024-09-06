//
//  ModeloGrupoInicio.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 24/3/24.
//

import Foundation

class ModeloGrupoInicio{
    
    var tipo: Int
    var arrayVideos: [ModeloInicioVideos]
    var arrayImagenes: [ModeloInicioImagenes]
    var arrayInsignias: [ModeloInicioInsignias]
    var arrayRedes: [ModeloInicioRedes]
    var arrayRecursos: [ModeloRecursos]
    
    init(tipo: Int, arrayVideos: [ModeloInicioVideos], arrayImagenes: [ModeloInicioImagenes], arrayInsignias: [ModeloInicioInsignias], arrayRedes: [ModeloInicioRedes], arrayRecursos: [ModeloRecursos]) {
        self.tipo = tipo
        self.arrayVideos = arrayVideos
        self.arrayImagenes = arrayImagenes
        self.arrayInsignias = arrayInsignias
        self.arrayRedes = arrayRedes
        self.arrayRecursos = arrayRecursos
    }
}
