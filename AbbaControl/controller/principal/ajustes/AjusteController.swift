//
//  AjusteController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 12/3/24.
//


import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import RxSwift
import Toast_Swift

protocol protocolPerfilController {
  func pasarDatosProtocol(data: Bool)
}

class AjusteController: UIViewController,UITableViewDelegate, UITableViewDataSource, protocolPerfilController {
    
    func pasarDatosProtocol(data: Bool) {
        if(data){
            tableView.isHidden = true
            apiSolicitarDatos()
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
              
        apiSolicitarDatos()
    }
    
    
    func apiSolicitarDatos(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiInformacionAjustes
        
        let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "iduser": iduser ?? 0,
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
                                
                                self.letra = json["letra"].stringValue
                                self.nombre = json["nombre"].stringValue
                                
                                self.completar()
                                                            
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
  
    
  
    
    func completar(){
        
        if(unaVezCrearModelo){
            items = [
                ModeloAjustes(tipo: TIPOTITULO, id: 1, nombre: TextoIdiomaController.localizedString(forKey: "ajustes"), nombreImagen: ""),
                
                ModeloAjustes(tipo: TIPOPERFIL, id: 2, nombre: "", nombreImagen: "circulo"),
                
                
                ModeloAjustes(tipo: TIPOOPCIONES, id: 3, nombre: TextoIdiomaController.localizedString(forKey: "notificaciones"), nombreImagen: "ic_notificacion"),
                ModeloAjustes(tipo: TIPOOPCIONES, id: 4, nombre: TextoIdiomaController.localizedString(forKey: "contrasena"), nombreImagen: "ic_password"),
                ModeloAjustes(tipo: TIPOOPCIONES, id: 5, nombre: TextoIdiomaController.localizedString(forKey: "insignias_por_ganar"), nombreImagen: "ic_insignia"),
                ModeloAjustes(tipo: TIPOOPCIONES, id: 6, nombre: TextoIdiomaController.localizedString(forKey: "planes_comunidad"), nombreImagen: "ic_libro"),
                
                ModeloAjustes(tipo: TIPOOPCIONES, id: 7, nombre: TextoIdiomaController.localizedString(forKey: "idioma"), nombreImagen: "ic_mundo"),
                
                ModeloAjustes(tipo: TIPOOPCIONES, id: 8, nombre: TextoIdiomaController.localizedString(forKey: "temas"), nombreImagen: "ic_tema"),
                
                ModeloAjustes(tipo: TIPOOPCIONES, id: 9, nombre: TextoIdiomaController.localizedString(forKey: "cerrar_sesion"), nombreImagen: "ic_cerrar"),
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
        else if item.tipo == TIPOPERFIL {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! AjusteCell2TableView
          
            
            cell.txtNombrePerfil.text = nombre
            cell.imgPerfil.image = UIImage(named: item.nombreImagen)?.withRenderingMode(.alwaysTemplate)
            cell.selectionStyle = .none
            
            // letra dentro del imageview
            
            if let existingLabel = cell.imgPerfil.viewWithTag(100) as? UILabel {
                // Si existe, la eliminamos
                existingLabel.removeFromSuperview()
            }
            
            let label = UILabel()
            label.text = letra // Establece el texto que deseas mostrar
            label.tag = 100
            label.textAlignment = .center // Alinea el texto al centro del label
            label.translatesAutoresizingMaskIntoConstraints = false // Desactiva la creación automática de restricciones

            
            if(tema){
                label.textColor = UIColor.white
                cell.imgPerfil.tintColor = UIColor.white
            }else{
                label.textColor = UIColor.black
                cell.imgPerfil.tintColor = UIColor.black
            }
            
            // Agregar el label a la imageView
            cell.imgPerfil.addSubview(label)

            // Establecer restricciones para el label
            label.centerXAnchor.constraint(equalTo: cell.imgPerfil.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: cell.imgPerfil.centerYAnchor).isActive = true
            
            
            return cell
        }
        else if item.tipo == TIPOOPCIONES {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! AjusteCell3TableView
            
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
        
        if(tipo == 2){
            // perfil
            vistaPerfil()
        }
        else if(tipo == 3){
            // notificaciones
            vistaNotificaciones()
        }
        else if(tipo == 4){
            // password cambio
            vistaCambiarContrasena()
        }
        else if(tipo == 5){
            
        }
        else if(tipo == 6){
            
        }
        else if(tipo == 7){
            vistaIdiomas()
        }
        else if(tipo == 8){
            preguntaTema()
        }
        else if(tipo == 9){
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
            
            self.cambiarTema()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
 
    func cambiarTema(){
        
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
        apiSolicitarDatos()
    }
    
    
    func preguntaSalir(){
        
        let titulo = TextoIdiomaController.localizedString(forKey: "cerrar_sesion")
        let si = TextoIdiomaController.localizedString(forKey: "si")
        
        let alert = UIAlertController(title: titulo, message: nil, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: si, style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            
            self.salir()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
  
    func salir(){
        
        UserDefaults.standard.removeObject(forKey: "ID")
        UserDefaults.standard.removeObject(forKey: "TOKEN")
        
        let vista : LoginRegisterController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginRegisterController") as! LoginRegisterController
        
        self.present(vista, animated: true, completion: nil)
    }
    
    
    
    
    func vistaCambiarContrasena(){
        let vista : NuevaContrasenaController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "NuevaContrasenaController") as! NuevaContrasenaController
        
        self.present(vista, animated: true, completion: nil)
    }
    
    
    func vistaIdiomas(){
        let vista : IdiomasController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "IdiomasController") as! IdiomasController
        
        self.present(vista, animated: true, completion: nil)
    }
    
    
    
    func vistaPerfil(){
        let vista : MiPerfilController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "MiPerfilController") as! MiPerfilController
        
        vista.delegate = self
        
        self.present(vista, animated: true, completion: nil)
    }
   
    
    func vistaNotificaciones(){
        let vista : NotificacionesController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "NotificacionesController") as! NotificacionesController
                
        self.present(vista, animated: true, completion: nil)
    }

}
