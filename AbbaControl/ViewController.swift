//
//  ViewController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 9/3/24.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var boton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func boton(_ sender: Any) {
        
        
        let vistaSiguiente : EjemploController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EjemploController") as! EjemploController
               
        self.present(vistaSiguiente, animated: true, completion: nil)
        
    }
    


}

