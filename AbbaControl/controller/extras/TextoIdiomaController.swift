//
//  TextoIdiomaController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 10/3/24.
//

import Foundation
class TextoIdiomaController {
    
    
        static func localizedString(forKey key: String) -> String {
            var language = ""
            if UserDefaults.standard.object(forKey: "IDIOMAAPP") != nil {
                
                let selectedLanguage = UserDefaults.standard.integer(forKey: "IDIOMAAPP")
                
                if(selectedLanguage == 1){
                    language = "es"
                }
                else if(selectedLanguage == 2){
                    language = "en"
                }else{
                    // defecto
                    language = "es"
                }
            } else {
                language = "es"
            }
                     
            guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
                  let bundle = Bundle(path: path) else {
                // Si no se encuentra el bundle para el idioma, se devuelve vacio
                return ""
            }
        
        return NSLocalizedString(key, tableName: nil, bundle: bundle, value: "", comment: "")
    }
    
    

        
}
