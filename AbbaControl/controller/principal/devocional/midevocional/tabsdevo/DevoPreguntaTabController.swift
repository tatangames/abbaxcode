//
//  DevoPreguntaTabController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 21/3/24.
//

import UIKit
import LZViewPager

class DevoPreguntaTabController: UIViewController, LZViewPagerDelegate, LZViewPagerDataSource {
    
    // PANTALLA QUE CARGA LOS 2 TABS, VISTA DEVOCIONAL, VISTA PREGUNTAS
        
    var id = 0
    var tema = false
    
    private var subController:[UIViewController] = []
    @IBOutlet weak var viewPager: LZViewPager!
    
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
        
        let textoDevo = TextoIdiomaController.localizedString(forKey: "devocional")
        let textoMeditacion = TextoIdiomaController.localizedString(forKey: "meditacion")
        
       
        let vc1 = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "DevoPreguntaTab1Controller") as! DevoPreguntaTab1Controller
        
        vc1.idblockdeta = id
        
        let vc2 = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "DevoPreguntaTab2Controller") as! DevoPreguntaTab2Controller
        
        vc2.idblockdeta = id
        
        vc1.title = textoDevo
        
        vc2.title = textoMeditacion
        
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
    
    
    @IBAction func flechaAtras(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
