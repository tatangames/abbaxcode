//
//  ComunidadPlanesAgregadoViewController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 21/6/24.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import RxSwift
import Toast_Swift
import SDWebImage

class ComunidadPlanesAgregadoViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    // PANTALLA QUE CARGA LOS PLANES QUE YO AGREGUE A PLANES COMUNIDAD

    
    @IBOutlet weak var tableView: UITableView!
    
    var tema = false
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    var items: [ModeloPlanSimple] = []
  
    
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
        
        apiSolicitarDatos()
        
        if let tabBarController = tabBarController {
               tabBarController.tabBar.barTintColor = UIColor.white // Color deseado
           }
    }
    
    func apiSolicitarDatos(){
             
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiListadoPlanesComunidadYoAdd
        
        let idiomaplan = UserDefaults.standard.getValueIdiomaApp()
        let token = UserDefaults.standard.getValueTokenUsuario()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "idiomaplan": idiomaplan ?? 1
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
                                    
                                 
                                    json["listadoplan"].array?.forEach({ (dataArray) in
                                                       
                                        let idplan = dataArray["id_planes"].int ?? 0
                                        let titulo = dataArray["titulo"].string ?? ""
                                        let imagen = dataArray["imagen"].string ?? ""
                                                                              
                                        let informacion = ModeloPlanSimple(idplanes: idplan, titulo: titulo, imagen: imagen)
                                        
                                        self.items.append(informacion)
                                    })
                                    
                                                            
                                    self.tableView.reloadData()
                                    
                                }else{
                                    // no hay planes que agregue a comunidad
                                    self.mensajeSinInfo()
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
  
    func mensajeSinInfo(){
        let msg = TextoIdiomaController.localizedString(forKey: "no_hay_informacion")
        mensajeToastAzul(mensaje: msg)
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
        
           
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! ComunidadPlanesAgregadoTableViewCell
        
        let union = baseUrlImagen+selectedItem.imagen
  
        cell.imgFoto.sd_setImage(with: URL(string: "\(union)"), placeholderImage: UIImage(named: "fotodefecto"))
    
        cell.imgFoto.clipsToBounds = true
        cell.imgFoto.layer.cornerRadius = 20
    
        cell.txtTitulo.numberOfLines = 0
        cell.txtTitulo.text = selectedItem.titulo
                            
        cell.selectionStyle = .none
  
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItem = items[indexPath.row]
        vistaComoVan(idplan: selectedItem.idplanes)
    }
    
    
    func vistaComoVan(idplan: Int){
        
        let vista : ComoVanViewController = UIStoryboard(name: "Main3", bundle: nil).instantiateViewController(withIdentifier: "ComoVanViewController") as! ComoVanViewController
        
        vista.idPlan = idplan
        
        self.present(vista, animated: true, completion: nil)
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

