//
//  DatosGuardados.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 10/3/24.
//

import Foundation
extension UserDefaults{
    
    
    //******* ID CLIENTE *********
    
    // GUARDAR ID CLIENTE
    func setValueIdCliente(value: String?){
        if(value != nil){
            UserDefaults.standard.set(value, forKey: "ID")
        }else{
            UserDefaults.standard.removeObject(forKey: "ID")
        }
        
        UserDefaults.standard.synchronize()
    }
    
    // OBTENER EL ID DEL CLIENTE
    func getValueIdUsuario() -> String? {
        return UserDefaults.standard.value(forKey: "ID") as? String
    }
    
    
    
    //******* TOKEN DEL CLIENTE *********
    
    // GUARDAR TOKEN CLIENTE
    func setValueTokenCliente(value: String?){
        if(value != nil){
            UserDefaults.standard.set(value, forKey: "TOKEN")
        }else{
            UserDefaults.standard.removeObject(forKey: "TOKEN")
        }
        
        UserDefaults.standard.synchronize()
    }
    
    // OBTENER EL ID DEL CLIENTE
    func getValueTokenUsuario() -> String? {
        return UserDefaults.standard.value(forKey: "TOKEN") as? String
    }
    
    
    
    //******* TEMA ELEGIDO DARK O LIGHT *********
    
    // GUARDAR TEMA
    func setValueEstiloTema(value: Int?){
        if(value != nil){
            UserDefaults.standard.set(value, forKey: "TEMA")
        }else{
            UserDefaults.standard.removeObject(forKey: "TEMA")
        }
        
        UserDefaults.standard.synchronize()
    }
    
    // OBTENER EL TEMA
    func getValueEstiloTema() -> Int? {
        return UserDefaults.standard.value(forKey: "TEMA") as? Int
    }
    
    
    //******* IDIOMA DE LA APLICACION *********
            
    
    func setValueIdiomaApp(value: Int?){
        if(value != nil){
            UserDefaults.standard.set(value, forKey: "IDIOMAAPP")
        }else{
            UserDefaults.standard.removeObject(forKey: "IDIOMAAPP")
        }
        
        UserDefaults.standard.synchronize()
    }
    
   
    func getValueIdiomaApp() -> Int? {
        return UserDefaults.standard.value(forKey: "IDIOMAAPP") as? Int
    }
    
    
    
    
  
    
    //******* TIPO DE LERA PARA LEER DEVOCIOANLES *********
    
    
    func setValueTipoLetraTexto(value: Int?){
        if(value != nil){
            UserDefaults.standard.set(value, forKey: "TIPOTEXTO")
        }else{
            UserDefaults.standard.removeObject(forKey: "TIPOTEXTO")
        }
        
        UserDefaults.standard.synchronize()
    }
    
    
    func getValueTipoLetraTexto() -> Int? {
        return UserDefaults.standard.value(forKey: "TIPOTEXTO") as? Int
    }
    
    
    
    
    
    //*** SI EL IDIOMA YA FUE CAMBIADO, PARA NO PREGUNTAR IDIOMA TELEFONO POR DEFECTO *********
        
    func setValueIdiomaTelefono(value: Int?){
        if(value != nil){
            UserDefaults.standard.set(value, forKey: "IDIOMACEL")
        }else{
            UserDefaults.standard.removeObject(forKey: "IDIOMACEL")
        }
        
        UserDefaults.standard.synchronize()
    }
    
    
    func getValueIdiomaTelefono() -> Int? {
        return UserDefaults.standard.value(forKey: "IDIOMACEL") as? Int
    }
    
    
    //*** TAMANO DE LETRA PARA CUESTIONARIOS *********
        
    func setValueTamanoLetraCuestionario(value: Int?){
        if(value != nil){
            UserDefaults.standard.set(value, forKey: "TAMANOLETRA")
        }else{
            UserDefaults.standard.removeObject(forKey: "TAMANOLETRA")
        }
        
        UserDefaults.standard.synchronize()
    }
    
    
    func getValueTamanoLetraCuestionario() -> Int? {
        return UserDefaults.standard.value(forKey: "TAMANOLETRA") as? Int
    }
    
    
    
    func borrarPreferencias(){
        UserDefaults.standard.removeObject(forKey: "ID")
        UserDefaults.standard.removeObject(forKey: "TOKEN")
    }
    
}
