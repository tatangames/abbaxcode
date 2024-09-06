//
//  BibliaController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 15/3/24.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import RxSwift
import Toast_Swift
import SDWebImage


class BibliaController: UIViewController, UITableViewDelegate, UITableViewDataSource, ThemeChangeDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var tema = false
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    
    var items: [ModeloBiblia] = []
    
    var tituloBiblia = ""
    
    
    func didChangeTheme(to theme: Bool) {
         
        if tableView == nil {
            return
        }
        
        tableView.isHidden = true
        items.removeAll()
        tema = theme
        
        if(theme){
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
        
        apiSolicitarDatos()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let instanciaTema = TemaController()
        if( instanciaTema.conocerTemaActual() == 1){
            tema = true
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
        
        tituloBiblia = TextoIdiomaController.localizedString(forKey: "biblia")
        
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        apiSolicitarDatos()
        
        if let tabBarController = tabBarController {
               tabBarController.tabBar.barTintColor = UIColor.white // Color deseado
           }
    }
    
    func apiSolicitarDatos(){
        
        
        // PARA TITULO DE PANTALLA QUE DICE: BIBLIA
        let informacion = ModeloBiblia(tipo: 1, id: 0, nombre: "", imagen: "")
        self.items.append(informacion)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiListadoBiblias
        
        let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
        let idioma = UserDefaults.standard.getValueIdiomaApp()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "iduser": iduser ?? 0,
            "idioma": idioma ?? 1
        ]
        
        Observable<Void>.create { observer in
            let request = AF.request(encodeURL, method: .post, parameters: parameters, headers: headers)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        let json = JSON(data)
                        
                        self.tableView.isHidden = false
                        
                        if let successValue = json["success"].int {
                            
                            if(successValue == 1){
                                
                                json["listado"].array?.forEach({ (dataArray) in
                                    
                                    let id = dataArray["id"].int ?? 0
                                    let nombre = dataArray["titulo"].string ?? ""
                                    let imagen = dataArray["imagen"].string ?? ""
                                    let informacion = ModeloBiblia(tipo: 2, id: id, nombre: nombre, imagen: imagen)
                                    self.items.append(informacion)
                                })
                          
                                self.tableView.reloadData()
                              
                            }else{
                                self.mensajeSinConexion()
                            }
                            
                        }else{
                            self.mensajeSinConexion()
                        }
                        
                    case .failure(_):
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.mensajeSinConexion()
                        //observer.onError(error)
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
        .retry() // Retry indefinitely
        .subscribe(onNext: {
            // Hacer algo cuando la solicitud tenga éxito
            
        }, onError: { error in
            // Manejar el error de la solicitud
            MBProgressHUD.hide(for: self.view, animated: true)
        })
        .disposed(by: disposeBag)
    }
  
    
    func mensajeSinConexion(){
        let msg = TextoIdiomaController.localizedString(forKey: "sin_conexion_a_internet")
        mensajeToastAzul(mensaje: msg)
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
    
    
    
    // METODOS TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
       return items.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                 
        let selectedItem = items[indexPath.row]
        
        if(selectedItem.getTipo() == 1){
            
            // TITULO DE PANTALLA
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! BibliaCell1TableView
            
            cell.txtNombre.text = tituloBiblia
                       
            cell.selectionStyle = .none
            
            return cell
            
        }else if(selectedItem.getTipo() == 2){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! BibliaCell2TableView
                   
            cell.txtNombre.numberOfLines = 0
            cell.txtNombre.text = selectedItem.getNombre()
            let union = baseUrlImagen+selectedItem.imagen
            cell.imgBiblia.sd_setImage(with: URL(string: "\(union)"), placeholderImage: UIImage(named: "fotodefecto"))
            
            cell.selectionStyle = .none
            
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! BibliaCell3TableView
            
            cell.txtNombre.numberOfLines = 0
            cell.txtNombre.text = TextoIdiomaController.localizedString(forKey: "no_hay_biblia_disponibles")
                        
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItem = items[indexPath.row]
        
        if(selectedItem.getId() != 0){
            vistaLibros(idlibro: selectedItem.getId())
        }
    }
    
    
    func vistaLibros(idlibro: Int){
        
        let vista : LibrosBibliaController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "LibrosBibliaController") as! LibrosBibliaController
        
        vista.idbiblia = idlibro
        
        self.present(vista, animated: true, completion: nil)
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}


