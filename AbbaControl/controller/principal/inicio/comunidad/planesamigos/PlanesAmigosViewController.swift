//
//  PlanesAmigosViewController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 17/5/24.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import RxSwift
import Toast_Swift
import SDWebImage

class PlanesAmigosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var idSolicitud = 0
    var idUsuarioBuscado = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    var tema = false
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    
    var items: [ModeloPlanesAmigos] = []
    
    
    @IBOutlet weak var txtTitulo: UINavigationItem!
    
    
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
        tableView.separatorStyle = .singleLine
        
        let texto = TextoIdiomaController.localizedString(forKey: "planes")
        
        txtTitulo.title = texto
        
        
        
        apiBuscarDatos()
    }
    
    
    func apiBuscarDatos(){
                
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiListaPlanesAmigos
        
        let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
        let idiomaPlan = UserDefaults.standard.getValueIdiomaApp()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "iduser": iduser ?? 0,
            "idsolicitud": idSolicitud,
            "idiomaplan": idiomaPlan ?? 0
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
                                
                               let miUsuarioBuscado = json["usuariobuscado"].int ?? 0
                               let hayinfo = json["hayinfo"].int ?? 0
                                
                                self.idUsuarioBuscado = miUsuarioBuscado
                                                                
                                
                                if(hayinfo == 1){
                                   
                                    // hay informacion
                                    
                                    json["listadoplan"].array?.forEach({ (dataArray) in
                                                           
                                        let miID = dataArray["id"].int ?? 0
                                        let miIDPlanes = dataArray["id_planes"].int ?? 0
                                        let miFecha = dataArray["fecha"].string ?? ""
                                        let miImagen = dataArray["imagen"].string ?? ""
                                        let miTitulo = dataArray["titulo"].string ?? ""
                                                                                
                                        
                                        let bloque = ModeloPlanesAmigos(id: miID, idplanes: miIDPlanes, fecha: miFecha, imagen: miImagen, titulo: miTitulo)
                                        
                                        self.items.append(bloque)
                                    })
                                    
                                    self.tableView.reloadData()
                                    
                                }else{
                                    
                                    self.alertaNoHayPlanes()
                                }
                                
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
    
    
    func alertaNoHayPlanes(){
        
        let texto = TextoIdiomaController.localizedString(forKey: "no_hay_planes_disponibles")
        
        mensajeToastAzul(mensaje: texto)
    }
    
    func mensajeSinConexion(){
        let msg = TextoIdiomaController.localizedString(forKey: "sin_conexion_a_internet")
        mensajeToastAzul(mensaje: msg)
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }

    @IBAction func btnAtras(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // METODOS TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
       return items.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                 
        let selectedItem = items[indexPath.row]
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlanesAmigosTableViewCell
        
        cell.txtNombre.text = selectedItem.titulo
                
        let union = baseUrlImagen+selectedItem.imagen
        cell.imgFoto.sd_setImage(with: URL(string: "\(union)"), placeholderImage: UIImage(named: "fotodefecto"))
        
        
        cell.imgFoto.contentMode = .scaleAspectFit
        cell.imgFoto.clipsToBounds = true
        cell.imgFoto.layer.cornerRadius = 20
                       
        cell.selectionStyle = .none
            
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItem = items[indexPath.row]
        
        vistaPlanesItems(idplan: selectedItem.idplanes)
    }
    
    
    func vistaPlanesItems(idplan: Int){
        
        
        let vista : DevoItemsAmigosController = UIStoryboard(name: "Main3", bundle: nil).instantiateViewController(withIdentifier: "DevoItemsAmigosController") as! DevoItemsAmigosController
        
        vista.idPlan = idplan
        vista.idUserBuscado = idUsuarioBuscado
        
        self.present(vista, animated: true, completion: nil)
    }
    

}
