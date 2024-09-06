//
//  InicioTab2Controller.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 21/3/24.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import RxSwift
import Toast_Swift
import SDWebImage

class InicioTab2Controller: UIViewController, UITableViewDelegate, UITableViewDataSource{
       
    
   
    var tema = false
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    var hayInfo = false
    var textoNoHayAmigos = ""
    
    var nombreDosPuntos = ""
    var correoDosPuntos = ""
    var paisDosPuntos = ""
    
    let refreshControl = UIRefreshControl()

    @IBOutlet weak var tableView: UITableView!
    
    var items: [ModeloComunidadAceptados] = []
    
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
        
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(refrescarDatos), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        textoNoHayAmigos = TextoIdiomaController.localizedString(forKey: "no_hay_solicitudes_aceptadas")
        
        nombreDosPuntos = TextoIdiomaController.localizedString(forKey: "nombre_dos_puntos")
        correoDosPuntos = TextoIdiomaController.localizedString(forKey: "correo_dos_puntos")
        paisDosPuntos = TextoIdiomaController.localizedString(forKey: "pais_dos_puntos")
         
        apiBuscarDatos()
    }
    
    @objc func refrescarDatos() {
       apiBuscarDatos()
    }
    
    
    func apiBuscarDatos(){
                
        if(tableView == nil){
            return
        }
        
        
        tableView.isHidden = true
        items.removeAll()
        
        
        // BOTON
        let bloque1 = ModeloComunidadAceptados(tipo: 1, id: 0, nombre: "", iglesia: "", correo: "", pais: "", idpais: 0)
        items.append(bloque1)
        
        
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiComunidadListadoAceptados
        
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
                        
                        
                        self.refreshControl.endRefreshing()
                                            
                        if let successValue = json["success"].int {
                            
                            if(successValue == 1){
                                
                                let datoInfo = json["hayinfo"].int ?? 0
                                if(datoInfo == 1){
                                   
                                    // hay informacion
                                    
                                    json["listado"].array?.forEach({ (dataArray) in
                                                           
                                        let miid = dataArray["id"].int ?? 0
                                        let minombre = dataArray["nombre"].string ?? ""
                                        let miiglesia = dataArray["iglesia"].string ?? ""
                                        let micorreo = dataArray["correo"].string ?? ""
                                        let mipais = dataArray["pais"].string ?? ""
                                        let miidpais = dataArray["idpais"].int ?? 0
                                     
                                        
                                        let bloque2 = ModeloComunidadAceptados(tipo: 2, id: miid, nombre: minombre, iglesia: miiglesia, correo: micorreo, pais: mipais, idpais: miidpais)
                                        
                                        self.items.append(bloque2)
                                    })
                                }else{
                                    
                                    let bloque3 = ModeloComunidadAceptados(tipo: 3, id: 0, nombre: "", iglesia: "", correo: "", pais: "", idpais: 0)
                                    
                                    self.items.append(bloque3)
                                }
                                                                                                
                                self.tableView.reloadData()
                                self.tableView.isHidden = false
                                
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
      
    func recargarVista(){
        let instanciaTema = TemaController()
        if( instanciaTema.conocerTemaActual() == 1){
            tema = true
            overrideUserInterfaceStyle = .dark
        }else{
            tema = false
            overrideUserInterfaceStyle = .light
        }
        
        apiBuscarDatos()
    }
    
    @objc func buttonPlanesComunidadTapped(_ sender: UIButton) {
        opcionesPlanesComunidad()
    }
    
    @objc func buttonAddAmigoTapped(_ sender: UIButton) {
        vistaAgregarAmigo()
    }

    @objc func buttonPendientesTapped(_ sender: UIButton) {
        // Lógica cuando se pulsa el botón 2 en cualquier celda
        opcBtnPendiente()
    }
    
    
    
    
    
    func opcionesPlanesComunidad(){
        
        let textoSeleccionar = TextoIdiomaController.localizedString(forKey: "seleccionar_opcion")
        
        
        let textoAgregado = TextoIdiomaController.localizedString(forKey: "agregado")
        let textoMeHan = TextoIdiomaController.localizedString(forKey: "me_han_agregado")
        let textoCancelar = TextoIdiomaController.localizedString(forKey: "cancelar")
       
        
        let alertController = UIAlertController(title: textoSeleccionar, message: nil, preferredStyle: .alert)
               
        let option1Action = UIAlertAction(title: textoAgregado, style: .default) { (action) in
            // OPCION AGREGADO
            self.vistaAgregado()
         }
               
        let option2Action = UIAlertAction(title: textoMeHan, style: .default) { (action) in
            // OPCION ME HAN AGREGADO
            self.vistaMeHanAgregado()
         }
               
        let option3Action = UIAlertAction(title: textoCancelar, style: .default) { (action) in
            // CANCELAR
        }
               
       alertController.addAction(option1Action)
       alertController.addAction(option2Action)
       alertController.addAction(option3Action)
       
       present(alertController, animated: true, completion: nil)
    }
    
    
    func vistaAgregado(){
        let vista : ComunidadPlanesAgregadoViewController = UIStoryboard(name: "Main3", bundle: nil).instantiateViewController(withIdentifier: "ComunidadPlanesAgregadoViewController") as! ComunidadPlanesAgregadoViewController
                    
        self.present(vista, animated: true, completion: nil)
    }
    
    func vistaMeHanAgregado(){
        
        let vista : PlanesAmigosMeHanAgregadoController = UIStoryboard(name: "Main3", bundle: nil).instantiateViewController(withIdentifier: "PlanesAmigosMeHanAgregadoController") as! PlanesAmigosMeHanAgregadoController
                    
        self.present(vista, animated: true, completion: nil)
    }
    
    
    
    
    func opcBtnPendiente(){
        
        let textoEnviadas = TextoIdiomaController.localizedString(forKey: "enviadas")
        let textoRecibidas = TextoIdiomaController.localizedString(forKey: "recibidas")
        let textoCancelar = TextoIdiomaController.localizedString(forKey: "cancelar")
        let textoSeleccionar = TextoIdiomaController.localizedString(forKey: "seleccionar_opcion")
        
        
        let alertController = UIAlertController(title: textoSeleccionar, message: nil, preferredStyle: .alert)
               
        let option1Action = UIAlertAction(title: textoEnviadas, style: .default) { (action) in
                  
                   // ENVIADAS
                self.vistaSolicitudes(tipo: 1)
               }
               
        let option2Action = UIAlertAction(title: textoRecibidas, style: .default) { (action) in
                   
                   // RECIBIDAS
                self.vistaSolicitudes(tipo: 2)
                 
               }
               
        let option3Action = UIAlertAction(title: textoCancelar, style: .default) { (action) in
                   
                   // CANCELAR
               }
               
           alertController.addAction(option1Action)
           alertController.addAction(option2Action)
           alertController.addAction(option3Action)
           
           present(alertController, animated: true, completion: nil)
    }
        
    
 
    func vistaSolicitudes(tipo: Int){
        
        if(tipo == 1){
            
            let vista : SolicitudEnviadasController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "SolicitudEnviadasController") as! SolicitudEnviadasController
                        
            self.present(vista, animated: true, completion: nil)
                        
        }else{
            
            let vista : SolicitudRecibidasController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "SolicitudRecibidasController") as! SolicitudRecibidasController
                        
            self.present(vista, animated: true, completion: nil)
        }
    }
    
    
    func vistaAgregarAmigo(){
        let vista : AgregarAmigoController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "AgregarAmigoController") as! AgregarAmigoController
                
        self.present(vista, animated: true, completion: nil)
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    // METODOS TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
       return items.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                 
        let selectedItem = items[indexPath.row]
        
        if(selectedItem.tipo == 1){
            
            // BOTONERA
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! ComunidadTabCell1
            
            cell.selectionStyle = .none
            
            cell.btnPendientes.layer.cornerRadius = 18
            cell.btnPendientes.clipsToBounds = true
            
            cell.btnAddAmigo.layer.cornerRadius = 18
            cell.btnAddAmigo.clipsToBounds = true
            
            cell.btnPlanesComunidad.layer.cornerRadius = 18
            cell.btnPlanesComunidad.clipsToBounds = true
            
            let textoAddAmigo = TextoIdiomaController.localizedString(forKey: "agregar_amigo")
            let textoPendientes = TextoIdiomaController.localizedString(forKey: "pendientes")
            let textoPlanesComunidad = TextoIdiomaController.localizedString(forKey: "planes_comunidad")
            
            
            if(tema){ // Dark
                
                // BOTON CONTNUAR
                 
                cell.btnAddAmigo.backgroundColor = .white
                cell.btnPendientes.backgroundColor = .white
                cell.btnPlanesComunidad.backgroundColor = .white
                      
                 let btnAddAmigoAtributo = NSAttributedString(string: textoAddAmigo, attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                    NSAttributedString.Key.foregroundColor: UIColor.black,
                 ])
                             
                cell.btnAddAmigo.setAttributedTitle(btnAddAmigoAtributo, for: .normal)
               
                let btnPendientesAtributo = NSAttributedString(string: textoPendientes, attributes: [
                   NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                   NSAttributedString.Key.foregroundColor: UIColor.black,
                ])
                            
               cell.btnPendientes.setAttributedTitle(btnPendientesAtributo, for: .normal)
              
              
                let btnPlaComuAtributo = NSAttributedString(string: textoPlanesComunidad, attributes: [
                   NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                   NSAttributedString.Key.foregroundColor: UIColor.black,
                ])
                            
               cell.btnPlanesComunidad.setAttributedTitle(btnPlaComuAtributo, for: .normal)
                
                
                
                
            }else{
                
                
                cell.btnAddAmigo.backgroundColor = .black
                cell.btnPendientes.backgroundColor = .black
                cell.btnPlanesComunidad.backgroundColor = .black
                
                let btnAtributoAddAmigo = NSAttributedString(string: textoAddAmigo, attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                    NSAttributedString.Key.foregroundColor: UIColor.white,
                ])
                
                let btnAtributoPendiente = NSAttributedString(string: textoPendientes, attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                    NSAttributedString.Key.foregroundColor: UIColor.white,
                ])
                
                
                let btnAtriPlaneComuni = NSAttributedString(string: textoPlanesComunidad, attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                    NSAttributedString.Key.foregroundColor: UIColor.white,
                ])
                
                cell.btnAddAmigo.setAttributedTitle(btnAtributoAddAmigo, for: .normal)
                
                cell.btnPendientes.setAttributedTitle(btnAtributoPendiente, for: .normal)
                
                cell.btnPlanesComunidad.setAttributedTitle(btnAtriPlaneComuni, for: .normal)
            }
            
            
            
            // *** HIGHLIGHTED
            let btnAtributoPressAddAmigo = NSAttributedString(string: textoAddAmigo, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                NSAttributedString.Key.foregroundColor: UIColor.gray,
            ])

            cell.btnAddAmigo.setAttributedTitle(btnAtributoPressAddAmigo, for: .highlighted)
            
            let btnAtributoPressPendiente = NSAttributedString(string: textoPendientes, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                NSAttributedString.Key.foregroundColor: UIColor.gray,
            ])

            cell.btnPendientes.setAttributedTitle(btnAtributoPressPendiente, for: .highlighted)
            
            
            // Asigna las acciones para los botones
            cell.btnAddAmigo.addTarget(self, action: #selector(buttonAddAmigoTapped(_:)), for: .touchUpInside)
            cell.btnPendientes.addTarget(self, action: #selector(buttonPendientesTapped(_:)), for: .touchUpInside)
            // asignacion boton planes comunidad
            cell.btnPlanesComunidad.addTarget(self, action: #selector(buttonPlanesComunidadTapped(_:)), for: .touchUpInside)
            
         
            return cell
        }
        else if(selectedItem.tipo == 2){
            
            // LISTADO DE AMIGOS ACEPTADOS
                        
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! ComunidadTabCell2
            
            // Configura las esquinas redondeadas
            cell.vista.layer.cornerRadius = 20
            // Habilita la máscara de recorte para que las subvistas sigan la forma de las esquinas redondeadas
            cell.vista.clipsToBounds = true
            
            
            if(tema){
                cell.vista.backgroundColor = UIColor.white
            }else{
                cell.vista.backgroundColor = UIColor.systemGray6
            }
            
            cell.txtNombre.numberOfLines = 0
            cell.txtCorreo.numberOfLines = 0
            cell.txtPais.numberOfLines = 0
            
            cell.txtNombre.textColor = .black
            cell.txtCorreo.textColor = .black
            cell.txtPais.textColor = .black
            
            
            cell.txtNombre.text = nombreDosPuntos + " " + selectedItem.nombre
            cell.txtCorreo.text = correoDosPuntos + " " + selectedItem.correo
            cell.txtPais.text = paisDosPuntos + " " + selectedItem.pais
            
            
            // BANDERA
            if(selectedItem.idpais == 1){
                if let nuevaImagen = UIImage(named: "flag_elsalvador") {
                    cell.imgPais.image = nuevaImagen
                }
               
            }else if(selectedItem.idpais == 2){
                if let nuevaImagen = UIImage(named: "flag_guatemala") {
                    cell.imgPais.image = nuevaImagen
                }
            }else if(selectedItem.idpais == 3){
                if let nuevaImagen = UIImage(named: "flag_honduras") {
                    cell.imgPais.image = nuevaImagen
                }
            }else if(selectedItem.idpais == 4){
                if let nuevaImagen = UIImage(named: "flag_nicaragua") {
                    cell.imgPais.image = nuevaImagen
                }
            }
            else if(selectedItem.idpais == 5){
                if let nuevaImagen = UIImage(named: "flag_mexico") {
                    cell.imgPais.image = nuevaImagen
                }
            }
            else{
                if let nuevaImagen = UIImage(named: "localizacion") {
                    cell.imgPais.image = nuevaImagen
                }
            }
              
            
            cell.selectionStyle = .none
            
            return cell
            
        }
        else if(selectedItem.tipo == 3){
            
            // NO HAY INFORMACION
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! ComunidadTabCell3
            
           
            cell.txtNoHayInfo.text = textoNoHayAmigos
               
            cell.selectionStyle = .none
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let selectedItem = items[indexPath.row]
        
        if(selectedItem.tipo == 2){
            
            modalPregunta(id: selectedItem.id)
        }
    }
    
    
    func modalPregunta(id: Int){
        
        let textoSeleccionar = TextoIdiomaController.localizedString(forKey: "seleccionar_opcion")
        
        
        let textoPlanes = TextoIdiomaController.localizedString(forKey: "planes")
        let textoInsignias = TextoIdiomaController.localizedString(forKey: "insignias")
        let textoCancelar = TextoIdiomaController.localizedString(forKey: "cancelar")
       
        
        let alertController = UIAlertController(title: textoSeleccionar, message: nil, preferredStyle: .alert)
               
        let option1Action = UIAlertAction(title: textoPlanes, style: .default) { (action) in
                  
                   // PLANES
            self.vistaPlanes(id: id)
               }
               
        let option2Action = UIAlertAction(title: textoInsignias, style: .default) { (action) in
                   
                   // INSIGNIAS
                
            self.vistaInsignias(id: id)
               }
               
        let option3Action = UIAlertAction(title: textoCancelar, style: .default) { (action) in
                   
                   // CANCELAR
               }
               
           alertController.addAction(option1Action)
           alertController.addAction(option2Action)
           alertController.addAction(option3Action)
           
           present(alertController, animated: true, completion: nil)
        
    }
    
    
    func vistaPlanes(id: Int){
        
        let vista : PlanesAmigosViewController = UIStoryboard(name: "Main3", bundle: nil).instantiateViewController(withIdentifier: "PlanesAmigosViewController") as! PlanesAmigosViewController
        
        vista.idSolicitud = id
        
        self.present(vista, animated: true, completion: nil)
    }
    
    
    func vistaInsignias(id: Int){
        
        let vista : InsigniasAmigosController = UIStoryboard(name: "Main3", bundle: nil).instantiateViewController(withIdentifier: "InsigniasAmigosController") as! InsigniasAmigosController
        
        vista.idSolicitud = id
        
        self.present(vista, animated: true, completion: nil)
    }

}
