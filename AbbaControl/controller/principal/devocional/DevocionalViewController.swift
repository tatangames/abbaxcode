//
//  DevocionalViewController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 19/3/24.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import RxSwift
import Toast_Swift
import SDWebImage

protocol protocolDevoInformacion {
  func recargarVistaAnterior(data: Bool)
}

class DevocionalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
                                protocolDevoInformacion, ThemeChangeDelegate {
    
    // PANTALLA DONDE APARECE LOS 2 BOTONES DEVOCIONALES
    // MIS DEVOCIONALES, BUSCAR DEVOCIONALES
        
    
   
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
        
        if(theme){
            filterView.buttonBackgroundColor = .white
            filterView.buttonTextColor = .black
        }else{
            filterView.buttonBackgroundColor = .black
            filterView.buttonTextColor = .white
        }
        
        if(indexBoton == 0){
            apiBuscarMisPlanes()
        }else if (indexBoton == 1){
            apiBuscarPlanesNuevos()
        }
        
        filterView.selectedButtonIndex = indexBoton
    }
    
   
    func recargarVistaAnterior(data: Bool) {
        if(data){
            
            tableView.isHidden = true
            items.removeAll()
                     
            if(indexBoton == 0){
                apiBuscarMisPlanes()
            }else if (indexBoton == 1){
                apiBuscarPlanesNuevos()
            }
        }
    }
    

    
    @IBOutlet weak var filterView: FilterView!
    
    var filterData = [String]()
    
    var tema = false
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    
    var textoBoton1 = ""
    var textoBoton2 = ""
    var textoNoHayDevoSeleccionados = ""
    var textoNoHayDevoDisponibles = ""
    var textoCell2 = ""
    var indexBoton = 0
    var textoParaIniciarElige = ""
    
    @IBOutlet weak var tableView: UITableView!
    
   
    
    var items: [ModeloDevocionales] = []
    var hayDatos = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let instanciaTema = TemaController()
        if( instanciaTema.conocerTemaActual() == 1){
            tema = true
         
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
        
        textoBoton1 = TextoIdiomaController.localizedString(forKey: "mis_planes")
        textoBoton2 = TextoIdiomaController.localizedString(forKey: "buscar_planes")
        textoParaIniciarElige = TextoIdiomaController.localizedString(forKey: "para_iniciar_elige")
        
        
        textoNoHayDevoSeleccionados = TextoIdiomaController.localizedString(forKey: "no_hay_devvocionales_seleccionado")
        textoNoHayDevoDisponibles = TextoIdiomaController.localizedString(forKey: "no_hay_devocionales_disponibles")

        filterData.append(textoBoton1)
        filterData.append(textoBoton2)
        
        filterView.dataSource = filterData
        
        if(tema){
            filterView.buttonBackgroundColor = .white
            filterView.buttonTextColor = .black
        }else{
            filterView.buttonBackgroundColor = .black
            filterView.buttonTextColor = .white
        }
                
        filterView.buttonPressedHandler = { [weak self] index in
               // Hacer lo que necesites con el índice del botón presionado
            
            self?.botonPulsado(index: index)
        }
        
        filterView.selectedButtonIndex = indexBoton
                
        tableView.delegate = self
        tableView.dataSource = self
        
        // cargar los primeros datos de mis planes
        
        apiBuscarMisPlanes()
    }
    
    
    func botonPulsado(index: Int){
                    
        if(index == 0){
            
            tableView.isHidden = true
            items.removeAll()
            textoCell2 = textoNoHayDevoSeleccionados
            indexBoton = 0
            
            // MIS PLANES
            apiBuscarMisPlanes()
            
        }else if(index == 1){
            tableView.isHidden = true
            items.removeAll()
            textoCell2 = textoNoHayDevoDisponibles
            indexBoton = 1
            
            // BUSCAR PLANES NUEVOS
            apiBuscarPlanesNuevos()
        }
    }
    
        
    // BUSCAR MIS PLANES
    func apiBuscarMisPlanes(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiListadoDevoMisPlanes
        
        let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
        let idiomaPlan = UserDefaults.standard.getValueIdiomaApp()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "idiomaplan": idiomaPlan ?? 1,
            "iduser": iduser ?? 0,
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
                                
                                self.tableView.isHidden = false
                                
                                let hayInfo = json["hayinfo"].intValue
                                
                                if(hayInfo == 1){
                                    self.hayDatos = true
                                                                        
                                    json["listado"].array?.forEach({ (dataArray) in
                                                           
                                        let imagen = dataArray["imagen"].string ?? ""
                                        let titulo = dataArray["titulo"].string ?? ""
                                        let subtitulo = dataArray["subtitulo"].string ?? ""
                                        let idplan = dataArray["idplan"].int ?? 0
                                        
                                        let notification = ModeloDevocionales(imagen: imagen, titulo: titulo, subtitulo: subtitulo, idplan: idplan)
                                        self.items.append(notification)
                                    })
                                    
                                    self.tableView.reloadData()
                                    
                                }else{
                                    self.hayDatos = false
                                    let notification = ModeloDevocionales(imagen: "", titulo: "", subtitulo: "", idplan: 0)
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
        .retry()
        .subscribe(onNext: {
           
            
        }, onError: { error in
          
            MBProgressHUD.hide(for: self.view, animated: true)
        })
        .disposed(by: disposeBag)
    }
    
   
    
    
    
    // BUSCAR PLANES NUEVOS
    func apiBuscarPlanesNuevos(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiListadoDevoNuevos
        
        let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
        let idiomaPlan = UserDefaults.standard.getValueIdiomaApp()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "idiomaplan": idiomaPlan ?? 1,
            "iduser": iduser ?? 0,
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
                                
                                self.tableView.isHidden = false
                                
                                let hayInfo = json["hayinfo"].intValue
                                
                                if(hayInfo == 1){
                                    self.hayDatos = true
                                    
                                    
                                    json["listado2"].array?.forEach({ (dataArray) in
                                                           
                                        let imagen = dataArray["imagen"].string ?? ""
                                        let titulo = dataArray["titulo"].string ?? ""
                                        let subtitulo = dataArray["subtitulo"].string ?? ""
                                        let id = dataArray["id"].int ?? 0
                                                                                
                                        let notification = ModeloDevocionales(imagen: imagen, titulo: titulo, subtitulo: subtitulo, idplan: id)
                                        self.items.append(notification)
                                    })
                                    
                                    
                                    self.tableView.reloadData()
                                    
                                }else{
                                    self.hayDatos = false
                                    let notification = ModeloDevocionales(imagen: "", titulo: "", subtitulo: "", idplan: 0)
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
                 
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
        .retry()
        .subscribe(onNext: {
            
        }, onError: { error in
          
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
        
        if(hayDatos){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! DevocionalCell1
                
            let union = baseUrlImagen+selectedItem.getImagen()
      
                cell.imgDevo.sd_setImage(with: URL(string: "\(union)"), placeholderImage: UIImage(named: "fotodefecto"))
            
                cell.imgDevo.contentMode = .scaleAspectFill
                cell.imgDevo.clipsToBounds = true
                cell.imgDevo.layer.cornerRadius = 20
            
                cell.txt1Devo.numberOfLines = 0
                cell.txt1Devo.text = selectedItem.getSubtitulo()
            
                cell.txtNombre.numberOfLines = 0
                cell.txtNombre.text = selectedItem.getTitulo()
             
                cell.selectionStyle = .none
                
                return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! DevocionalCell2
                            
                cell.txtNoHay.numberOfLines = 0
                cell.txtNoHay.text = textoParaIniciarElige
            
            if(tema){
                cell.txtNoHay.textColor = .white
            }else{
                cell.txtNoHay.textColor = .black
            }
            
                cell.selectionStyle = .none
                
                return cell
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(hayDatos){
            let selectedItem = items[indexPath.row]
            
            if(selectedItem.getIdPlan() > 0){
                
                if(indexBoton == 0){
                    vistaVerPlanBloqueFecha(id: selectedItem.getIdPlan())
                }else if(indexBoton == 1){
                    vistaSeleccionarPlan(id: selectedItem.getIdPlan())
                }
            }
        }
    }
    
    func vistaVerPlanBloqueFecha(id: Int){
        let vista : MiDevocionalController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "MiDevocionalController") as! MiDevocionalController
             
        vista.idplan = id
        
        self.present(vista, animated: true, completion: nil)
    }
    
    
    
    func vistaSeleccionarPlan(id: Int){
        
        let vista : DevoInformacionController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "DevoInformacionController") as! DevoInformacionController
        
        vista.delegate = self
        vista.idplan = id
        
        self.present(vista, animated: true, completion: nil)
    }
        
  

}
