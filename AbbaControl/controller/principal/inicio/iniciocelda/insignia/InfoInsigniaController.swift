//
//  InfoInsigniaController.swift
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

class InfoInsigniaController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // PANTALLA INFORMACION DE LA INSIGNIA QUE SE TOCO DESDE PANTALLA INICIO
    
    
    var idinsignia = 0
    var tema = false
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    var items: [ModeloHitos] = []
    
    var titulo = ""
    var descripcion = ""
    var imagen = ""
    var nivelvoy = 0
    var textoNivel = ""
    var contador = 0
    var textoContador = ""
    var concatenatedString = ""
    
    @IBOutlet weak var toolbar: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var botonNivel: UIButton!
    
        
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
        
        textoNivel = TextoIdiomaController.localizedString(forKey: "nivel")
       
        
        
    
    
            
     
        
       
        
        
        toolbar.title = TextoIdiomaController.localizedString(forKey: "insignias")
        textoContador = TextoIdiomaController.localizedString(forKey: "contador_actual")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        apiSolicitarDatos()
    }
    
    
    func apiSolicitarDatos(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiInfoInsignia
        
        let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
        let idiomaplan = UserDefaults.standard.getValueIdiomaApp()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "iduser": iduser ?? 0,
            "idiomaplan": idiomaplan ?? 1,
            "idinsignia": idinsignia
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
                                
                                // JSON
                                // success, titulo, descripcion, imagen, nivelvoy, contador, hitoarray
                                
                                    // id, fecha, nivel, hitotexto1, fechaFormat
                                
                                                            
                                self.titulo = json["titulo"].string ?? ""
                                self.descripcion = json["descripcion"].string ?? ""
                                self.imagen = json["imagen"].string ?? ""
                                self.nivelvoy = json["nivelvoy"].int ?? 0
                                let miCon = json["contador"].int ?? 0
                                
                                // primer dato
                                let informacion1 = ModeloHitos(tipo: 1, nivel: 0, fechaFormat: "")
                                
                                self.items.append(informacion1)
                                
                                // verificar si hay siguiente nivel
                                
                                json["hitoarray"].array?.forEach({ (dataArray) in
                                                       
                                    let nivel = dataArray["nivel"].int ?? 0
                                    let fecha = dataArray["fechaFormat"].string ?? ""
                                    
                                    let espaciado = ": "
                                    
                                    self.concatenatedString = self.textoContador + espaciado + String(miCon)
                                                                        
                                    let informacion = ModeloHitos(tipo: 2, nivel: nivel,  fechaFormat: fecha)
                                    
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

    
    @IBAction func flechaAtras(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func botonNivel(_ sender: Any) {
        vistaTotalNiveles()
    }
    
    
    
    
    func vistaTotalNiveles(){
        let vista : ListaNivelesInsigniaViewController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "ListaNivelesInsigniaViewController") as! ListaNivelesInsigniaViewController
        
        vista.idTipoInsignia = idinsignia
        
        self.present(vista, animated: true, completion: nil)
    }
    
    
    
    
    
    // METODOS TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
       return items.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                 
        let selectedItem = items[indexPath.row]
        
        if(selectedItem.tipo == 1){
            
            // TITULO DE PANTALLA
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! InsigniaCell1
            
           
            let union = baseUrlImagen+imagen
            
            cell.imgInsignia.sd_setImage(with: URL(string: "\(union)"), placeholderImage: UIImage(named: "fotodefecto"))
                        
            cell.txtNivel.text = textoNivel + ": " + String(nivelvoy)
            
            cell.txtTitulo.text = titulo
            cell.txtDescripcion.text = descripcion
            cell.txtContador.text = concatenatedString
            
            cell.txtHito.text = TextoIdiomaController.localizedString(forKey: "hitos")
                       
            cell.selectionStyle = .none
            
            return cell
        
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! InsigniaCell2
            cell.txtTitulo.text = TextoIdiomaController.localizedString(forKey: "completado_el") + selectedItem.fechaFormat
            cell.txtNivel.text = textoNivel + ": " + String(selectedItem.nivel)
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    
   
    
    
    

    
}
