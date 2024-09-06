//
//  IniciarAmigosController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 20/3/24.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import RxSwift
import Toast_Swift


class IniciarAmigosController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var delegate: protocolDevoInformacionAmigos!
    var recargarVistaAnterior = false
    var idplan = 0
    
    @IBOutlet weak var btnIniciar: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var items: [ModeloComuAmigosIniciar] = []
    var tema = false
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    
    var hayDatos = true
    var textoNombre = ""
    var textoCorreo = ""
    
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
        
        textoNombre = TextoIdiomaController.localizedString(forKey: "nombre_dos_puntos")
        textoCorreo = TextoIdiomaController.localizedString(forKey: "correo_dos_puntos")
               
        configBoton()
        
        apiSolicitarDatos()
    }
    
    
    func configBoton(){
        
        btnIniciar.layer.cornerRadius = 18
        btnIniciar.clipsToBounds = true
        
        let textoIniciar = TextoIdiomaController.localizedString(forKey: "iniciar")
        
        
        if(tema){ // Dark
            
            // BOTON INICIAR
             
            btnIniciar.backgroundColor = .white
                  
             let btnIniciarAtributo = NSAttributedString(string: textoIniciar, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                NSAttributedString.Key.foregroundColor: UIColor.black,
             ])
                         
            btnIniciar.setAttributedTitle(btnIniciarAtributo, for: .normal)
                        
        }else{
                        
                        
            btnIniciar.backgroundColor = .black
                  
             let btnIniciarAtributo = NSAttributedString(string: textoIniciar, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                NSAttributedString.Key.foregroundColor: UIColor.white,
             ])
                         
            btnIniciar.setAttributedTitle(btnIniciarAtributo, for: .normal)
            
        }
        
        
        let btnIniciarPress = NSAttributedString(string: textoIniciar, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
            NSAttributedString.Key.foregroundColor: UIColor.gray,
        ])

        btnIniciar.setAttributedTitle(btnIniciarPress, for: .highlighted)
        
    }
    
    
    
    func apiSolicitarDatos(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiComunidadAceptado
        
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
                        
                        self.tableView.isHidden = false
                        
                        if let successValue = json["success"].int {
                            
                            if(successValue == 1){
                                
                                let hayInfo = json["hayinfo"].int ?? 1
                             
                                if(hayInfo == 1){
                                    
                                 
                                    json["listado"].array?.forEach({ (dataArray) in
                                                         
                                        let id = dataArray["id"].int ?? 0
                                        let idusuario = dataArray["idusuario"].int ?? 0
                                        let idpais = dataArray["idpais"].int ?? 0
                                        let nombre = dataArray["nombre"].string ?? ""
                                        let correo = dataArray["correo"].string ?? ""
                                        let pais = dataArray["pais"].string ?? ""
                                                                              
                                        let notification = ModeloComuAmigosIniciar(id: id, idusuario: idusuario, idpais: idpais, nombre: nombre, correo: correo, nombrepais: pais, estado: false)
                                        
                                        self.items.append(notification)
                                    })
                                    
                                                            
                                    self.tableView.reloadData()
                                    
                                }else{
                                    // aqui se mostrara no hay notificaciones
                                    let notification = ModeloComuAmigosIniciar(id: 0,idusuario: 0, idpais: 0, nombre: "", correo: "", nombrepais: "", estado: false)
                                    self.items.append(notification)
                                    
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
    
    
    
    

    @IBAction func btnIniciar(_ sender: Any) {
        verificar()
    }
    
    
    func verificar(){
        
        if let idsConEstadoTrue = obtenerIdsDeModelosConEstadoTrue() {
              // Verifica si hay más de 5 elementos en el diccionario idsConEstadoTrue
              if idsConEstadoTrue.count > 5 {
                 
                  // si hay mas de 5
                  let mitexto = TextoIdiomaController.localizedString(forKey: "maximo_cinco_amigos")
                                    
                  let alert = UIAlertController(title: mitexto, message: nil, preferredStyle: UIAlertController.Style.alert)
                           
                  alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: {(action) in
                      alert.dismiss(animated: true, completion: nil)
                      
                  }))
                  
                  self.present(alert, animated: true, completion: nil)
                  
              } else {
                  
                  preguntarEnviarDatos()
                  
              }
          } else {
           
              let mitexto = TextoIdiomaController.localizedString(forKey: "minimo_uno_amigo")
              
              let alert = UIAlertController(title: mitexto, message: nil, preferredStyle: UIAlertController.Style.alert)
                       
              alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: {(action) in
                  alert.dismiss(animated: true, completion: nil)
                  
              }))
              
              self.present(alert, animated: true, completion: nil)
          }
    }
    
    
    func preguntarEnviarDatos(){
        
        var titulo = TextoIdiomaController.localizedString(forKey: "iniciar_plan")
        var botonno = TextoIdiomaController.localizedString(forKey: "cancelar")
        var botonsi = TextoIdiomaController.localizedString(forKey: "si")
                
        
        let alert = UIAlertController(title: titulo, message: nil, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: botonno, style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: botonsi, style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            
            self.enviarDatos()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func enviarDatos(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiIniciarPlanAmigos
        
        let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
        let idiomaPlan = UserDefaults.standard.getValueIdiomaApp()
                
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
                
        // Crear un array de diccionarios clave-valor a partir de tu modelo
        var datosClaveValor: [[String: Any]] = []

        for modelo in items {
            // Obtener el ID y el estado del modelo
            let id = modelo.getId() // ID SOLICITUD
            let iduserFila = modelo.getIdUsuario() // IDUSUARIO
            
 
            datosClaveValor.append(["id": id, "estado": iduserFila])
        }
        
        // Definir otros parámetros adicionales
        let otrosParametros: [String: Any] = [
            "iduser": iduser ?? 0,
            "idplan": idplan,
            "idiomaplan": idiomaPlan ?? 1
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
                                    // PLAN YA REGISTRADO
                                    
                                    // siempre decir lo mismo que estado: 2
                                    self.volverAtrasActualizado()
                                    
                                       
                                }
                                else if(successValue == 2){
                                    // VOLVER ATRAS ACTUALIZADO
                                    
                                    self.volverAtrasActualizado()
                                    
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
    
    
     
    func volverAtrasActualizado(){
        
        var texto = TextoIdiomaController.localizedString(forKey: "plan_agregado")
        
        
        let alert = UIAlertController(title: texto, message: nil, preferredStyle: UIAlertController.Style.alert)
        
             
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            
            self.salir()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func salir(){
        recargarVistaAnterior = true
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func obtenerIdsDeModelosConEstadoTrue() -> [String: Int]? {
        var idsConEstadoTrue: [String: Int] = [:]

            // Recorre todo el modelo
            for model in items {
                // Verifica si el estado del modelo es true
                if model.estado {
                    // Convierte el id del modelo a String
                    let idSolicitud = String(model.getIdUsuario())
                    
                    // Agrega el id del modelo y su estado al diccionario
                    idsConEstadoTrue[idSolicitud] = model.getId()
                }
                
                // Verifica si el diccionario tiene más de 5 elementos
               /* if idsConEstadoTrue.count >= 5 {
                    // Si tiene más de 5 elementos, devuelve nil
                    return nil
                }*/
            }

            // Verifica si el diccionario está vacío
            if idsConEstadoTrue.isEmpty {
                // Si está vacío, devuelve nil
                return nil
            } else {
                // Si no está vacío, devuelve el diccionario
                return idsConEstadoTrue
            }
    }
    
    
    
    @IBAction func flechaAtras(_ sender: Any) {
                
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
        delegate.recargarVistaAnterior(data: recargarVistaAnterior)
    }
    
    
    
    // METODOS TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
       return items.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                 
        let selectedItem = items[indexPath.row]
        
        if(hayDatos){
                        
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! IniciarAmigoCell1
            
            
            if(selectedItem.getIdPais() == 1){
                if let nuevaImagen = UIImage(named: "flag_elsalvador") {
                    cell.imgBandera.image = nuevaImagen
                }
               
            }else if(selectedItem.getIdPais() == 2){
                if let nuevaImagen = UIImage(named: "flag_guatemala") {
                    cell.imgBandera.image = nuevaImagen
                }
            }else if(selectedItem.getIdPais() == 3){
                if let nuevaImagen = UIImage(named: "flag_honduras") {
                    cell.imgBandera.image = nuevaImagen
                }
            }else if(selectedItem.getIdPais() == 4){
                if let nuevaImagen = UIImage(named: "flag_nicaragua") {
                    cell.imgBandera.image = nuevaImagen
                }
            }
            else{
                if let nuevaImagen = UIImage(named: "flag_mexico") {
                    cell.imgBandera.image = nuevaImagen
                }
            }
                           
            
            
            
            
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
                        
            
            
            cell.txtPais.numberOfLines = 0
            cell.txtPais.text = selectedItem.getNombrePais()
            
            cell.txtCorreo.numberOfLines = 0
            cell.txtCorreo.text = "\(textoCorreo) \(selectedItem.getCorreo())"
            
            cell.txtNombre.numberOfLines = 0
            cell.txtNombre.text = "\(textoNombre) \(selectedItem.getNombre())"
                       
            cell.selectionStyle = .none
            
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! IniciarAmigoCell2
            
            cell.txtNoHayAmigos.numberOfLines = 0
            cell.txtNoHayAmigos.text = TextoIdiomaController.localizedString(forKey: "no_hay_solicitudes_aceptadas")
                        
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(hayDatos){
            let selectedItem = items[indexPath.row]
            
            
            // Modifica el estado del modelo
            selectedItem.estado = !selectedItem.estado

            // Actualiza la celda tocada
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    

}
