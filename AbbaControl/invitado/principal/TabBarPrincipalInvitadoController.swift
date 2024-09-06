//
//  TabBarPrincipalInvitadoController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 26/3/24.
//

import UIKit

class TabBarPrincipalInvitadoController: UITabBarController, UITabBarControllerDelegate {
    
    
    var tema = false
    
    let imgBibliaLight = "biblia_light"
    let imgBibliaDark = "biblia_dark"
    
    let imgAjusteLight = "ajuste_light"
    let imgAjusteDark = "ajuste_dark"
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.delegate = self
      

        let instanciaTema = TemaController()
        if( instanciaTema.conocerTemaActual() == 1){
            tema = false
        }
        
        guard let viewControllers = viewControllers else { return }

           for viewController in viewControllers {
               if let ajustesController = viewController as? AjustesInController {
                  
                   if let bibliaController = viewControllers.first(where: { $0 is BibliaInvitadoController }) as? BibliaInvitadoController {
                       ajustesController.bibliaControllerDelegateIn = bibliaController
                   }
               }
           }
        
        
        cambioMenuBiblia()
        
        
        
        // barra tab color blanco siempre
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().tintColor = UIColor.black
    }
    
 
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
       if tabBarController.selectedIndex == 0 {
            cambioMenuBiblia()
        }
        else{
          cambioMenuAjuste()
        }
        
    }
    
    func fondos(){
       
        // barra tab color blanco siempre
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().tintColor = UIColor.black
    }
        
    
    func cambioMenuBiblia(){
        if let items = tabBar.items {
           
            items[0].image = UIImage(named: imgBibliaDark)?.withRenderingMode(.alwaysTemplate)
            items[1].image = UIImage(named: imgAjusteLight)?.withRenderingMode(.alwaysTemplate)
 
            items[0].title = TextoIdiomaController.localizedString(forKey: "biblia")
            items[1].title = TextoIdiomaController.localizedString(forKey: "ajustes")
        }
    }
    
    func cambioMenuAjuste(){
        
        if let items = tabBar.items {
            items[1].image = UIImage(named: imgAjusteDark)?.withRenderingMode(.alwaysTemplate)
            items[0].image = UIImage(named: imgBibliaLight)?.withRenderingMode(.alwaysTemplate)
        }
    }
    
   

}
