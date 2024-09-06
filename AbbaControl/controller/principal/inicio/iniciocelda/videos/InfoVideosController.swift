//
//  InfoVideosController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 26/3/24.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import RxSwift
import Toast_Swift
import SDWebImage

class InfoVideosController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolbar: UINavigationItem!
    
    var tema = false
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    var items: [ModeloTodosVideos] = []
    
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
       
        
        toolbar.title = TextoIdiomaController.localizedString(forKey: "videos")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        
        apiSolicitarDatos()
    }
    
    
    func apiSolicitarDatos(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiListadoVideos
        
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
                    case .success(let data):
                        
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        let json = JSON(data)
                                                
                        if let successValue = json["success"].int {
                            
                            if(successValue == 1){
                                                                          
                                json["arrayfinalvideo"].array?.forEach({ (dataArray) in
                                                       
                                    let imagen = dataArray["imagen"].string ?? ""
                                    let url = dataArray["url_video"].string ?? ""
                                    let titulo = dataArray["titulo"].string ?? ""
                                    
                                    let informacion = ModeloTodosVideos(imagen: imagen, url: url, titulo: titulo)
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

        

    @IBAction func flechaAtras(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        
        
        // TITULO DE PANTALLA
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! InfoVideoCell1
               
        let union = baseUrlImagen+selectedItem.imagen
        cell.imgFoto.sd_setImage(with: URL(string: "\(union)"), placeholderImage: UIImage(named: "fotodefecto"))
        
        cell.vista.clipsToBounds = true
        cell.vista.backgroundColor = UIColor.white
        cell.vista.layer.cornerRadius = 20
        
        cell.txtTitulo.numberOfLines = 0
        cell.txtTitulo.textColor = .black
        cell.txtTitulo.text = selectedItem.titulo
  
                           
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selected = items[indexPath.row]
        
        if let url = URL(string: selected.url) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("No se puede abrir la URL")
            }
        }
        
        
    }
    
    
}
