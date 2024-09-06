//
//  OlvidePasswordController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 11/3/24.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import RxSwift
import Toast_Swift

class OlvidePasswordController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var txtTitulo: UILabel!
    @IBOutlet weak var txtCorreo: UILabel!
    @IBOutlet weak var edtCorreo: UITextField!
    
    @IBOutlet weak var btnContinuar: UIButton!
    
    public var correo = ""
    
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    var tema = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  overrideUserInterfaceStyle = .light
        
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        let instanciaTema = TemaController()
        if( instanciaTema.conocerTemaActual() == 1){
            tema = true
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
        
        configuracionInicial()
        
        edtCorreo.text = correo
    }
    
    
    func configuracionInicial(){
        
        scrollView.delegate = self
           
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        scrollView.addGestureRecognizer(tapGesture)
        
        txtTitulo.text = TextoIdiomaController.localizedString(forKey: "escribe_tu_correo_electronico")
        
        txtCorreo.text = TextoIdiomaController.localizedString(forKey: "correo_electronico")
        
        edtCorreo.layer.cornerRadius = 10
        edtCorreo.clipsToBounds = true
        edtCorreo.delegate = self
        edtCorreo.setPadding(10)
        
        btnContinuar.layer.cornerRadius = 18
        btnContinuar.clipsToBounds = true
        
        let textContinuar = TextoIdiomaController.localizedString(forKey: "continuar")
        
        
        if(tema){ // Dark
            
            // BOTON CONTNUAR
             
            btnContinuar.backgroundColor = .white
                  
             let btnContinuarAtributo = NSAttributedString(string: textContinuar, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                NSAttributedString.Key.foregroundColor: UIColor.black,
             ])
                         
            btnContinuar.setAttributedTitle(btnContinuarAtributo, for: .normal)
            
        }else{
                 
            // BOTON CONTINUAR
                        
            btnContinuar.backgroundColor = .black
                 
            let btnContinuarAtributo = NSAttributedString(string: textContinuar, attributes: [
               NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
               NSAttributedString.Key.foregroundColor: UIColor.white,
            ])
                
            btnContinuar.setAttributedTitle(btnContinuarAtributo, for: .normal)
                          
            if let myCustomColor = UIColor(named: "grisAAA") {
                edtCorreo.backgroundColor = myCustomColor
            }
        }
        
        // *** HIGHLIGHTED BOTON CONTINUAR
        let btnContinuarAtributoPress = NSAttributedString(string: textContinuar, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
            NSAttributedString.Key.foregroundColor: UIColor.gray,
        ])

        btnContinuar.setAttributedTitle(btnContinuarAtributoPress, for: .highlighted)
    }

    @IBAction func btnContinuar(_ sender: Any) {
      
        if(ValidarTexto().validarEntradaRequerida(texto: edtCorreo.text ?? "") == 1){
            mensajeToastAzul(mensaje: TextoIdiomaController.localizedString(forKey: "correo_requerido"))
            return
        }
        
        
        if(ValidarTexto().validarCorreoElectronico(texto: edtCorreo.text ?? "") == false){
            mensajeToastAzul(mensaje: TextoIdiomaController.localizedString(forKey: "correo_no_valido"))
            return
        }
        
        enviarCorreo()
    }
    
    func enviarCorreo(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiSolicitarCodigoPass
        
        // idioma app
        let idiomaApp =  UserDefaults.standard.getValueIdiomaApp()
        
        let parameters: [String: Any] = [
            "correo": edtCorreo.text ?? "",
            "idioma": idiomaApp ?? 1, // defecto español
        ]
        
        Observable<Void>.create { observer in
            let request = AF.request(encodeURL, method: .post, parameters: parameters)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        let json = JSON(data)
                        
                        if let successValue = json["success"].int {
                            
                            if(successValue == 1){
                             
                                // correo no encontrado
                                
                                self.correoNoEncontrado()
                            }
                            else if(successValue == 2){
                                
                                // pantalla ingresar codigo
                                self.siguientePantalla()
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
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
        //.retry() // NO RETRY
        .subscribe(onNext: {
            // Hacer algo cuando la solicitud tenga éxito
            
        }, onError: { error in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.mensajeSinConexion()
        })
        .disposed(by: disposeBag)
    }
    
    func correoNoEncontrado(){
        mensajeToastAzul(mensaje: TextoIdiomaController.localizedString(forKey: "correo_no_encontrado"))
    }
    
    
    func siguientePantalla(){
        
        let vistaSiguiente : VerificarCodigoController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerificarCodigoController") as! VerificarCodigoController
      
        vistaSiguiente.correo = edtCorreo.text ?? ""
        
        self.present(vistaSiguiente, animated: true, completion: nil)
    }
    
    func mensajeSinConexion(){
        mensajeToastAzul(mensaje: TextoIdiomaController.localizedString(forKey: "sin_conexion_a_internet"))
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
    
    
    @IBAction func btnFlechaAtras(_ sender: Any) {
        
        let vista : LoginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as! LoginController
                
        self.present(vista, animated: true, completion: nil)
    }
    
    
    
    
    @objc func tapGestureHandler() {
        // Cerrar el teclado
        view.endEditing(true)
    }

    // OPCIONES PARA OCULTAR TECLADO
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) {
            notification in
            self.keyboardWillShow(notification: notification)
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) {
            notification in
            self.keyboardWillHide(notification: notification)
        }
    }
    
    func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        scrollView?.contentInset = contentInset
    }
    
    func keyboardWillHide(notification: Notification) {
        scrollView?.contentInset = UIEdgeInsets.zero
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func cerrarTeclado(){
        view.endEditing(true) // cierre del teclado
    }
}
