//
//  TabBarPrincipalController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 12/3/24.
//

import UIKit

class TabBarPrincipalController: UITabBarController, UITabBarControllerDelegate {
    
    
    var tema = false
        
    let imgInicioLight = "iglesia_light"
    let imgInicioDark = "iglesia_dark"
    
    let imgDevoLight = "devo_light"
    let imgDevoDark = "devo_dark"
    
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
               if let ajustesController = viewController as? AjusteController {
                  
                   if let bibliaController = viewControllers.first(where: { $0 is BibliaController }) as? BibliaController {
                       ajustesController.bibliaControllerDelegate = bibliaController
                   }
                   
                   if let devocionalController = viewControllers.first(where: { $0 is DevocionalViewController }) as? DevocionalViewController {
                       ajustesController.devocionalControllerDelegate = devocionalController
                    }
                   
                   if let inicioController = viewControllers.first(where: { $0 is InicioPagerController }) as? InicioPagerController {
                       ajustesController.inicioControllerDelegate = inicioController
                    }
                   
               }
           }
        
        
        cambioMenuInicio()
        
        
        // barra tab color blanco siempre
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().tintColor = UIColor.black
    }
    
 
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if tabBarController.selectedIndex == 0 {
           
           cambioMenuInicio()
        }
        else if tabBarController.selectedIndex == 1 {
          cambioMenuDevocional()
        }
        else if tabBarController.selectedIndex == 2 {
            cambioMenuBiblia()
        }
        else if tabBarController.selectedIndex == 3 {
          cambioMenuAjuste()
        }
    }
    
    
    func fondos(){
       
        // barra tab color blanco siempre
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().tintColor = UIColor.black
    }
    
    
    func cambioMenuInicio(){
             
        if let items = tabBar.items {
           
            items[0].image = UIImage(named: imgInicioDark)?.withRenderingMode(.alwaysTemplate)
            items[1].image = UIImage(named: imgDevoLight)?.withRenderingMode(.alwaysTemplate)
            items[2].image = UIImage(named: imgBibliaLight)?.withRenderingMode(.alwaysTemplate)
            items[3].image = UIImage(named: imgAjusteLight)?.withRenderingMode(.alwaysTemplate)
            
            items[0].title = TextoIdiomaController.localizedString(forKey: "inicio")
            items[1].title = TextoIdiomaController.localizedString(forKey: "devocional")
            items[2].title = TextoIdiomaController.localizedString(forKey: "biblia")
            items[3].title = TextoIdiomaController.localizedString(forKey: "ajustes")
        }
        
    }
    
    func cambioMenuDevocional(){
        
        if let items = tabBar.items {
           
            items[1].image = UIImage(named: imgDevoDark)?.withRenderingMode(.alwaysTemplate)
            
            items[0].image = UIImage(named: imgInicioLight)?.withRenderingMode(.alwaysTemplate)
            items[2].image = UIImage(named: imgBibliaLight)?.withRenderingMode(.alwaysTemplate)
            items[3].image = UIImage(named: imgAjusteLight)?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    
    func cambioMenuBiblia(){
        if let items = tabBar.items {
           
            items[2].image = UIImage(named: imgBibliaDark)?.withRenderingMode(.alwaysTemplate)
            
            items[0].image = UIImage(named: imgInicioLight)?.withRenderingMode(.alwaysTemplate)
            items[1].image = UIImage(named: imgDevoLight)?.withRenderingMode(.alwaysTemplate)
            items[3].image = UIImage(named: imgAjusteLight)?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    func cambioMenuAjuste(){
        
        if let items = tabBar.items {
            items[3].image = UIImage(named: imgAjusteDark)?.withRenderingMode(.alwaysTemplate)
            
            items[0].image = UIImage(named: imgInicioLight)?.withRenderingMode(.alwaysTemplate)
            items[1].image = UIImage(named: imgDevoLight)?.withRenderingMode(.alwaysTemplate)
            items[2].image = UIImage(named: imgBibliaLight)?.withRenderingMode(.alwaysTemplate)
           
        }
    }
    
   

}


