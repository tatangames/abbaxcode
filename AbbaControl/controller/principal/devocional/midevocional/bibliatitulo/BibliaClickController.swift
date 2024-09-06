//
//  BibliaClickController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 22/3/24.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import RxSwift
import Toast_Swift
import WebKit

class BibliaClickController: UIViewController, WKNavigationDelegate, OverlayViewDelegateBotonMenos,
                             OverlayViewDelegateBotonMas, OverlayViewDelegatePicker, OverlayViewDelegatePicker2 {
    
    
    // MODIFICADO: 18/06/2024
    
    // PANTALLA MUESTRA UN CAPITULO DE LA BIBLIA
    var iddevobiblia = 0
    
    
    func didTapPicker2(id: Int) {
        apiSolicitarDatos()
    }
    
    

   
     
    func didTapBotonMenos() {
        if (currentFontSize > MIN_FONT_SIZE) {
               currentFontSize -= 1
             
               modificarTamano()
        }
    }
    
    
    func modificarTamano(){
        let scriptTamano = "document.body.style.fontSize = '\(currentFontSize)px';"
        webView.evaluateJavaScript(scriptTamano, completionHandler: nil)
    }
        
    
    func didTapBotonMas() {
        
       if (currentFontSize  < MAX_FONT_SIZE) {
           currentFontSize += 1 // Aumentar el tamaño de letra
           UserDefaults.standard.setValueTamanoLetraCuestionario(value: currentFontSize)

           modificarTamano()
       }
    }
    
    // CUANDO SE TOCA EL TITULO DEL DEVOCIONAL
 
    var tema = false
    var unaVezModeloVersiones = true
    var items: [ModeloVersionesClick] = []
    var hayMasVersiones = false
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var btnOpc: UIButton!
    
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    
    
    var currentFontSize = 18
    let MIN_FONT_SIZE = 15;
    let MAX_FONT_SIZE = 30;
    
    var overlayViewController2: OverlayView2?
    var overlayViewController: OverlayView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        let instanciaTema = TemaController()
        if( instanciaTema.conocerTemaActual() == 1){
            tema = true
         
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
        
        // TAMANO DE LETRA DEFECTO
        if(UserDefaults.standard.getValueTamanoLetraCuestionario() ?? 0 > 0){
            currentFontSize = UserDefaults.standard.getValueTamanoLetraCuestionario() ?? 18
        }
        
        webView.navigationDelegate = self
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        print("valorrr")
        print(String(iddevobiblia))
        
        apiSolicitarDatos()
    }
    
    
    
    func apiSolicitarDatos(){
              
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiInformacionTextoDevoCapitulo
        
        let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
        let idiomaDevo = UserDefaults.standard.getValueIdiomaApp()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "iduser": iduser ?? 0,
            "idiomaplan": idiomaDevo ?? 1,
            "iddevobiblia": iddevobiblia
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
                                                                
                                                          
                                let contenido = json["contenido"].string ?? ""
                                                               
                              
                                json["versiones"].array?.forEach({ (dataArray) in
                                                       
                                    let miid = dataArray["id"].int ?? 0
                                    let mititulo = dataArray["titulo"].string ?? ""
                                                                    
                                    
                                    let bloque3 = ModeloVersionesClick(id: miid, titulo: mititulo)
                                    
                                    self.items.append(bloque3)
                                })
                                
                                
                                
                                self.cargarHtml(texto: contenido)
                               
                              
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
    
    
    
    
    func cargarHtml(texto: String){
             
        let bundleURL = Bundle.main.bundleURL
        webView.loadHTMLString(texto, baseURL: bundleURL)
               
        webView.isHidden = false
    }
    
    
        
    func mensajeSinConexion(){
        let msg = TextoIdiomaController.localizedString(forKey: "sin_conexion_a_internet")
        
        mensajeToastAzul(mensaje: msg)
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
    
    
    
    
    @IBAction func mmbtn(_ sender: Any) {
      
        openAjustes()
    }

    
    /*func abrirModalOpc(){
        
        let textoVersiones = TextoIdiomaController.localizedString(forKey: "versiones")
        let textoAjuste = TextoIdiomaController.localizedString(forKey: "ajustes")
        let textoCancelar = TextoIdiomaController.localizedString(forKey: "cancelar")
        let textoSeleccionar = TextoIdiomaController.localizedString(forKey: "seleccionar_opcion")
        
        
        let alertController = UIAlertController(title: textoSeleccionar, message: nil, preferredStyle: .alert)
               
               let option1Action = UIAlertAction(title: textoAjuste, style: .default) { (action) in
                  
                   // AJUSTES
                   self.openAjustes()
               }
               
               let option2Action = UIAlertAction(title: textoVersiones, style: .default) { (action) in
                   
                   // VERSIONES
                   
                   self.openVersiones()
               }
               
               let option3Action = UIAlertAction(title: textoCancelar, style: .default) { (action) in
                   
                   // CANCELAR
               }
               
               alertController.addAction(option1Action)
               alertController.addAction(option2Action)
               alertController.addAction(option3Action)
               
               present(alertController, animated: true, completion: nil)
    }*/
    
    
    func openAjustes(){
        
        if overlayViewController == nil {
                    overlayViewController = OverlayView()
                }
                overlayViewController?.modalPresentationStyle = .custom
                overlayViewController?.transitioningDelegate = self
        overlayViewController?.delegate = self
        overlayViewController?.delegate2 = self
        overlayViewController?.delegate3 = self
        
        self.present(overlayViewController!, animated: true, completion: nil)
        
    }
    
    
    
    /*func openVersiones(){
        if overlayViewController2 == nil {
                    overlayViewController2 = OverlayView2()
                }
                overlayViewController2?.modalPresentationStyle = .custom
                overlayViewController2?.transitioningDelegate = self
        overlayViewController2?.delegate3 = self
        overlayViewController2?.modeloVersiones = items
        
        
        self.present(overlayViewController2!, animated: true, completion: nil)
    }*/
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       
        
        var tipoLetraTexto = ""
        
        if(UserDefaults.standard.getValueTipoLetraTexto() == 0){  // NOTO SANS LIGHT
            tipoLetraTexto = """
                   document.body.style.fontFamily = 'Fuente1ios';
                   """
        }else if(UserDefaults.standard.getValueTipoLetraTexto() == 1){ // NOTO SANS MEDIUM
                    
            tipoLetraTexto = """
                   document.body.style.fontFamily = 'Fuente2ios';
                   """
        }else if(UserDefaults.standard.getValueTipoLetraTexto() == 2){   // TIMES NEW
            
            tipoLetraTexto = """
                   document.body.style.fontFamily = 'Fuente3ios';
                   """
        }else if(UserDefaults.standard.getValueTipoLetraTexto() == 3){  // RECOLECTA MEDIUM
            
            tipoLetraTexto = """
                   document.body.style.fontFamily = 'Fuente4ios';
                   """
        }else if(UserDefaults.standard.getValueTipoLetraTexto() == 4){ // RECOLECTA REGULAR
            
            tipoLetraTexto = """
                   document.body.style.fontFamily = 'Fuente5ios';
                   """
        }else{
            // DEFECTO
            tipoLetraTexto = """
                   document.body.style.fontFamily = 'Fuente1ios';
                   """
        }
        
        webView.evaluateJavaScript(tipoLetraTexto, completionHandler: nil)
        
        
        
        
              
        // CAMBIO DE COLOR PARA FONDO Y LETRA
        if(tema){
            let scriptColor = "document.body.style.color = 'white';"
                webView.evaluateJavaScript(scriptColor, completionHandler: nil)
            
            
            let javascriptBackground = "document.body.style.backgroundColor = 'black';"
                   webView.evaluateJavaScript(javascriptBackground, completionHandler: nil)
        }else{
            let scriptColor = "document.body.style.color = 'black';"
                webView.evaluateJavaScript(scriptColor, completionHandler: nil)
            
            let javascriptBackground = "document.body.style.backgroundColor = 'white';"
                   webView.evaluateJavaScript(javascriptBackground, completionHandler: nil)
        }
        
        // CAMBIO DE TAMANO
        let scriptTamano = "document.body.style.fontSize = '\(currentFontSize)px';"
        webView.evaluateJavaScript(scriptTamano, completionHandler: nil)
    }
    
    
    
    
    
    
    
    @IBAction func flechaAtras(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
   
    func didTapPicker(id: Int) {
                
        var tipoLetraTexto = ""
        
        if(id == 0){  // NOTO SANS LIGHT
            tipoLetraTexto = """
                   document.body.style.fontFamily = 'Fuente1ios';
                   """
        }else if(id == 1){ // NOTO SANS MEDIUM
                    
            tipoLetraTexto = """
                   document.body.style.fontFamily = 'Fuente2ios';
                   """
        }else if(id == 2){   // TIMES NEW
            
            tipoLetraTexto = """
                   document.body.style.fontFamily = 'Fuente3ios';
                   """
        }else if(id == 3){  // RECOLECTA MEDIUM
            
            tipoLetraTexto = """
                   document.body.style.fontFamily = 'Fuente4ios';
                   """
        }else if(id == 4){ // RECOLECTA REGULAR
            
            tipoLetraTexto = """
                   document.body.style.fontFamily = 'Fuente5ios';
                   """
        }else{
            // DEFECTO
            tipoLetraTexto = """
                   document.body.style.fontFamily = 'Fuente1ios';
                   """
        }
        
        webView.evaluateJavaScript(tipoLetraTexto, completionHandler: nil)
    }
    
    
    

}


extension BibliaClickController: UIViewControllerTransitioningDelegate {
  
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        CodigoModalBibliaHtml(presentedViewController: presented, presenting: presenting)
    }
   
    
}
