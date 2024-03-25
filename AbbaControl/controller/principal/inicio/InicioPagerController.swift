//
//  InicioPagerController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 21/3/24.
//

import UIKit
import LZViewPager

class InicioPagerController: UIViewController, LZViewPagerDelegate, LZViewPagerDataSource {
 

    func reset() {
          // Limpiar subvistas y propiedades
          subController.removeAll()
       
        
        let vc1 = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "InicioTab1Controller") as! InicioTab1Controller
        let vc2 = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "InicioTab2Controller") as! InicioTab2Controller
        
        vc1.title = "INICIO"
        vc2.title = "COMUNIDAD"
        
        
        subController = [vc1, vc2]
        viewPager.reload()
      }

    
    
    
    
    @IBOutlet weak var viewPager: LZViewPager!
    var tema = false
    
    private var subController:[UIViewController] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewPagerProperties()
    }
    

   
    func viewPagerProperties(){
        viewPager.delegate = self
        viewPager.dataSource = self
        viewPager.hostController = self
        
   
        
        let vc1 = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "InicioTab1Controller") as! InicioTab1Controller
        let vc2 = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "InicioTab2Controller") as! InicioTab2Controller
        
        vc1.title = "INICIO"
        vc2.title = "COMUNIDAD"
        
        
        subController = [vc1, vc2]
        viewPager.reload()
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
      //      button.backgroundColor = .white
                  
             /*let btnIniciarAtributo = NSAttributedString(string: "", attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                NSAttributedString.Key.foregroundColor: UIColor.black,
             ])
                         
            button.setAttributedTitle(btnIniciarAtributo, for: .normal)*/
        }else{
            button.backgroundColor = .black
    
                  
            /* let btnIniciarAtributo = NSAttributedString(string: "", attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                NSAttributedString.Key.foregroundColor: UIColor.white,
             ])
                         
            button.setAttributedTitle(btnIniciarAtributo, for: .normal)*/
            
        }
        
        
        
        
      /*  let btnIniciarPress = NSAttributedString(string: "", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.gray,
        ])

        button.setAttributedTitle(btnIniciarPress, for: .highlighted)*/
        
        
        
        return button
    }
    
    /*func colorForIndicator(at index: Int) -> UIColor {
        return .darkGray
    }**/
    
}
