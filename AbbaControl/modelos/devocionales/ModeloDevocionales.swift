//
//  ModeloDevocionales.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 19/3/24.
//

import Foundation

class ModeloDevocionales{
    
    var imagen: String
    var titulo: String
    var subtitulo: String
    var idplan: Int
      
    init(imagen: String, titulo: String, subtitulo: String, idplan: Int) {
        self.imagen = imagen
        self.titulo = titulo
        self.subtitulo = subtitulo
        self.idplan = idplan
    }

    func getImagen() -> String {
        return imagen
    }
    
    func getTitulo() -> String {
        return titulo
    }
    
    func getSubtitulo() -> String {
        return subtitulo
    }
  
    func getIdPlan() -> Int {
        return idplan
    }
    
    
}
