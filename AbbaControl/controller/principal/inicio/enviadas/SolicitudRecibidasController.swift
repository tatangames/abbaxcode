//
//  SolicitudRecibidasController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 23/3/24.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import RxSwift
import Toast_Swift

class SolicitudRecibidasController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolbar: UINavigationItem!
    
    var tema = false
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    var hayInfo = false
    
    var textoNoHayInfo = ""
    var textoFecha = ""
    var textoCorreoDosPuntos = ""
        
    
    var items: [ModeloPendienteSoli] = []
    
    
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
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        textoFecha = TextoIdiomaController.localizedString(forKey: "fecha")
        textoCorreoDosPuntos = TextoIdiomaController.localizedString(forKey: "correo_dos_puntos")
              
        toolbar.title = TextoIdiomaController.localizedString(forKey: "recibidas")
        textoNoHayInfo = TextoIdiomaController.localizedString(forKey: "no_hay_solicitudes_pendientes")
                
        apiBuscarDatos()
    }
    
    
    func apiBuscarDatos(){
                
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiListadoSolicitudPendienteRecibida
        
        let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "iduser": iduser ?? 0
        ]
        
        Observable<Void>.create { observer in
            let request = AF.request(encodeURL, method: .post, parameters: parameters, headers: headers)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                                      
                        MBProgressHUD.hide(for: self.view, animated: true)
                        let json = JSON(data)
                       
                        
                        if let successValue = json["success"].int {
                            
                            if(successValue == 1){
                                
                                let datoInfo = json["hayinfo"].int ?? 0
                                if(datoInfo == 1){
                                   
                                    // hay informacion
                                    
                                    json["listado"].array?.forEach({ (dataArray) in
                                                           
                                        let miid = dataArray["id"].int ?? 0
                                        let mifecha = dataArray["fecha"].string ?? ""
                                        let micorreo = dataArray["correo"].string ?? ""
                                                                             
                                        let bloque2 = ModeloPendienteSoli(tipo: 1, id: miid, fecha: mifecha, correo: micorreo)
                                        
                                        self.items.append(bloque2)
                                    })
                                }else{
                                    
                                    let bloque2 = ModeloPendienteSoli(tipo: 2, id: 0, fecha: "", correo: "")
                                    
                                    self.items.append(bloque2)
                                }
                                
                                
                                self.tableView.isHidden = false
                                self.tableView.reloadData()
                            }
                            else{
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
    
    
    @IBAction func flechaAtras(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
   
    
    // METODOS TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
       return items.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                 
        let selectedItem = items[indexPath.row]
                
        if(selectedItem.tipo == 1){
            
            // BOTONERA
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! PendientesCell1
            
            cell.selectionStyle = .none
              
            // Configura las esquinas redondeadas
            cell.vista.layer.cornerRadius = 20
            // Habilita la máscara de recorte para que las subvistas sigan la forma de las esquinas redondeadas
            cell.vista.clipsToBounds = true
            
            
            if(tema){
                cell.vista.backgroundColor = UIColor.white
            }else{
                cell.vista.backgroundColor = UIColor.systemGray6
            }
            
            
            cell.txtFecha.textColor = .black
            cell.txtCorreo.textColor = .black
                        
            cell.txtFecha.text = textoFecha + ": " + selectedItem.fecha
            cell.txtCorreo.text = textoCorreoDosPuntos + " " + selectedItem.correo
            
           
            return cell
        }
        else if(selectedItem.tipo == 2){
            
            // NO HAY INFORMACION
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! PendientesCell2
           
            cell.txtNombre.text = textoNoHayInfo
               
            cell.selectionStyle = .none
            
            return cell
        }
               
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItem = items[indexPath.row]
        if(selectedItem.tipo == 1){
            opcModal(id: selectedItem.id)
        }
    }
    
    func opcModal(id: Int){
        
        let titulo = TextoIdiomaController.localizedString(forKey: "opciones")
        let msgEliminar = TextoIdiomaController.localizedString(forKey: "eliminar_solicitud")
        let msgAceptar = TextoIdiomaController.localizedString(forKey: "aceptar_solicitud")
        let msgCancelar = TextoIdiomaController.localizedString(forKey: "cancelar")
               
        let alertController = UIAlertController(title: titulo, message: nil, preferredStyle: .alert)
               
               let option1Action = UIAlertAction(title: msgAceptar, style: .default) { (action) in
                                    
                   self.apiAceptarSolicitud(idsoli: id)
               }
               
               let option2Action = UIAlertAction(title: msgEliminar, style: .default) { (action) in
                                      
                   self.apiBorrarSolicitud(idsoli: id)
               }
        
               let option3Action = UIAlertAction(title: msgCancelar, style: .default) { (action) in
              
               }
                    
                    
        
               alertController.addAction(option1Action)
               alertController.addAction(option2Action)
               alertController.addAction(option3Action)
               
               present(alertController, animated: true, completion: nil)
    }
    
    func apiBorrarSolicitud(idsoli: Int){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiBorrarSolicitudPendiente
        
        let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "iduser": iduser ?? 0,
            "idsolicitud": idsoli
        ]
                
        Observable<Void>.create { observer in
            let request = AF.request(encodeURL, method: .post, parameters: parameters, headers: headers)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                                      
                        MBProgressHUD.hide(for: self.view, animated: true)
                        let json = JSON(data)
                                             
                        if let successValue = json["success"].int {
                            
                            if(successValue == 1){
                            
                                self.solicitudActualizada()
                            }
                            else{
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
    
    
    func apiAceptarSolicitud(idsoli: Int){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiAceptarSolicitudRecibida
        
        let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "iduser": iduser ?? 0,
            "idsolicitud": idsoli
        ]
        
        Observable<Void>.create { observer in
            let request = AF.request(encodeURL, method: .post, parameters: parameters, headers: headers)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                                      
                        MBProgressHUD.hide(for: self.view, animated: true)
                        let json = JSON(data)
                                             
                        if let successValue = json["success"].int {
                            
                            if(successValue == 1){
                            
                                self.solicitudActualizada()
                            }
                            else if(successValue == 2){
                                
                                self.solicitudNoExiste()
                            }
                            else{
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
    
    
    
    func solicitudActualizada(){
        
        tableView.isHidden = true
        items.removeAll()
        
        let texto = TextoIdiomaController.localizedString(forKey: "actualizado")
        mensajeToastAzul(mensaje: texto)
        
        apiBuscarDatos()
    }
    
    
    func solicitudNoExiste(){
        
        tableView.isHidden = true
        items.removeAll()
        
        let texto = TextoIdiomaController.localizedString(forKey: "error_intentar_de_nuevo")
        mensajeToastAzul(mensaje: texto)
        
        apiBuscarDatos()
    }
    
    
}
