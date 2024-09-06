//
//  InicioTab1Controller.swift
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
import Photos
import SDWebImage
import OneSignalFramework

protocol YourTableViewCellDelegate3: AnyObject {
    func compartirButtonTapped()
    func opcionesButtonTapped()
}

protocol cellDelegateVideo: AnyObject {
    func flechaDerVideoTapped(iden: Int)
}

protocol cellDelegateVideoClick: AnyObject {
    func videoClickTapped(url: String)
}

protocol cellDelegateImagenClick: AnyObject {
    func imagenClickTapped(urlimagen: String)
}


protocol cellDelegateImagenInsigniaClick: AnyObject {
    func imagenInsigniaClickTapped(idtipoin: Int)
}

protocol cellDelegateImagenRedesClick: AnyObject {
    func imagenRedesClickTapped(link: String)
}

protocol cellDelegateImagenRecursosClick: AnyObject {
    func imagenRecursosClickTapped(link: String)
}

class InicioTab1Controller: UIViewController, UITableViewDelegate, UITableViewDataSource, YourTableViewCellDelegate3, cellDelegateVideo, cellDelegateVideoClick, cellDelegateImagenClick, OverlayViewDelegateBotonDescargar, OverlayViewDelegateBotonCompartir,cellDelegateImagenInsigniaClick, cellDelegateImagenRedesClick,
                            cellDelegateImagenRecursosClick{
  
    
    // REDIRECCIONAMIENTO REDES SOCIALES
    func imagenRedesClickTapped(link: String) {
        
        
        if let url = URL(string: link) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("No se puede abrir la URL")
            }
        }
    }
    
    // REDIRECCIONAMIENTO RECRUSOS
    func imagenRecursosClickTapped(link: String) {
        
        
        if let url = URL(string: link) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("No se puede abrir la URL")
            }
        }
    }
    
    
    
    func imagenInsigniaClickTapped(idtipoin: Int) {
        
        let vista : InfoInsigniaController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "InfoInsigniaController") as! InfoInsigniaController
        
        vista.idinsignia = idtipoin
        
        self.present(vista, animated: true, completion: nil)
    }
    
    var itemsGrupal: [ModeloGrupoInicio] = []
    
    var urlAppleStore = ""
    
    func didTapBotonDescargar(urlfoto: String) {
       
        // cuando es pulsado que el usuario quiere guardar una imagen
               
        DispatchQueue.main.async { [self] in
            
            overlayViewController?.dismiss(animated: true, completion: nil)
            
            let union = baseUrlImagen+urlfoto
            
            let imageURL = URL(string: union)!
           
            SDWebImageManager.shared.loadImage(with: imageURL, options: [], progress: nil) { (image, data, error, cacheType, finished, imageURL) in
                    guard let image = image else {
                        let texto = TextoIdiomaController.localizedString(forKey: "error_al_guardar")
                       
                        
                        DispatchQueue.main.async {
                                   // Asegúrate de ejecutar esta operación en el hilo principal
                                   self.view.makeToast(texto, duration: 3.0, position: .bottom, style: self.styleAzul)
                               }
                        return
                    }
                    
                    // Guardar la imagen en la galería
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAsset(from: image)
                    }) { success, error in
                        if success {
                           
                            let texto = TextoIdiomaController.localizedString(forKey: "guardado")
                            DispatchQueue.main.async {
                                       // Asegúrate de ejecutar esta operación en el hilo principal
                                       self.view.makeToast(texto, duration: 3.0, position: .bottom, style: self.styleAzul)
                                   }
                            
                        } else {
                          
                            let texto = TextoIdiomaController.localizedString(forKey: "error_al_guardar")
                            DispatchQueue.main.async {
                                       // Asegúrate de ejecutar esta operación en el hilo principal
                                       self.view.makeToast(texto, duration: 3.0, position: .bottom, style: self.styleAzul)
                                   }
                          
                        }
                    }
                }
        }
        
    }
    
 
    func didTapBotonCompartir(urlfoto: String) {
        DispatchQueue.main.async { [self] in
                        
            overlayViewController?.dismiss(animated: true, completion: nil)
            
            let union = baseUrlImagen+urlfoto
            
            let imageURL = URL(string: union)!
            
            shareImageFromURL(imageURL: imageURL)
        }
    }
    
    
    
    func shareImageFromURL(imageURL: URL) {
         // Descarga la imagen utilizando SDWebImage
         SDWebImageManager.shared.loadImage(with: imageURL, options: [], progress: nil) { (image, data, error, cacheType, finished, imageURL) in
             guard let image = image else {
               
                 return
             }
             
             // Comparte la imagen descargada
             self.shareImage(image: image)
         }
     }
     
     // Función para compartir una imagen
     func shareImage(image: UIImage) {
         let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
         // Excluye algunas actividades si es necesario
         activityViewController.excludedActivityTypes = [.airDrop, .addToReadingList]
         // Presenta el controlador de vista de actividad
         present(activityViewController, animated: true, completion: nil)
     }
  
    
    
    
    
    
    
    
    
    
    
    //*******************************
    
    
    
    var overlayViewController: OverlayView5?
    
    func imagenClickTapped(urlimagen: String) {
       
        overlayViewController = OverlayView5()
       
        overlayViewController?.modalPresentationStyle = .custom
        overlayViewController?.transitioningDelegate = self
        overlayViewController?.delegate5 = self
        overlayViewController?.delegate6 = self
        
        overlayViewController?.urlFoto = urlimagen
        
        self.present(overlayViewController!, animated: true, completion: nil)
    }
    
   
    // cuando se toca una celda del collection view de videos
    func videoClickTapped(url: String) {
        
        if let url = URL(string: url) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("No se puede abrir la URL")
            }
        }
    }
    
    
    
    func flechaDerVideoTapped(iden: Int){
        
        if(iden == 1){
            let vista : InfoVideosController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "InfoVideosController") as! InfoVideosController
                        
            self.present(vista, animated: true, completion: nil)
        }else{
            let vista : ListaImagenesController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "ListaImagenesController") as! ListaImagenesController
                        
            self.present(vista, animated: true, completion: nil)
        }
      
    }
    
    
    
    func compartirButtonTapped() {
        compartirDevocional()
    }
    
    func opcionesButtonTapped() {
        
        let vista : MiDevocionalController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "MiDevocionalController") as! MiDevocionalController
        
        vista.idplan = devoPlan
        
        self.present(vista, animated: true, completion: nil)
    }
    
  
   
    
  

    var tema = false
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
  
    
    var videoMayor5 = 0
    var imagenesMayor5 = 0
    var insigniaMayor5 = 0
    var devoHayDevocional = 0
    var devoIdBlockDeta = 0
    var videoHayVideos = 0
    var imagenesHayHoy = 0
    var comparteAppImagen = ""
    var comparteAppTitulo = ""
    var comparteAppDescrip = ""
    var insigniasHay = 0
    var devoPreguntas = 0
    var devoPlan = 0
    var devoCuestionario = ""
    var hayredes = 0
    var hayrecursos = 0
    
    // datos para rachas
    var d1 = 0
    var d2 = 0
    var d3 = 0
    var d4 = 0
    var d5 = 0
    var d6 = 0
    var d7 = 0
    var d8 = 0
    var d9 = 0
    var d10 = 0
        
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var idFirebase = ""
    
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
  
        
        // IDENTIFICADOR ONE SIGNAL
        let id: String = OneSignal.User.pushSubscription.id ?? ""
        idFirebase = id
        
        apiSolicitarDatos()
    }
    
    /*@objc func refrescarDatos() {
        apiSolicitarDatos()
    }*/
    
    func apiSolicitarDatos(){
                
        tableView.isHidden = true
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiListadoInfoInicio
        
        let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
        let idiomaPlan = UserDefaults.standard.getValueIdiomaApp()
      
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "iduser": iduser ?? 0,
            "idiomaplan": idiomaPlan ?? 0,
            "idonesignal": idFirebase
        ]
        
        Observable<Void>.create { observer in
            let request = AF.request(encodeURL, method: .post, parameters: parameters, headers: headers)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
              
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        let json = JSON(data)
                        
                       // self.refreshControl.endRefreshing()
                        
                        if let successValue = json["success"].int {
                            
                            if(successValue == 1){
                                
                                self.urlAppleStore = json["urlapple"].string ?? ""
                                self.videoMayor5 = json["videomayor5"].int ?? 0
                                self.imagenesMayor5 = json["imagenesmayor5"].int ?? 0
                                self.insigniaMayor5 = json["insigniasmayor5"].int ?? 0
                                self.devoHayDevocional = json["devohaydevocional"].int ?? 0
                                self.devoIdBlockDeta = json["devoidblockdeta"].int ?? 0
                                self.videoHayVideos = json["videohayvideos"].int ?? 0
                                self.imagenesHayHoy = json["imageneshayhoy"].int ?? 0
                              
                                self.comparteAppImagen = json["comparteappimagen"].string ?? ""
                                self.comparteAppTitulo = json["comparteapptitulo"].string ?? ""
                                self.comparteAppDescrip = json["comparteappdescrip"].string ?? ""
                               
                                self.insigniasHay = json["insigniashay"].int ?? 0
                                self.devoPreguntas = json["devopreguntas"].int ?? 0
                                self.devoPlan = json["devoplan"].int ?? 0
                                self.devoCuestionario = json["devocuestionario"].string ?? ""
                                self.hayredes = json["hayredes"].int ?? 0
                                self.hayrecursos = json["hayrecursos"].int ?? 0
                                
                                
                                var itemBloqueVideo: [ModeloInicioVideos] = []
                                var itemBloqueImagen: [ModeloInicioImagenes] = []
                                var itemBloqueInsignias: [ModeloInicioInsignias] = []
                                var itemBloqueRedes: [ModeloInicioRedes] = []
                                var itemBloqueRecursos: [ModeloRecursos] = []
                                
                                if(self.devoHayDevocional == 1){
                                    let bloqueInicio = ModeloGrupoInicio(tipo: 1,
                                                                         arrayVideos: [ModeloInicioVideos(imagen: "", urlvideo: "", titulo: "")],
                                                                         
                                                                         arrayImagenes: [ModeloInicioImagenes(descripcion: "", imagen: "")],
                                                                         arrayInsignias: [ModeloInicioInsignias(idtipoinsignia: 0, titulo: "", descripcion: "", nivelvoy: 0, imagen: "")],
                                                                         arrayRedes: [ModeloInicioRedes(nombre: "", link: "", imagen: "")],
                                                                         arrayRecursos: [ModeloRecursos(nombre: "", link: "", imagen: "")]
                                    )
                                    
                                                                        
                                    self.itemsGrupal.append(bloqueInicio)
                                }
                                
                                
                                //**********
                                
                                json["arrayfinalvideo"].array?.forEach({ (dataArray) in
                                                       
                                    let miimagen = dataArray["imagen"].string ?? ""
                                    let miurl = dataArray["url_video"].string ?? ""
                                    let mititulo = dataArray["titulo"].string ?? ""
                                                                                                             
                                    let bV = ModeloInicioVideos(imagen: miimagen, urlvideo: miurl, titulo: mititulo)
                                    itemBloqueVideo.append(bV)
                                })
                                
                                if(!itemBloqueVideo.isEmpty){
                                    // BLOQUE VIDEOS
                                    if(self.videoHayVideos == 1){
                                        let bloqueV = ModeloGrupoInicio(tipo: 2, arrayVideos: itemBloqueVideo, arrayImagenes: [ModeloInicioImagenes(descripcion: "", imagen: "")], arrayInsignias: [ModeloInicioInsignias(idtipoinsignia: 0,titulo: "", descripcion: "", nivelvoy: 0, imagen: "")],
                                            arrayRedes: [ModeloInicioRedes(nombre: "", link: "", imagen: "")],
                                            arrayRecursos: [ModeloRecursos(nombre: "", link: "", imagen: "")]
                                                                
                                        )
                                        self.itemsGrupal.append(bloqueV)
                                    }
                                }
                                          
                                
                                //************
                                
                                json["arrayfinalimagenes"].array?.forEach({ (dataArray) in
                                                       
                                    let miimagen = dataArray["imagen"].string ?? ""
                                    let midescr = dataArray["descripcion"].string ?? ""
                                                                                                             
                                    let bV = ModeloInicioImagenes(descripcion: midescr, imagen: miimagen)
                                    itemBloqueImagen.append(bV)
                                })
                                
                                if(!itemBloqueImagen.isEmpty){
                                    // BLOQUE IMAGENES
                                    if(self.imagenesHayHoy == 1){
                                        let bloqueV = ModeloGrupoInicio(tipo: 3, arrayVideos: itemBloqueVideo, arrayImagenes: itemBloqueImagen, arrayInsignias: [ModeloInicioInsignias(idtipoinsignia: 0,titulo: "", descripcion: "", nivelvoy: 0, imagen: "")],
                                            arrayRedes: [ModeloInicioRedes(nombre: "", link: "", imagen: "")],
                                            arrayRecursos: [ModeloRecursos(nombre: "", link: "", imagen: "")]
                                        
                                        )
                                        
                                        
                                        self.itemsGrupal.append(bloqueV)
                                    }
                                }
                                    
                                    
                                //**************
                                // COMPARTE APP
                                let bloqueCC = ModeloGrupoInicio(tipo: 4, arrayVideos: [ModeloInicioVideos(imagen: "", urlvideo: "", titulo: "")], arrayImagenes: [ModeloInicioImagenes(descripcion: "", imagen: "")], arrayInsignias: [ModeloInicioInsignias(idtipoinsignia: 0,titulo: "", descripcion: "", nivelvoy: 0, imagen: "")],
                                    arrayRedes: [ModeloInicioRedes(nombre: "", link: "", imagen: "")],
                                    arrayRecursos: [ModeloRecursos(nombre: "", link: "", imagen: "")]
                                )
                                
                                self.itemsGrupal.append(bloqueCC)
                                
                                
                                //************
                                // RACHAS
                                
                                
                                json["arrayracha"].array?.forEach({ (dataArray) in
                                                       
                                    self.d1 = dataArray["diasesteanio"].int ?? 0
                                    self.d2 = dataArray["diasconcecutivos"].int ?? 0
                                    self.d3 = dataArray["nivelrachaalta"].int ?? 0
                                    self.d4 = dataArray["domingo"].int ?? 0
                                    self.d5 = dataArray["lunes"].int ?? 0
                                    self.d6 = dataArray["martes"].int ?? 0
                                    self.d7 = dataArray["miercoles"].int ?? 0
                                    self.d8 = dataArray["jueves"].int ?? 0
                                    self.d9 = dataArray["viernes"].int ?? 0
                                    self.d10 = dataArray["sabado"].int ?? 0
                                })
                                
                                
                                let bloqueR = ModeloGrupoInicio(tipo: 5, arrayVideos: [ModeloInicioVideos(imagen: "", urlvideo: "", titulo: "")], arrayImagenes: [ModeloInicioImagenes(descripcion: "", imagen: "")], arrayInsignias: [ModeloInicioInsignias(idtipoinsignia: 0,titulo: "", descripcion: "", nivelvoy: 0, imagen: "")],
                                    arrayRedes: [ModeloInicioRedes(nombre: "", link: "", imagen: "")],
                                    arrayRecursos: [ModeloRecursos(nombre: "", link: "", imagen: "")]
                                )
                                
                                self.itemsGrupal.append(bloqueR)
                              
                                
                                //*********** LLENAR LAS INSIGNIAS   ***********
                                
                                if(self.insigniasHay == 1){
                                    
                                    json["arrayfinalinsignias"].array?.forEach({ (dataArray) in
                                                 
                                        let idtipo = dataArray["id_tipo_insignia"].int ?? 0
                                        let titulo = dataArray["titulo"].string ?? ""
                                        let descripcion = dataArray["descripcion"].string ?? ""
                                        let nivelvoy = dataArray["nivelvoy"].int ?? 0
                                        let imagen = dataArray["imageninsignia"].string ?? ""
                                      
                                        let bV = ModeloInicioInsignias(idtipoinsignia: idtipo,titulo: titulo, descripcion: descripcion, nivelvoy: nivelvoy, imagen: imagen)
                                        itemBloqueInsignias.append(bV)
                                    })
                                    
                                    
                                    let bloqueI = ModeloGrupoInicio(tipo: 6, arrayVideos: [ModeloInicioVideos(imagen: "", urlvideo: "", titulo: "")], arrayImagenes: [ModeloInicioImagenes(descripcion: "", imagen: "")], arrayInsignias: itemBloqueInsignias,
                                        arrayRedes: [ModeloInicioRedes(nombre: "", link: "", imagen: "")],
                                        arrayRecursos: [ModeloRecursos(nombre: "", link: "", imagen: "")]
                                    )
                                                                        
                                    self.itemsGrupal.append(bloqueI)
                                }
                                       
                                
                                
                                //*********** LLENAR DE RECURSOS   ***********
                                
                                if(self.hayrecursos == 1){
                                    
                                    json["arrayrecursos"].array?.forEach({ (dataArray) in
                                                 
                                        let minombre = dataArray["nombre"].string ?? ""
                                        let milink = dataArray["link"].string ?? ""
                                        let miimagen = dataArray["imagen"].string ?? ""
                                      
                                        let bV = ModeloRecursos(nombre: minombre, link: milink, imagen: miimagen)
                                        itemBloqueRecursos.append(bV)
                                    })
                                    
                                    
                                    let bloqueI = ModeloGrupoInicio(tipo: 7, arrayVideos: [ModeloInicioVideos(imagen: "", urlvideo: "", titulo: "")], arrayImagenes: [ModeloInicioImagenes(descripcion: "", imagen: "")], arrayInsignias: [ModeloInicioInsignias(idtipoinsignia: 0, titulo: "", descripcion: "", nivelvoy: 0, imagen: "")],
                                        arrayRedes: [ModeloInicioRedes(nombre: "", link: "", imagen: "")],
                                        arrayRecursos: itemBloqueRecursos
                                    )
                                                                        
                                    self.itemsGrupal.append(bloqueI)
                                }
                                
                                
                                
                                //*********** LLENAR LAS REDES SOCIALES   ***********
                                
                                if(self.hayredes == 1){
                                    
                                    json["arrayredes"].array?.forEach({ (dataArray) in
                                                 
                                        let minombre = dataArray["nombre"].string ?? ""
                                        let milink = dataArray["link"].string ?? ""
                                        let miimagen = dataArray["imagen"].string ?? ""
                                      
                                        let bV = ModeloInicioRedes(nombre: minombre, link: milink, imagen: miimagen)
                                        itemBloqueRedes.append(bV)
                                    })
                                    
                                    
                                    let bloqueI = ModeloGrupoInicio(tipo: 8, arrayVideos: [ModeloInicioVideos(imagen: "", urlvideo: "", titulo: "")], arrayImagenes: [ModeloInicioImagenes(descripcion: "", imagen: "")], arrayInsignias: [ModeloInicioInsignias(idtipoinsignia: 0, titulo: "", descripcion: "", nivelvoy: 0, imagen: "")],
                                        arrayRedes: itemBloqueRedes,
                                        arrayRecursos: [ModeloRecursos(nombre: "", link: "", imagen: "")]
                                    )
                                                                        
                                    self.itemsGrupal.append(bloqueI)
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
    
    var unaVezReloadVideo = false
    var unaVezReloadImagen = false
    var unaVezReloadInsignia = false
    
    func recargarVista(){
        let instanciaTema = TemaController()
        if( instanciaTema.conocerTemaActual() == 1){
            tema = true
            overrideUserInterfaceStyle = .dark
        }else{
            tema = false
            overrideUserInterfaceStyle = .light
        }
        
        unaVezReloadVideo = true
        unaVezReloadImagen = true
        unaVezReloadInsignia = true
        
        if(tableView != nil){
            tableView.isHidden = true
            itemsGrupal.removeAll()
            apiSolicitarDatos()
        }
    }
    
    
    
    
    
    // METODOS TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
       return itemsGrupal.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                 
        let selectedItem = itemsGrupal[indexPath.row]
        
        if(selectedItem.tipo == 1){
            
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! InicioCell1
                                    
                    
            cell.txtEtiqueta.text = TextoIdiomaController.localizedString(forKey: "devocional_del_dia")
                      
            if(devoCuestionario.isEmpty){
                cell.txtDevo.text = ""
            }else{
                if let attributedText = extraerTextoHTML(htmlString: devoCuestionario) {
                    cell.txtDevo.attributedText = attributedText
                    
                    cell.txtDevo.font = UIFont.systemFont(ofSize: 16, weight: .bold)
                }else{
                    cell.txtDevo.text = ""
                }
            }
                      
          
            
            cell.imgCompartir.image = UIImage(named: "ic_share")?.withRenderingMode(.alwaysTemplate)
            cell.imgOpciones.image = UIImage(named: "puntos")?.withRenderingMode(.alwaysTemplate)
            
            cell.imgCompartir.isUserInteractionEnabled = true
            cell.imgOpciones.isUserInteractionEnabled = true
            cell.delegate = self
            
            if(tema){
                cell.imgOpciones.tintColor = UIColor.white
                cell.imgCompartir.tintColor = UIColor.white
                
                cell.txtDevo.textColor = .white
            }else{
                cell.imgOpciones.tintColor = UIColor.black
                cell.imgCompartir.tintColor = UIColor.black
                
                cell.txtDevo.textColor = .black
            }
              
            cell.txtDevo.numberOfLines = 0 // Permite múltiples líneas
               
            cell.selectionStyle = .none
            
            return cell
        }
        else if(selectedItem.tipo == 2){
            
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! InicioCell2
            cell.imgFlechaDer.image = UIImage(named: "flecha_derecha")?.withRenderingMode(.alwaysTemplate)
           
            if(unaVezReloadVideo){
                unaVezReloadVideo = false
                cell.miCollection.reloadData()
            }
            
            cell.vista.layer.cornerRadius = 20
            cell.vista.clipsToBounds = true

            if(tema){
                cell.vista.backgroundColor = UIColor.white
                cell.miCollection.backgroundColor = UIColor.white
            }else{
                cell.vista.backgroundColor = UIColor.systemGray6
                cell.miCollection.backgroundColor = UIColor.systemGray6
            }
                        
            
            
            cell.imgFlechaDer.tintColor = UIColor.black
            
            cell.imgFlechaDer.isUserInteractionEnabled = true
            cell.delegate = self
            
            if(videoMayor5 == 1){
                cell.imgFlechaDer.isHidden = false
            }else{
                cell.imgFlechaDer.isHidden = true
            }
            
            cell.delegate2 = self
            cell.propios = selectedItem.arrayVideos
            
            cell.txtVideo.text = TextoIdiomaController.localizedString(forKey: "videos")
            cell.txtVideo.textColor = .black
            
            
            
            cell.miCollection.tag = indexPath.section
            
            cell.selectionStyle = .none

            return cell
        }
        else if(selectedItem.tipo == 3){
                      
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! InicioCell3
            cell.imgFlechaDer.image = UIImage(named: "flecha_derecha")?.withRenderingMode(.alwaysTemplate)
            
            if(unaVezReloadImagen){
                unaVezReloadImagen = false
                cell.miCollection.reloadData()
            }
            
            cell.vista.layer.cornerRadius = 20
            cell.vista.clipsToBounds = true
            
            if(tema){
                cell.vista.backgroundColor = UIColor.white
                cell.miCollection.backgroundColor = UIColor.white
            }else{
                cell.vista.backgroundColor = UIColor.systemGray6
                cell.miCollection.backgroundColor = UIColor.systemGray6
            }
         
            
            
            cell.imgFlechaDer.tintColor = UIColor.black
            
            cell.imgFlechaDer.isUserInteractionEnabled = true
            cell.delegate = self
            
            if(videoMayor5 == 1){
                cell.imgFlechaDer.isHidden = false
            }else{
                cell.imgFlechaDer.isHidden = true
            }
            
            cell.delegate3 = self
            cell.propios = selectedItem.arrayImagenes
            
            
            cell.txtVideo.text = TextoIdiomaController.localizedString(forKey: "imagenes_del_dia")
            cell.txtVideo.textColor = .black
            
            cell.miCollection.tag = indexPath.section
            
            cell.selectionStyle = .none

            return cell
        }
        else if(selectedItem.tipo == 4){
                      
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! InicioCell4
                       
            cell.vista.layer.cornerRadius = 20
            cell.vista.clipsToBounds = true
            cell.vista.backgroundColor = UIColor.white
            
            cell.txtTitulo.numberOfLines = 0
            cell.txtDescripcion.numberOfLines = 0
            
            cell.txtTitulo.text = comparteAppTitulo
            cell.txtDescripcion.text = comparteAppDescrip
            
            cell.txtTitulo.textColor = .black
            cell.txtDescripcion.textColor = .black
            
            let union = baseUrlImagen+comparteAppImagen
            cell.imgFoto.sd_setImage(with: URL(string: "\(union)"), placeholderImage: UIImage(named: "fotodefecto"))
                
            
            cell.imgFoto.layer.cornerRadius = 10 // Elige el radio deseado

            // Asegúrate de que las esquinas redondeadas se apliquen correctamente
            cell.imgFoto.layer.masksToBounds = true
            
         
            cell.selectionStyle = .none

            return cell
        }
        else if(selectedItem.tipo == 5){
                      
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath) as! InicioCell5
           
            
            cell.vista.layer.cornerRadius = 20
            // Habilita la máscara de recorte para que las subvistas sigan la forma de las esquinas redondeadas
            cell.vista.clipsToBounds = true
            cell.vista.backgroundColor = UIColor.white
            
            
            let textoRachaMasAlta = TextoIdiomaController.localizedString(forKey: "racha_mas_alta")
            let textoDiaSeguido = TextoIdiomaController.localizedString(forKey: "dias_seguidos")
            let esteAnio = TextoIdiomaController.localizedString(forKey: "dias_app_este_anio")
            
            cell.txtDias.textColor = .black
            cell.txtDiasNum.textColor = .black
            cell.txtRachaAlta.textColor = .black
            cell.txtAppEsteAnio.textColor = .black
            cell.txtRachaAltaNum.textColor = .black
            
            
            let circulo = "crono_circulo"
            let cronometro = "cronometro"
                        
            cell.txtRachaAltaNum.text = String(d3)
            cell.txtRachaAlta.text = textoRachaMasAlta
            
            cell.txtDiasNum.text = String(d2)
            cell.txtDias.text = textoDiaSeguido
            
            cell.txtAppEsteAnio.text = String(d1) + " " + esteAnio
            
                     
            if(d5 == 1){
                cell.imgL.image = UIImage(named: cronometro)
            }else{
                cell.imgL.image = UIImage(named: circulo)
            }
            
            if(d6 == 1){
                cell.imgM.image = UIImage(named: cronometro)
            }else{
                cell.imgM.image = UIImage(named: circulo)
            }
            
            if(d7 == 1){
                cell.imgMM.image = UIImage(named: cronometro)
            }else{
                cell.imgMM.image = UIImage(named: circulo)
            }
            
            if(d8 == 1){
                cell.imgJ.image = UIImage(named: cronometro)
            }else{
                cell.imgJ.image = UIImage(named: circulo)
            }
            
            if(d9 == 1){
                cell.imgV.image = UIImage(named: cronometro)
            }else{
                cell.imgV.image = UIImage(named: circulo)
            }
            
            if(d10 == 1){
                cell.imgS.image = UIImage(named: cronometro)
            }else{
                cell.imgS.image = UIImage(named: circulo)
            }
            
            if(d4 == 1){
                cell.imgD.image = UIImage(named: cronometro)
            }else{
                cell.imgD.image = UIImage(named: circulo)
            }
            
            
            
            let textoL = TextoIdiomaController.localizedString(forKey: "letra_lunes")
            let textoM = TextoIdiomaController.localizedString(forKey: "letra_martes")
            let textoMM = TextoIdiomaController.localizedString(forKey: "letra_miercoles")
            let textoJ = TextoIdiomaController.localizedString(forKey: "letra_jueves")
            let textoV = TextoIdiomaController.localizedString(forKey: "letra_viernes")
            let textoS = TextoIdiomaController.localizedString(forKey: "letra_sabado")
            let textoD = TextoIdiomaController.localizedString(forKey: "letra_domingo")
            
            cell.txtL.text = textoL
            cell.txtL.textColor = .black
            
            cell.txtM.text = textoM
            cell.txtM.textColor = .black

            cell.txtMM.text = textoMM
            cell.txtMM.textColor = .black
            
            cell.txtJ.text = textoJ
            cell.txtJ.textColor = .black
            
            cell.txtV.text = textoV
            cell.txtV.textColor = .black
            
            cell.txtS.text = textoS
            cell.txtS.textColor = .black
            
            cell.txtD.text = textoD
            cell.txtD.textColor = .black
            
            
         
            cell.selectionStyle = .none

            return cell
        }
        else if(selectedItem.tipo == 6){
                      
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell6", for: indexPath) as! InicioCell6
          
          
            if(unaVezReloadInsignia){
                unaVezReloadInsignia = false
                cell.miCollection.reloadData()
            }
            
            cell.vista.layer.cornerRadius = 20
            cell.vista.clipsToBounds = true
            
            if(tema){
                cell.vista.backgroundColor = UIColor.white
                cell.miCollection.backgroundColor = UIColor.white
            }else{
                cell.vista.backgroundColor = UIColor.systemGray6
                cell.miCollection.backgroundColor = UIColor.systemGray6
            }
            
            
      
            cell.titulo.text = TextoIdiomaController.localizedString(forKey: "insignias")
            cell.titulo.textColor = .black
            
                   
                        
            cell.delegate6 = self
            cell.propios = selectedItem.arrayInsignias
            
  
                        
            cell.miCollection.tag = indexPath.section
            
            cell.selectionStyle = .none

            return cell
        }
        else if(selectedItem.tipo == 7){
                      
            // BLOQUE DE RECURSOS
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell8", for: indexPath) as! InicioCell8
                      
            cell.vista.layer.cornerRadius = 20
            cell.vista.clipsToBounds = true
            
            if(tema){
                cell.vista.backgroundColor = UIColor.white
                cell.miCollection.backgroundColor = UIColor.white
            }else{
                cell.vista.backgroundColor = UIColor.systemGray6
                cell.miCollection.backgroundColor = UIColor.systemGray6
            }
                  
            cell.titulo.text = TextoIdiomaController.localizedString(forKey: "recursos")
            cell.titulo.textColor = .black
                               
                        
            cell.delegate8 = self
            cell.propios = selectedItem.arrayRecursos
             
            cell.miCollection.tag = indexPath.section
            
            cell.selectionStyle = .none

            return cell
        }
        else if(selectedItem.tipo == 8){
                      
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell7", for: indexPath) as! InicioCell7
                      
            cell.vista.layer.cornerRadius = 20
            cell.vista.clipsToBounds = true
            
            if(tema){
                cell.vista.backgroundColor = UIColor.white
                cell.miCollection.backgroundColor = UIColor.white
            }else{
                cell.vista.backgroundColor = UIColor.systemGray6
                cell.miCollection.backgroundColor = UIColor.systemGray6
            }
            
            
      
            cell.titulo.text = TextoIdiomaController.localizedString(forKey: "redes_sociales")
            cell.titulo.textColor = .black
                               
                        
            cell.delegate7 = self
            cell.propios = selectedItem.arrayRedes
            
  
                        
            cell.miCollection.tag = indexPath.section
            
            cell.selectionStyle = .none

            return cell
        }
        
        
        
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = itemsGrupal[indexPath.row]
        
        if(selected.tipo == 4){
            compartirApp()
        }
    }
    
    
    func compartirApp(){
           // URL de tu aplicación en la App Store
           guard let appURL = URL(string: "https://apps.apple.com/app/mi-caminar-con-dios/id6480132659") else {
               print("URL de la aplicación inválida.")
               return
           }
                             
           // Elementos para compartir: el mensaje y el enlace de la aplicación
           let items: [Any] = ["", appURL]
        
        
            peticionApiCompartirApp()
           
           // Crea y presenta el controlador de vista de actividad
           let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
           present(activityViewController, animated: true, completion: nil)
    }
    
    var boolCompartirApi = true
    
    
    func peticionApiCompartirApp(){
        
        if(boolCompartirApi){
            
            boolCompartirApi = false
            
            let encodeURL = apiCompartirAplicacion
            
            let iduser = UserDefaults.standard.getValueIdUsuario()
            let token = UserDefaults.standard.getValueTokenUsuario()
            let idiomaplan = UserDefaults.standard.getValueIdiomaApp()
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token ?? "")"
              ]
            
            let parameters: [String: Any] = [
                "iduser": iduser ?? 0,
                "idiomaplan": idiomaplan ?? 1
            ]
            
            Observable<Void>.create { observer in
                let request = AF.request(encodeURL, method: .post, parameters: parameters, headers: headers)
                    .responseData { response in
                        switch response.result {
                        case .success(_):
                            MBProgressHUD.hide(for: self.view, animated: true)
                           // let json = JSON(data)
                            
                            self.boolCompartirApi = true
                            
                           
                        case .failure(_):
                            self.boolCompartirApi = true
                          print("fallo")
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
                
            })
            .disposed(by: disposeBag)
        
        
        }
    }
    
    
    
    // TEXTO CORTADO QUE SALE
    
    func extraerTextoHTML(htmlString: String) -> NSAttributedString? {
        // Convierte el texto HTML en un NSAttributedString
        if let attributedString = try? NSAttributedString(data: htmlString.data(using: .utf16)!,
                                                           options: [.documentType: NSAttributedString.DocumentType.html],
                                                           documentAttributes: nil) {
            // Extrae el texto del NSAttributedString
            let texto = attributedString.string
            
            // Verifica la longitud del texto
            if texto.count > 400 {
                // Si supera los 400 caracteres, recorta el texto y agrega puntos suspensivos
                let indice = texto.index(texto.startIndex, offsetBy: 400)
                let textoRecortado = texto[..<indice] + "..."
                
                // Crea un NSAttributedString con el texto recortado
                let attributedText = NSAttributedString(string: String(textoRecortado))
                return attributedText
            } else {
                // Si no supera los 400 caracteres, devuelve el NSAttributedString original
                return attributedString
            }
        }
        return nil
    }

 
    
    func compartirDevocional(){
        
        let formateado = extraerTextoHTMLCompleto(htmlString: devoCuestionario) ?? ""
        
            compartirDevo(texto: formateado, desde: self)
    }
  
    // COMPARTIR TODO EL TEXTO
    
    func extraerTextoHTMLCompleto(htmlString: String) -> String? {
        // Convierte el texto HTML en un NSAttributedString
        if let attributedString = try? NSAttributedString(data: htmlString.data(using: .utf16)!,
                                                           options: [.documentType: NSAttributedString.DocumentType.html],
                                                           documentAttributes: nil) {
            // Extrae el texto del NSAttributedString
            let texto = attributedString.string
            return texto
        }
        return ""
    }
    
    
    func compartirDevo(texto: String, desde viewController: UIViewController) {
        // Crea un objeto UIActivityViewController con el texto a compartir
        let activityViewController = UIActivityViewController(activityItems: [texto], applicationActivities: nil)
        
        // Configura el estilo del popover en dispositivos iPad
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        // Muestra el controlador de actividad
        viewController.present(activityViewController, animated: true, completion: nil)
    }

}

extension InicioTab1Controller: UIViewControllerTransitioningDelegate {
      
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        CodigoModalBibliaHtml(presentedViewController: presented, presenting: presenting)
    }
   
    
}
