//
//  InsigniasPorGanarController.swift
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

class InsigniasPorGanarController: UIViewController, UITableViewDelegate, UITableViewDataSource {

        
    @IBOutlet weak var toolbar: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    var tema = false
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    var hayInformacion = true
    
    var items: [ModeloInsigniaPorGanar] = []
    
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
        
        toolbar.title = TextoIdiomaController.localizedString(forKey: "insignias_por_ganar")
                
        apiSolicitarDatos()
    }
    
    
    func apiSolicitarDatos(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiListadoInsigniaPorGanar
        
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
                                                                                                                        
                                        let imagen = dataArray["imagen"].string ?? ""
                                        let nombre = dataArray["titulo"].string ?? ""
                                        let descripcion = dataArray["descripcion"].string ?? ""
                                        
                                      
                                        let informacion = ModeloInsigniaPorGanar(imagen: imagen, nombre: nombre, descripcion: descripcion)
                                        
                                        self.items.append(informacion)
                                    })
                                    
                                                            
                                    self.tableView.reloadData()
                                    
                                }else{
                                 
                                    self.hayInformacion = false
                                    // para que table view cree 1 sola fila diciendo que no hay insignias
                                    let informacion = ModeloInsigniaPorGanar(imagen: "", nombre: "", descripcion: "")
                                    
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
    
    // METODOS TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
       return items.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                 
        let selectedItem = items[indexPath.row]
        
        if(hayInformacion){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! InsigniaPorGanarCellTableView
            
            let union = baseUrlImagen+selectedItem.getImagen()
      
                cell.imgInsignia.sd_setImage(with: URL(string: "\(union)"), placeholderImage: UIImage(named: "fotodefecto"))
                      
            cell.txtNombre.numberOfLines = 0
            cell.txtNombre.text = selectedItem.getNombre()
            
            if(selectedItem.getDescripcion().isEmpty){
                cell.txtDescripcion.isHidden = true
            }else{
                cell.txtDescripcion.numberOfLines = 0
                cell.txtDescripcion.text = selectedItem.getDescripcion()
            }
           
            cell.selectionStyle = .none
            
            return cell
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! InsigniaPorGanarCell2TableView
            
            cell.txtSinInsignias.numberOfLines = 0
            cell.txtSinInsignias.text = TextoIdiomaController.localizedString(forKey: "no_hay_insignias_disponibles")
                        
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    
   

}
