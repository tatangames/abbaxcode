//
//  DevoInformacionController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 19/3/24.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import RxSwift
import Toast_Swift
import SDWebImage

protocol protocolDevoInformacionAmigos {
  func recargarVistaAnterior(data: Bool)
}


class DevoInformacionController: UIViewController, protocolDevoInformacionAmigos {
    
    
    // PANTALLA DONDE APARECEN LOS DEVOCIONALES QUE NO TENGO AGREGADO
    
       
    func recargarVistaAnterior(data: Bool) {
        if(data){
            recargarVistaAnterior = true
            self.dismiss(animated: true, completion: nil)
        }
    }
    

    var idplan = 0
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgDevo: UIImageView!
    @IBOutlet weak var txtTitulo: UILabel!
    @IBOutlet weak var btnIniciar: UIButton!
    @IBOutlet weak var txtSubtitulo: UILabel!
    @IBOutlet weak var txtDescripcion: UILabel!
    @IBOutlet weak var btnIniciarAmigos: UIButton!
    
    var tema = false
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    var recargarVistaAnterior = false
    
    @IBOutlet weak var toolbar: UINavigationItem!
    
    
    var delegate: protocolDevoInformacion!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let instanciaTema = TemaController()
        if( instanciaTema.conocerTemaActual() == 1){
            tema = true
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
       
        toolbar.title = TextoIdiomaController.localizedString(forKey: "informacion_plan")
                
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white    
        
        configBoton()
        
        
        apiBuscarDatos()
    }
    
    func configBoton(){
        
        btnIniciar.layer.cornerRadius = 18
        btnIniciar.clipsToBounds = true
        
        btnIniciarAmigos.layer.cornerRadius = 18
        btnIniciarAmigos.clipsToBounds = true
        
        
        let textoIniciar = TextoIdiomaController.localizedString(forKey: "iniciar_plan")
        let textoIniciarAmigos = TextoIdiomaController.localizedString(forKey: "iniciar_con_amigos")
        
       
        if(tema){ // Dark
            
            // BOTON INICIAR
             
            btnIniciar.backgroundColor = .white
                  
             let btnIniciarAtributo = NSAttributedString(string: textoIniciar, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                NSAttributedString.Key.foregroundColor: UIColor.black,
             ])
                         
            btnIniciar.setAttributedTitle(btnIniciarAtributo, for: .normal)
            
            btnIniciarAmigos.backgroundColor = .white
                  
             let btnIniciarAmigosAtributo = NSAttributedString(string: textoIniciarAmigos, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                NSAttributedString.Key.foregroundColor: UIColor.black,
             ])
                         
            btnIniciarAmigos.setAttributedTitle(btnIniciarAmigosAtributo, for: .normal)
           
            
        }else{
                        
                        
            btnIniciar.backgroundColor = .black
                  
             let btnIniciarAtributo = NSAttributedString(string: textoIniciar, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                NSAttributedString.Key.foregroundColor: UIColor.white,
             ])
                         
            btnIniciar.setAttributedTitle(btnIniciarAtributo, for: .normal)
            
            btnIniciarAmigos.backgroundColor = .black
                  
             let btnIniciarAmigosAtributo = NSAttributedString(string: textoIniciarAmigos, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                NSAttributedString.Key.foregroundColor: UIColor.white,
             ])
                         
            btnIniciarAmigos.setAttributedTitle(btnIniciarAmigosAtributo, for: .normal)
        }
        
        
        let btnIniciarPress = NSAttributedString(string: textoIniciar, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
            NSAttributedString.Key.foregroundColor: UIColor.gray,
        ])

        btnIniciar.setAttributedTitle(btnIniciarPress, for: .highlighted)
        
        
        let btnIniciarAmigosPress = NSAttributedString(string: textoIniciarAmigos, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
            NSAttributedString.Key.foregroundColor: UIColor.gray,
        ])

        btnIniciarAmigos.setAttributedTitle(btnIniciarAmigosPress, for: .highlighted)
    }
    
    
    
    
    func apiBuscarDatos(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiInformacionDevocional
        
       // let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
        let idiomaPlan = UserDefaults.standard.getValueIdiomaApp()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "idplan": idplan,
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
                                
                                let imagen = json["imagen"].string ?? ""
                                let titulo = json["titulo"].string ?? ""
                                let subtitulo = json["subtitulo"].string ?? ""
                                let descripcion = json["descripcion"].string ?? ""
                                
                                self.setearDatos(imagen: imagen, titulo: titulo, subtitulo: subtitulo, descripcion: descripcion)
                              
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
    
    
    func setearDatos(imagen: String, titulo: String, subtitulo: String, descripcion: String){
               
        
        let union = baseUrlImagen+imagen
  
            imgDevo.sd_setImage(with: URL(string: "\(union)"), placeholderImage: UIImage(named: "fotodefecto"))
        
        if subtitulo.isEmpty {
            txtSubtitulo.isHidden = true
        }else{
            txtSubtitulo.text = subtitulo
        }
                
         
        txtTitulo.text = titulo
        
        
        
        if descripcion.isEmpty {
            txtDescripcion.isHidden = true
        }else{
                        
            // Convertir HTML a atributos de texto
                  if let attributedString = try? NSAttributedString(data: descripcion.data(using: .utf16)!,
                                                                     options: [.documentType: NSAttributedString.DocumentType.html],
                                                                     documentAttributes: nil) {
                      // Ajustar tamaño del texto
                      let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
                      mutableAttributedString.enumerateAttribute(.font, in: NSRange(location: 0, length: mutableAttributedString.length), options: []) { value, range, _ in
                          if let font = value as? UIFont {
                              // Cambiar tamaño del texto
                              let resizedFont = font.withSize(font.pointSize * 1.5) // Ajustar el tamaño del texto multiplicando el tamaño actual por un factor (en este caso, 1.5)
                              mutableAttributedString.addAttribute(.font, value: resizedFont, range: range)
                          }
                      }

                      // Asignar los atributos de texto al UILabel
                      txtDescripcion.attributedText = mutableAttributedString
                  }
            
            
      
            if(tema){
                txtDescripcion.textColor = .white
            }else{
                txtDescripcion.textColor = .black
            }
        }
        
        
        scrollView.isHidden = false
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
      
        delegate.recargarVistaAnterior(data: recargarVistaAnterior)
    }
    
    
    @IBAction func btnIniciar(_ sender: Any) {
        iniciarPlanSolo()
    }
    
   
    
    @IBAction func btnIniciarAmigos(_ sender: Any) {
        
        let vista : IniciarAmigosController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "IniciarAmigosController") as! IniciarAmigosController
                
        vista.idplan = idplan
        vista.delegate = self
        
        self.present(vista, animated: true, completion: nil)
    }
    
    
    
    
    func iniciarPlanSolo(){
        
        let titulo = TextoIdiomaController.localizedString(forKey: "iniciar_plan")
        let botonno = TextoIdiomaController.localizedString(forKey: "cancelar")
        let botonsi = TextoIdiomaController.localizedString(forKey: "si")
                
        
        let alert = UIAlertController(title: titulo, message: nil, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: botonno, style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: botonsi, style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            
            self.enviarDatosPlanSolo()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func enviarDatosPlanSolo(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiIniciarPlanSolo
        
       // let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
        let iduser = UserDefaults.standard.getValueIdUsuario()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "iduser": iduser ?? 0,
            "idplan": idplan,
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
                                // plan ya estaba seleccionado
                                self.salirAlerta()
                            }
                            else if(successValue == 2){
                                // plan seleccionado
                                self.salirAlerta()
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
    
    
    
    func salirAlerta(){
        
        let titulo = TextoIdiomaController.localizedString(forKey: "plan_agregado")
        
        let alert = UIAlertController(title: titulo, message: nil, preferredStyle: UIAlertController.Style.alert)
          
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            
            self.salir()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func salir(){
        recargarVistaAnterior = true
        self.dismiss(animated: true, completion: nil)
    }
    

}
