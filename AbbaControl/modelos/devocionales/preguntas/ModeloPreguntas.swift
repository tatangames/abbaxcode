//
//  ModeloPreguntas.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 21/3/24.
//

import Foundation

class ModeloPreguntas{
    
    // id, requerido, titulo, texto, idImagenPregunta, imagen
    
    
    var id: Int
    var requerido: Int
    var titulo: String // html
    var texto: String // esto sera modificable si viene texto o si el usuario escribre
    var idImagenPregunta: Int
    var imagen: String
    var tipo: Int
    var textoRequerido: String // texto abajo del edt, para mostrar al usuario y no se resetee al hacer scroll
    var activarTextoRequerido: Bool
   
    init(id: Int, requerido: Int, titulo: String, texto: String, idImagenPregunta: Int, imagen: String, tipo: Int, textoRequerido: String, activarTextoRequerido: Bool) {
        self.id = id
        self.requerido = requerido
        self.titulo = titulo
        self.texto = texto
        self.idImagenPregunta = idImagenPregunta
        self.imagen = imagen
        self.tipo = tipo
        self.textoRequerido = textoRequerido
        self.activarTextoRequerido = activarTextoRequerido
    }
    
    
    
}

