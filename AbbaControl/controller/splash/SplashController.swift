//
//  SplashController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 9/3/24.
//

import UIKit

class SplashController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // buscando idioma del telefono por defecto
        if(UserDefaults.standard.getValueIdiomaTelefono() == nil){
                       
            let deviceLanguage = Locale.preferredLanguages.first
         
            
            if let deviceLanguage = deviceLanguage{
                
                if deviceLanguage.hasPrefix("es")  {
                   // espanol
                    UserDefaults.standard.setValueIdiomaApp(value: 1)
                    UserDefaults.standard.setValueIdiomaTexto(value: 1)
                }
                else{
                  // ingles
                    UserDefaults.standard.setValueIdiomaApp(value: 2)
                    UserDefaults.standard.setValueIdiomaTexto(value: 2)
                }
            }else{
                
                // espanol defecto
                UserDefaults.standard.setValueIdiomaApp(value: 1)
                UserDefaults.standard.setValueIdiomaTexto(value: 1)
            }
            
            UserDefaults.standard.setValueIdiomaTelefono(value: 1)
            
        }
        
        // NO NECESITO ELSE, YA QUE CADA CADENA DE TEXTO SE OBTIENE DE UNA CLASE
        
           

        // TIMER
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                       
           if let clienteID = UserDefaults.standard.getValueIdUsuario(), !clienteID.isEmpty {
             
               let vista : TabBarPrincipalController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "TabBarPrincipalController") as! TabBarPrincipalController
                       
               self.present(vista, animated: true, completion: nil)
           }
           else {
            
               let vista : LoginRegisterController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginRegisterController") as! LoginRegisterController
                       
               self.present(vista, animated: true, completion: nil)
            }
        }
    }
    

    
    
    

}
