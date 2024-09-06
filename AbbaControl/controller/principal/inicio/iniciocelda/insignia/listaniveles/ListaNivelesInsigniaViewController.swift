//
//  ListaNivelesInsigniaViewController.swift
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

class ListaNivelesInsigniaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    // PANTALLA MUESTRA UN LISTADO DE TODOS LOS NIVELES QUE TIENE UNA X INSIGNIA
   
    @IBOutlet weak var tableView: UITableView!
    
    var tema = false
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    var items: [ModeloListaNivel] = []
    var textoNivel = ""
    
    var idTipoInsignia = 0
    
    @IBOutlet weak var toolbar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        let instanciaTema = TemaController()
        if( instanciaTema.conocerTemaActual() == 1){
            tema = true
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
        
        textoNivel = TextoIdiomaController.localizedString(forKey: "nivel")
        
        toolbar.title = TextoIdiomaController.localizedString(forKey: "niveles")
        
        
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
     
        apiSolicitarDatos()
        
        if let tabBarController = tabBarController {
               tabBarController.tabBar.barTintColor = UIColor.white // Color deseado
           }
    }
    
    
    func apiSolicitarDatos(){
                   
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiListaNivelesInsignia
        
        let token = UserDefaults.standard.getValueTokenUsuario()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "idtipoinsignia": idTipoInsignia
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
                                                                 
                                json["listado"].array?.forEach({ (dataArray) in
                                                       
                                    let nivel = dataArray["nivel"].int ?? 0
                                    
                                    let concatenado = self.textoNivel + ": " + String(nivel)
                                    
                                    let informacion = ModeloListaNivel(nivel: nivel, texto: concatenado)
                                    
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
    
    
    
    // METODOS TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
       return items.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                 
        let selectedItem = items[indexPath.row]
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! ListaNivelesInsigniaTableViewCell
                
        if(tema){
            cell.txtNivel.textColor = UIColor.white
        }else{
        
            cell.txtNivel.textColor = UIColor.black
        }
        
       
        
      
        cell.txtNivel.text = selectedItem.texto
        cell.selectionStyle = .none
        
        return cell
    }
    
    
   
  
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    

    
    @IBAction func btnAtras(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
  

}
