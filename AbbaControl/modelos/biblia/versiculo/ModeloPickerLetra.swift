//
//  ModeloPickerLetra.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 18/3/24.
//

import Foundation

class ModeloPickerLetra{
    
    var id: Int
    var titulo: String
    
    init(id: Int, titulo: String) {
        self.id = id
        self.titulo = titulo
    }
    
    func getId() -> Int {
        return id
    }
     
    func getTitulo() -> String {
        return titulo
    }

}
