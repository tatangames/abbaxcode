//
//  ValidarTexto.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 11/3/24.
//

import Foundation

class ValidarTexto {
    
    // VALIDAR ESCRTURA DE CORREO
    func validarCorreoElectronico(texto: String) -> Bool {
        do {
            if try NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$", options: .caseInsensitive).firstMatch(in: texto, options: [], range: NSRange(location: 0, length: texto.count)) == nil {
                return false
            }
        } catch {
            return false
        }
        return true
    }
    
    
    // VALIDAR ENTRADA ES REQUERIDA
    func validarEntradaRequerida(texto: String) -> Int {
        
        if(texto.count == 0){
            return 1
        }
        
        return 2
    }
    
    // VALIDAR 8 CARACTERES
    func validar8Caracteres(texto: String) -> Int {
             
        if(texto.count < 8){
            return 1
        }

        return 2
    }
    
    
    // VALIDACION DE 100 CARACTERES
    func validar100Caracteres(texto: String) -> Int {
             
        if(texto.count > 100){
            return 1
        }

        return 2
    }
    
    
    // VALIDACION DE INGRESO DE CONTRASEÑA
    
    func validarPassword6minCaracteres(texto: String) -> Int {
             
        if(texto.count < 6){
            return 1
        }
                
        return 2
    }
    
    
    
 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // validacion de 50 caracteres
    func validar50Caracteres(texto: String) -> Int {
       
       if(texto.count == 0){
           return 1
       }
       
       if(texto.count > 50){
           return 2
       }
       return 3
    }
    
    func validar3Caracteres(texto: String) -> Int {
         
         if(texto.count == 0){
             return 1
         }
         
        if(texto.count < 3){
             return 2
         }
         return 3
    }
    
  
    
    // validacion de 400 caracteres
     func validar400Caracteres(texto: String) -> Int {
         
         if(texto.count == 0){
             return 1
         }
         
         if(texto.count > 400){
             return 2
         }
         return 3
     }
    
    // validacion de 500 caracteres
    func validar500Caracteres(texto: String) -> Int {
        
        if(texto.count == 0){
            return 1
        }
        
        if(texto.count > 500){
            return 2
        }
        return 3
    }
    
    // validacion de 2000 caracteres
    func validar2000Caracteres(texto: String) -> Int {
          
          if(texto.count == 0){
              return 1
          }
          
          if(texto.count > 2000){
              return 2
          }
          return 3
     }
    
    // validacion de password

    
    // validacion de numero telefonico
    func validar20Caracteres(texto: String) -> Int {
        
        if(texto.count == 0){
            return 1
        }
        
        if(texto.count > 20){
            return 2
        }
        
        return 3
    }
    
    // validar entrada de texto solamente
    func validarEntrada(texto: String) -> Int {
        
        if(texto.count == 0){
            return 1
        }
        
        return 2
    }
}
