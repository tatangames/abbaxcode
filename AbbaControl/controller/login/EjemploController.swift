//
//  EjemploController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 9/3/24.
//

import UIKit

class EjemploController: UIViewController {

    
    @IBOutlet weak var texto: UILabel!
    @IBOutlet weak var imgen: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let font = UIFont(name: "Chango-Regular", size: 17.0) {
                   texto.font = font
            print("texto cargado")
               } else {
                   print("No se pudo cargar la fuente Chango-Regular")
               }

        
      
    }
    

  

}
