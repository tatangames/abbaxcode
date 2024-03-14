//
//  EjemploController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 9/3/24.
//

import UIKit

class EjemploController: UIViewController {

    
    @IBOutlet weak var imgen: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark

        
        
        // Crear un UILabel
        let label = UILabel()
        label.text = "J" // Establece el texto que deseas mostrar
        label.textColor = UIColor.white // Establece el color de texto que desees
        label.textAlignment = .center // Alinea el texto al centro del label
        label.translatesAutoresizingMaskIntoConstraints = false // Desactiva la creación automática de restricciones

        // Agregar el label a la imageView
        imgen.addSubview(label)

        // Establecer restricciones para el label
        label.centerXAnchor.constraint(equalTo: imgen.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: imgen.centerYAnchor).isActive = true
        
        

        imgen .image = UIImage(named: "circulo")?.withRenderingMode(.alwaysTemplate)
        
        
        imgen.tintColor = UIColor.white
    }
    

  

}
