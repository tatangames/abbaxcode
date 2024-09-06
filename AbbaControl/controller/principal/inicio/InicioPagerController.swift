//
//  InicioPagerController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 21/3/24.
//

import UIKit
import LZViewPager

class InicioPagerController: UIViewController, LZViewPagerDelegate, LZViewPagerDataSource , ThemeChangeDelegate{
    
    
    func didChangeTheme(to theme: Bool) {
      llamadaRecargarVistaEnController()
    }
    
    
    func llamadaRecargarVistaEnController() {
      
        if let viewController = subController[0] as? InicioTab1Controller {
            viewController.recargarVista()
        }
        
        if let viewController = subController[1] as? InicioTab2Controller {
            viewController.recargarVista()
        }
    }
    
    
    

    
    @IBOutlet weak var viewPager: LZViewPager!
    var tema = false
    
    private var subController:[UIViewController] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let instanciaTema = TemaController()
        if( instanciaTema.conocerTemaActual() == 1){
            tema = true
        }

        viewPagerProperties()
    }
    

   
    func viewPagerProperties(){
        viewPager.delegate = self
        viewPager.dataSource = self
        viewPager.hostController = self
        
        let textoInicio = TextoIdiomaController.localizedString(forKey: "inicio")
        let textoComunidad = TextoIdiomaController.localizedString(forKey: "comunidad")
        
        let vc1 = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "InicioTab1Controller") as! InicioTab1Controller
        
        let vc2 = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "InicioTab2Controller") as! InicioTab2Controller
        
        vc1.title = textoInicio
        vc2.title = textoComunidad
                
        subController = [vc1, vc2]
                
        viewPager.reload()
       
        if let tabBarController = tabBarController {
               tabBarController.tabBar.barTintColor = UIColor.white // Color deseado
           }
    }

    
    
    func numberOfItems() -> Int {
        return self.subController.count
    }
    
    func controller(at index: Int) -> UIViewController {
        return subController[index]
    }
    
    func button(at index: Int) -> UIButton {
        let button = UIButton()
        
        //  button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        
        if(tema){
            button.backgroundColor = .white
        }else{
            button.backgroundColor = .black
        }
        
        // Aquí defines el color del texto dependiendo del tema
         let textColor: UIColor = tema ? .black : .white

         // Configurar el texto del botón
         let title = subController[index].title ?? ""
         let attributes: [NSAttributedString.Key: Any] = [
             .font: UIFont.systemFont(ofSize: 16), // Tamaño de la letra
             .foregroundColor: textColor // Color del texto
         ]
         let attributedTitle = NSAttributedString(string: title, attributes: attributes)
         button.setAttributedTitle(attributedTitle, for: .normal)
             
        return button
    }
    
    
}
