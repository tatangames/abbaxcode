//
//  ModeloInicioRacha.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 24/3/24.
//

import Foundation

class ModeloInicioRacha{
    
    var diasesteanio: Int
    var diasconcecutivos: Int
    var nivelrachaalta: Int
    var domingo: Int
    var lunes: Int
    var martes: Int
    var miercoles: Int
    var jueves: Int
    var viernes: Int
    var sabado: Int
    
    init(diasesteanio: Int, diasconcecutivos: Int, nivelrachaalta: Int, domingo: Int, lunes: Int, martes: Int, miercoles: Int, jueves: Int, viernes: Int, sabado: Int) {
        self.diasesteanio = diasesteanio
        self.diasconcecutivos = diasconcecutivos
        self.nivelrachaalta = nivelrachaalta
        self.domingo = domingo
        self.lunes = lunes
        self.martes = martes
        self.miercoles = miercoles
        self.jueves = jueves
        self.viernes = viernes
        self.sabado = sabado
    }
    
    
    
}
