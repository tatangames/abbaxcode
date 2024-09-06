//
//  PlanesOcultarController.swift
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

struct Plan: Encodable {
    let id: Int
    let edad: Int
}

class PlanesOcultarController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var tema = false
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    var hayInformacion = true
    
    @IBOutlet weak var btnOcultar: UIBarButtonItem!
    
    
    var items: [ModeloPlanesOcultar] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let instanciaTema = TemaController()
        if( instanciaTema.conocerTemaActual() == 1){
            tema = true
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
        
        
        btnOcultar.title = TextoIdiomaController.localizedString(forKey: "ocultar")
        
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        apiSolicitarDatos()
    }
    
    func apiSolicitarDatos(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiListadoPlanesOcultar
        
        let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
        let idiomaPlan = UserDefaults.standard.getValueIdiomaApp()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "iduser": iduser ?? 0,
            "idiomaplan": idiomaPlan ?? 1,
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
                                
                                let hayInfo = json["hayinfo"].intValue
                                
                                if(hayInfo == 1){
                                    
                                    json["listado"].array?.forEach({ (dataArray) in
                                                                                       
                                        let idplanes = dataArray["id_planes"].int ?? 0
                                        let nombre = dataArray["titulo"].string ?? ""
                                        let estado = dataArray["estado"].bool ?? false
                                                                              
                                        let informacion = ModeloPlanesOcultar(idplanes: idplanes, nombre: nombre, estado: estado)
                                        
                                        self.items.append(informacion)
                                    })
                                    
                                                            
                                    self.tableView.reloadData()
                                    
                                }else{
                                 
                                    self.hayInformacion = false
                                    // para que table view cree 1 sola fila diciendo que no hay insignias
                                    let informacion = ModeloPlanesOcultar(idplanes: 0, nombre: "", estado: false)
                                    
                                    self.items.append(informacion)
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
    
    
    @IBAction func btnOcultar(_ sender: Any) {
        
        verificar()
    }
    
    
    func verificar(){
                
        let titulo =  TextoIdiomaController.localizedString(forKey: "actualizar")
        let mensaje =  TextoIdiomaController.localizedString(forKey: "los_amigos_que_tienes_agregados")
        let cancel =  TextoIdiomaController.localizedString(forKey: "cancelar")
        let aceptar = TextoIdiomaController.localizedString(forKey: "si")
        
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: cancel, style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: aceptar, style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            self.enviarDatos()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
   
    
    func enviarDatos(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiActualizarPlanesOcultos
        
        let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
                
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
                
        // Crear un array de diccionarios clave-valor a partir de tu modelo
        var datosClaveValor: [[String: Any]] = []

        for modelo in items {
            // Obtener el ID y el estado del modelo
            let id = modelo.getIdplanes()
            let estado = modelo.estado ? 1 : 0 // Convertir el estado a Int

            datosClaveValor.append(["id": id, "estado": estado])
        }

        
        // Definir otros parámetros adicionales
        let otrosParametros: [String: Any] = [
            "iduser": iduser ?? 0,
        ]
        
                
        // Agregar el array de datos clave-valor a los parámetros
        var parametroFinal = otrosParametros
        parametroFinal["datos"] = datosClaveValor
        
               
            Observable<Void>.create { observer in
                let request = AF.request(encodeURL, method: .post, parameters: parametroFinal,  encoding: JSONEncoding.default, headers: headers)
  
                    .responseData { response in
                        switch response.result {
                        case .success(let data):
                                                                    
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let json = JSON(data)
                            
                            if let successValue = json["success"].int {
                                
                                if(successValue == 1){
                                       
                                    self.actualizado()
                                       
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
    
    
    
    func actualizado(){
        let mensaje = TextoIdiomaController.localizedString(forKey: "actualizado")
        mensajeToastAzul(mensaje: mensaje)
    }
    
           
    
    // METODOS TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
       return items.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                 
        let selectedItem = items[indexPath.row]
        
        if(hayInformacion){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! PlanesOcultarCell1TableView
            
            if(selectedItem.getEstado()){
                cell.imgCheck.image = UIImage(named: "check")?.withRenderingMode(.alwaysTemplate)
            }else{
                cell.imgCheck.image = UIImage(named: "nocheck")?.withRenderingMode(.alwaysTemplate)
            }
        
            if(tema){
                cell.imgCheck.tintColor = UIColor.white
            }else{
                cell.imgCheck.tintColor = UIColor.black
            }
            
            cell.txtNombre.numberOfLines = 0
            cell.txtNombre.text = selectedItem.getNombre()
            
            cell.selectionStyle = .none
            
            return cell
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! PlanesOcultarCell2TableView
            
            cell.txtNoHay.numberOfLines = 0
            cell.txtNoHay.text = TextoIdiomaController.localizedString(forKey: "no_hay_planes_disponibles")
                        
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItem = items[indexPath.row]
        
        // Modifica el estado del modelo
        selectedItem.estado = !selectedItem.estado

        // Actualiza la celda tocada
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}


