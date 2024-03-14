//
//  NotificacionesController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 14/3/24.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import RxSwift
import Toast_Swift
import SDWebImage

class NotificacionesController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tema = false
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var toolbar: UINavigationItem!
    
    var items: [ModeloNotificacion] = []
    
    // Paginacion
    var currentPage = 1
    var isLoading = false
    var reachedLastPage = false
    var puedeBuscarMas = true
    
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
        //tableView.separatorStyle = .none
        
        toolbar.title = TextoIdiomaController.localizedString(forKey: "notificaciones")
                
        apiSolicitarDatos()
    }
        
    func apiSolicitarDatos(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiListadoNotificaciones
        
        let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
        let idiomaPlan = UserDefaults.standard.getValueIdiomaTexto()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "idiomaplan": idiomaPlan ?? 1,
            "iduser": iduser ?? 0,
            "page": currentPage,
            "limit": 15
        ]
        
        Observable<Void>.create { observer in
            let request = AF.request(encodeURL, method: .post, parameters: parameters, headers: headers)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        
                        //paginacion
                        self.isLoading = false
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        let json = JSON(data)
                        
                       // self.tableView.isHidden = false
                        
                        if let successValue = json["success"].int {
                            
                            if(successValue == 1){
                                
                                let hayInfo = json["hayinfo"].intValue
                                
                                if(hayInfo == 1){
                                    
                                    if let listado = json["listado"].dictionary,
                                       let currentPage = listado["current_page"]?.int,
                                       let dataArray = listado["data"]?.array {
                                        // Procesar los datos de notificaciones
                                        
                                        for notificationJSON in dataArray {
                                            
                                            let imagen = notificationJSON["imagen"].string ?? ""
                                            let hayImagen = notificationJSON["hayimagen"].int ?? 0
                                            let nombre = notificationJSON["titulo"].string ?? ""
                                            
                                            let notification = ModeloNotificacion(hayimagen: hayImagen, imagen: imagen, nombre: nombre)
                                            self.items.append(notification)
                                            
                                        }
                                        // Actualizar la tabla u otro UI según sea necesario
                                        self.currentPage = currentPage + 1
                                        self.tableView.reloadData()
                                    } // end dataArray
                                }else{
                                    // aqui se mostrara no hay notificaciones
                                    let notification = ModeloNotificacion(hayimagen: 0, imagen: "", nombre: "")
                                    self.items.append(notification)
                                    
                                    self.puedeBuscarMas = false
                                    self.tableView.reloadData()
                                }
              
                              
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
    
    func recargarTableView(){
        tableView.reloadData()
    }
    
    func mensajeSinConexion(){
        mensajeToastAzul(mensaje: "Sin conexion")
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
  
    @IBAction func flechaAtras(_ sender: Any) {
        salir()
    }
    
    func salir(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    // METODOS TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
       return items.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                 
        let selectedItem = items[indexPath.row]
        
        if(puedeBuscarMas){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! NotificacionesCell1TableView
            
            if(selectedItem.getHayImagen() == 1){
                
                let union = baseUrlImagen+selectedItem.getImagen()
          
                    cell.imgNoti.sd_setImage(with: URL(string: "\(union)"), placeholderImage: UIImage(named: "fotodefecto"))
                    cell.imgNoti.isHidden = false
                
            }else{
                
                cell.imgNoti.image = UIImage(named: "ic_notificacion")?.withRenderingMode(.alwaysTemplate)
               
                if(tema){
                    cell.imgNoti.tintColor = UIColor.white
                }else{
                    cell.imgNoti.tintColor = UIColor.black
                }
            }
            cell.txtNoti.numberOfLines = 0
            cell.txtNoti.text = selectedItem.getNombre()
            
            cell.selectionStyle = .none
            
            return cell

            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! NotificacionesCell2TableView
            
            cell.txtNombre.text = TextoIdiomaController.localizedString(forKey: "no_hay_notificaciones")
            
            cell.selectionStyle = .none
            
            return cell

            
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == items.count - 1 {
            // El usuario llegó al final de la tabla, carga más datos
            if(puedeBuscarMas){
                apiSolicitarDatosPaginate()
            }
        }
    }
        
    
    func apiSolicitarDatosPaginate(){
        
        // paginacion
        guard !isLoading && !reachedLastPage else { return }
               isLoading = true
        
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiListadoNotificaciones
        
        let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
        let idiomaPlan = UserDefaults.standard.getValueIdiomaTexto()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "idiomaplan": idiomaPlan ?? 1,
            "iduser": iduser ?? 0,
            "page": currentPage,
            "limit": 15
        ]
        
        Observable<Void>.create { observer in
            let request = AF.request(encodeURL, method: .post, parameters: parameters, headers: headers)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        
                        //paginacion
                        self.isLoading = false
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        let json = JSON(data)
                        
                       // self.tableView.isHidden = false
                        
                        if let successValue = json["success"].int {
                            
                            if(successValue == 1){
                                                               
                                if let listado = json["listado"].dictionary,
                                   let currentPage = listado["current_page"]?.int,
                                   let dataArray = listado["data"]?.array {
                                    // Procesar los datos de notificaciones
                                    
                                    
                                    if dataArray.isEmpty {
                                           // No hay más datos, llegamos al final de la paginación
                                           self.reachedLastPage = true
                                       } else {
                                           for notificationJSON in dataArray {
                                               
                                               let imagen = notificationJSON["imagen"].string ?? ""
                                               let hayImagen = notificationJSON["hayimagen"].int ?? 0
                                               let nombre = notificationJSON["titulo"].string ?? ""
                                               
                                               let notification = ModeloNotificacion(hayimagen: hayImagen, imagen: imagen, nombre: nombre)
                                               self.items.append(notification)
                                               
                                           }
                                           // Actualizar la tabla u otro UI según sea necesario
                                           self.currentPage = currentPage + 1
                                           self.tableView.reloadData()
                                       }
                                    
                                   
                                } // end dataArray
                                              
                              
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
    
}
