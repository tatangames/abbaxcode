//
//  LecturaBibliaInController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 27/3/24.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import RxSwift
import Toast_Swift
import WebKit

class LecturaBibliaInController: UIViewController, WKNavigationDelegate, OverlayViewDelegateBotonMenos,
                               OverlayViewDelegateBotonMas, OverlayViewDelegatePicker{
   
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
    
    
    var idversiculo = 0
    var tema = false
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    
    var currentFontSize = 18
    let MIN_FONT_SIZE = 15;
    let MAX_FONT_SIZE = 30;
    
    @IBOutlet weak var webView: WKWebView!
    
    
    private let floatingButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        
        button.backgroundColor = .systemBlue
        
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        
       // button.layer.masksToBounds = true
        button.layer.cornerRadius = 30
        return button
        
    }()
    
    
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
        
        
        view.addSubview(floatingButton)
    
        floatingButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        webView.navigationDelegate = self
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        
        apiSolicitarDatos()
    }
    
    
    // CUANDO SE TOCA BOTON PLUS
    @objc private func didTapButton(){
  
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
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatingButton.frame = CGRect(x: view.frame.size.width - 70,
                                      y: view.frame.size.height - 100,
                                      width: 60,
                                      height: 60)
    }
    

    func apiSolicitarDatos(){
              
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiBibliaHtmlInvitado
        
        let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
        let idiomaDevo = UserDefaults.standard.getValueIdiomaApp()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "iduser": iduser ?? 0,
            "idiomaplan": idiomaDevo ?? 1,
            "idversiculo": idversiculo
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
        
        
        let verso = "verso\(idversiculo)"
        
              
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
        
        
        let javascript = "document.getElementById('\(verso)').scrollIntoView();"
         webView.evaluateJavaScript(javascript, completionHandler: nil)
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
}


extension LecturaBibliaInController: UIViewControllerTransitioningDelegate {
  
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        CodigoModalBibliaHtml(presentedViewController: presented, presenting: presenting)
    }
   
    
}
