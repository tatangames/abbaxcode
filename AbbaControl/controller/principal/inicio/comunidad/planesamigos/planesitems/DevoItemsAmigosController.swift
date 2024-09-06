//
//  DevoItemsAmigosController.swift
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

class DevoItemsAmigosController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var idPlan = 0
    var idUserBuscado = 0
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var tema = false
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    var items: [ModeloItemsPlanAmigo] = []
    
    
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
        
        
        
        let texto = TextoIdiomaController.localizedString(forKey: "notas")
        
        txtTitulo.title = texto
        
        
        apiBuscarDatos()
    }
    
    func apiBuscarDatos(){
                
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiComunidadInfoPlanItem
        
        let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
        let idiomaPlan = UserDefaults.standard.getValueIdiomaApp()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "idplan": idPlan,
            "idiomaplan": idiomaPlan ?? 0,
            "idusuariobuscar": idUserBuscado,
            "iduser": iduser ?? 0
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
                                
                               let hayinfo = json["hayinfo"].int ?? 0
                                          
                                if(hayinfo == 1){
                                    
                                    json["listadoplan"].array?.forEach({ (dataArray) in
                                                           
                                        let miID = dataArray["id"].int ?? 0
                                        let miUsuario = dataArray["id_usuario"].int ?? 0
                                        let miPlanBlock = dataArray["id_planes_block_deta"].int ?? 0
                                        let miCompletado = dataArray["completado"].int ?? 0
                                        let miTitulo = dataArray["titulo"].string ?? ""
                                        let miFecha = dataArray["fecha"].string ?? ""
                                                                              
                                        let bloque = ModeloItemsPlanAmigo(id: miID, idusuario: miUsuario, idplanblockdeta: miPlanBlock, completado: miCompletado, titulo: miTitulo, fecha: miFecha)
                                        
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
    
    
    func mensajeSinConexion(){
        let msg = TextoIdiomaController.localizedString(forKey: "sin_conexion_a_internet")
        mensajeToastAzul(mensaje: msg)
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
    
    
    func alertaNoHayPlanes(){
        let msg = TextoIdiomaController.localizedString(forKey: "no_hay_devocionales_disponibles")
        mensajeToastAzul(mensaje: msg)
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
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DevoItemsAmigosTableViewCell
        
        cell.txtFecha.text = selectedItem.fecha
        cell.txtTitulo.text = selectedItem.titulo
      
        cell.selectionStyle = .none
            
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItem = items[indexPath.row]
        
        vistaPreguntas(idplanblockdeta: selectedItem.id)
    }
    
    
    func vistaPreguntas(idplanblockdeta: Int){
        
        let vista : PreguntasAmigosController = UIStoryboard(name: "Main3", bundle: nil).instantiateViewController(withIdentifier: "PreguntasAmigosController") as! PreguntasAmigosController
                
        vista.idPlanBlockDeta = idplanblockdeta
        vista.idUserBuscado = idUserBuscado
        
        self.present(vista, animated: true, completion: nil)
    }
}
