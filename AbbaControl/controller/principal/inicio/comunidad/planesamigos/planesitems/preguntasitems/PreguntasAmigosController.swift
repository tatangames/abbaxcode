//
//  PreguntasAmigosController.swift
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

class PreguntasAmigosController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var idUserBuscado = 0
    var idPlanBlockDeta = 0
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var tema = false
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    var items: [ModeloPreguntaAmigo] = []
    
    
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
        
        let texto = TextoIdiomaController.localizedString(forKey: "preguntas")
        
        txtTitulo.title = texto
        
      
        apiBuscarDatos()
    }
    

    @IBAction func btnAtras(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
  
    func apiBuscarDatos(){
            
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiListadoPlanesItemsPreguntasComunidad
        
        let token = UserDefaults.standard.getValueTokenUsuario()
        let idiomaPlan = UserDefaults.standard.getValueIdiomaApp()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "idplanblockdetauser": idPlanBlockDeta,
            "idiomaplan": idiomaPlan ?? 0,
            "idusuariobuscar": idUserBuscado,
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
                                    
                                    json["listado"].array?.forEach({ (dataArray) in
                                                           
                                        let miTitulo = dataArray["titulo"].string ?? ""
                                        let miRespuesta = dataArray["respuesta"].string ?? ""
                                                                             
                                        let bloque = ModeloPreguntaAmigo(titulo: miTitulo, respuesta: miRespuesta)
                                        
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
        let msg = TextoIdiomaController.localizedString(forKey: "no_hay_preguntas")
        mensajeToastAzul(mensaje: msg)
    }
     

    // METODOS TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
       return items.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                 
        let selectedItem = items[indexPath.row]
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PreguntasAmigosTableViewCell
        
        var textoPregunta = ""
        
        if let textoExtraido = self.extraerTextoHTML(htmlString: selectedItem.titulo) {
            textoPregunta = textoExtraido
        }
     
        
        cell.txtPregunta.text = textoPregunta
        cell.txtRespuesta.text = "R// " + selectedItem.respuesta
      
        cell.selectionStyle = .none
            
        return cell
    }
    
    
    
    // EXTRAER TEXTO HTML DEL MODELO DE DATOS
    func extraerTextoHTML(htmlString: String) -> String? {
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
    
}
