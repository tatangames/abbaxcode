//
//  PlanesMeHanAgregadoViewController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 22/6/24.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import RxSwift
import Toast_Swift

class PlanesMeHanAgregadoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtToolbar: UINavigationItem!
    
    var idusuario = 0
    
    var tema = false
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    var items: [ModeloMeHanAgregado] = []
  
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
        
        let texto = TextoIdiomaController.localizedString(forKey: "planes")
        
        txtToolbar.title = texto
        
        apiSolicitarDatos()
        
        if let tabBarController = tabBarController {
               tabBarController.tabBar.barTintColor = UIColor.white // Color deseado
           }
    }
    
    func apiSolicitarDatos(){
      
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiListadoMeHanAgregadoPlanes
        
        let idiomaplan = UserDefaults.standard.getValueIdiomaApp()
        let token = UserDefaults.standard.getValueTokenUsuario()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "idiomaplan": idiomaplan ?? 1,
            "id": idusuario
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
                                
                                json["listadoplan"].array?.forEach({ (dataArray) in
                                          
                                    let titulo = dataArray["titulo"].string ?? ""
                                    let informacion = ModeloMeHanAgregado(id: 0, nombre: titulo, correo: "")
                                    
                                    self.items.append(informacion)
                                })
                                                                                        
                                self.tableView.reloadData()
                                
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
    
    
    @IBAction func btnAtras(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // METODOS TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
       return items.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                 
        let selectedItem = items[indexPath.row]
        
           
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! PlanesMeHanAgregadoTableViewCell
                
        cell.txtNombre.text = selectedItem.nombre
     
        cell.selectionStyle = .none
  
        return cell
    }
    
   
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
