//
//  AjustesInController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 27/3/24.
//


import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import RxSwift
import Toast_Swift



protocol ThemeChangeDelegateIn: AnyObject {
    func didChangeThemeIn(to theme: Bool)
}


class AjustesInController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    weak var bibliaControllerDelegateIn: ThemeChangeDelegateIn?
  
    
    func cambiarTema(_ tema: Bool) {
            // Lógica para cambiar el tema aquí
            bibliaControllerDelegateIn?.didChangeThemeIn(to: tema)
        }
    
    
    func pasarDatosProtocol(data: Bool) {
        if(data){
            tableView.isHidden = true
            completar()
        }
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: [ModeloAjustes] = []
 
    
    var tema = false
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    
    var letra = ""
    var nombre = ""
    
    let TIPOTITULO = 1
    let TIPOPERFIL = 2
    let TIPOOPCIONES = 3
    
    var unaVezCrearModelo = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let instanciaTema = TemaController()
        if( instanciaTema.conocerTemaActual() == 1){
            tema = true
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
        
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
              
        completar()
        
        if let tabBarController = tabBarController {
               tabBarController.tabBar.barTintColor = UIColor.white // Color deseado
           }
    }
    

    func recargarTableView(){
        tableView.reloadData()
    }
    
    func mensajeSinConexion(){
        let msg = TextoIdiomaController.localizedString(forKey: "sin_conexion_a_internet")
        mensajeToastAzul(mensaje: msg)
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
  
    
  
    
    func completar(){
        
        if(unaVezCrearModelo){
            items = [
                
                ModeloAjustes(tipo: TIPOTITULO, id: 1, nombre: TextoIdiomaController.localizedString(forKey: "ajustes"), nombreImagen: ""),
                            
                ModeloAjustes(tipo: TIPOOPCIONES, id: 1, nombre: TextoIdiomaController.localizedString(forKey: "idioma"), nombreImagen: "ic_mundo"),
                
                ModeloAjustes(tipo: TIPOOPCIONES, id: 2, nombre: TextoIdiomaController.localizedString(forKey: "temas"), nombreImagen: "ic_tema"),
               
                ModeloAjustes(tipo: TIPOOPCIONES, id: 3, nombre: TextoIdiomaController.localizedString(forKey: "iniciar_sesion"), nombreImagen: "ic_cerrar"),
            ]
        }
        
        unaVezCrearModelo = false
        tableView.reloadData()
        tableView.isHidden = false
    }
    
    
    

    // METODOS TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return items.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                 
        let item = items[indexPath.row]
        
        
        if item.tipo == TIPOTITULO {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! AjusteCell1TableView

            cell.txtTitulo.text = item.nombre
            cell.selectionStyle = .none
            
            return cell
        }
        
        else if item.tipo == TIPOOPCIONES {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! AjusteInCell3TableView
            
            cell.txtTipo.text = item.nombre
            cell.imgTipo.image = UIImage(named: item.nombreImagen)?.withRenderingMode(.alwaysTemplate)
            
            if(tema){
                cell.imgTipo.tintColor = UIColor.white
            }else{
                cell.imgTipo.tintColor = UIColor.black
            }
            
            cell.selectionStyle = .none
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItem = items[indexPath.row]
        
        opciones(tipo: selectedItem.getId())
    }

        
    func opciones(tipo: Int){
        
        if(tipo == 1){
            vistaIdiomas()
        }
        else if(tipo == 2){
            preguntaTema()
        }
        else if(tipo == 3){
            // cerrar sesion
            preguntaSalir()
        }
    }
    
    
    
    
    func preguntaTema(){
       
        let titulo = TextoIdiomaController.localizedString(forKey: "cambiar_tema")
        var mensaje = ""
        if(tema){
            mensaje = TextoIdiomaController.localizedString(forKey: "tema_claro")
        }else{
            mensaje = TextoIdiomaController.localizedString(forKey: "tema_oscuro")
        }
        
        let txtSi = TextoIdiomaController.localizedString(forKey: "si")
        
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            
            
        }))
        
        alert.addAction(UIAlertAction(title: txtSi, style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            
            self.cambiarTemaApp()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
 
    func cambiarTemaApp(){
        
        var valorTema = false
        
        if(tema){
            // si era tema oscuro se pasara a claro
            UserDefaults.standard.setValueEstiloTema(value: 0)
            overrideUserInterfaceStyle = .light
        }else{
            // si era tema claro se pasara a oscuro
            UserDefaults.standard.setValueEstiloTema(value: 1)
            overrideUserInterfaceStyle = .dark
            valorTema = true
        }
        
        if(valorTema){
            tema = true
        }else{
            tema = false
        }
                
        // actualizar de nuevo la tabla
        tableView.isHidden = true
       
        completar()
        cambiarTema(tema)
    }
    
    
    func preguntaSalir(){
        
        let vista : LoginRegisterController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginRegisterController") as! LoginRegisterController
        
        self.present(vista, animated: true, completion: nil)
    }
  
 
    
    
    
   
    
    func vistaIdiomas(){
        let vista : IdiomasController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "IdiomasController") as! IdiomasController
        
        self.present(vista, animated: true, completion: nil)
    }
    
    

   
}
