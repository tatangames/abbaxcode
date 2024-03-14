//
//  IdiomasController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 13/3/24.
//

import UIKit
import Toast_Swift

class IdiomasController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var toolbar: UINavigationItem!
    
    @IBOutlet weak var txtTituloApp: UILabel!
    @IBOutlet weak var pickerApp: UIPickerView!
    @IBOutlet weak var txtTextoApp: UILabel!
    
    
    @IBOutlet weak var txtTituloDevo: UILabel!
    @IBOutlet weak var pickerDevo: UIPickerView!
    @IBOutlet weak var txtTextoDevo: UILabel!
    
    

    var styleAzul = ToastStyle()
    
    let modeloIdiomaApp: [ModeloIdioma] = [
    
        ModeloIdioma(id: 1, nombre: TextoIdiomaController.localizedString(forKey: "espanol")),
        ModeloIdioma(id: 2, nombre: TextoIdiomaController.localizedString(forKey: "ingles"))
    ]
    
    let modeloIdiomaDevo: [ModeloIdioma] = [
    
        ModeloIdioma(id: 1, nombre: TextoIdiomaController.localizedString(forKey: "espanol")),
        ModeloIdioma(id: 2, nombre: TextoIdiomaController.localizedString(forKey: "ingles"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        let instanciaTema = TemaController()
        if( instanciaTema.conocerTemaActual() == 1){
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
        
        
        toolbar.title = TextoIdiomaController.localizedString(forKey: "idioma")
        
        txtTituloApp.text = TextoIdiomaController.localizedString(forKey: "interfaz_de_la_aplicacion")
        txtTextoApp.text = TextoIdiomaController.localizedString(forKey: "esta_config_afecta_app")
        
        
        txtTituloDevo.text = TextoIdiomaController.localizedString(forKey: "textos_planes_biblia")
        txtTextoDevo.text = TextoIdiomaController.localizedString(forKey: "esta_config_afecta_planes")
        
        pickerApp.dataSource = self
        pickerApp.delegate = self
        
        pickerDevo.dataSource = self
        pickerDevo.delegate = self
        
        // mover picker Idioma App
        let idAppActual = UserDefaults.standard.getValueIdiomaApp()
        if let index = modeloIdiomaApp.firstIndex(where: { $0.id == idAppActual }) {
                   pickerApp.selectRow(index, inComponent: 0, animated: true)
        }
    }
    
    
    
    
    @IBAction func flechaAtras(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func cambioIdiomaApp(id: Int){
                        
        let titulo = TextoIdiomaController.localizedString(forKey: "idioma_actualizado")
        let txtMsg = TextoIdiomaController.localizedString(forKey: "para_aplicar_efectos_se_debe_reiniciar")
                
        // guardar idioma App
        UserDefaults.standard.setValueIdiomaApp(value: id)
        
                
        let alert = UIAlertController(title: titulo, message: txtMsg, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            
            self.reiniarApp()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func reiniarApp(){
        guard let window = UIApplication.shared.windows.first else { return }
              let storyboard = UIStoryboard(name: "Main", bundle: nil)
              window.rootViewController = storyboard.instantiateInitialViewController()
    }
    
    func actualizarIdiomaDevo(id: Int){
        
        UserDefaults.standard.setValueIdiomaTexto(value: id)
        
        let mensaje = TextoIdiomaController.localizedString(forKey: "actualizado")
        
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
    

}

extension IdiomasController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == pickerApp {
            return modeloIdiomaApp.count
        }
        else if pickerView == pickerDevo {
            return modeloIdiomaDevo.count
        }
      
        return 0
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let containerView = UIView()
        
        if pickerView == pickerApp {
            
            let label = UILabel(frame: CGRect(x: 40, y: 0, width: pickerView.frame.width - 40, height: 30))
            label.text = modeloIdiomaApp[row].nombre
            containerView.addSubview(label)
            
        } else if pickerView == pickerDevo {
            
            let label = UILabel(frame: CGRect(x: 40, y: 0, width: pickerView.frame.width - 40, height: 30))
            label.text = modeloIdiomaDevo[row].nombre
            containerView.addSubview(label)
        }
       
        return containerView
    }
        
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerApp {
            let selectedApp = modeloIdiomaApp[row]
            cambioIdiomaApp(id: selectedApp.getId())
            
        } else if pickerView == pickerDevo {
            let selectedDevo = modeloIdiomaDevo[row]
            actualizarIdiomaDevo(id: selectedDevo.getId())
        }
    }
    
    
    
}
