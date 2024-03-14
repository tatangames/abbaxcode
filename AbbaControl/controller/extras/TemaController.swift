//
//  TemaController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 10/3/24.
//

import Foundation

class TemaController {
    
    func conocerTemaActual() -> Int {
        if(UserDefaults.standard.getValueEstiloTema() == 1){
            return 1
        }
        else{
            // defecto si es nil o tema light
            return 0
        }
        
    }
    
    
}
