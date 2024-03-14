//
//  LoginController.swift
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
import OneSignalFramework

class LoginController: UIViewController,UIScrollViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var txtCorreo: UILabel!
    @IBOutlet weak var edtCorreo: UITextField!
    
    
    @IBOutlet weak var txtPassword: UILabel!
    @IBOutlet weak var edtPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnOlvidePass: UIButton!
    
    
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    
    var tema = false
    var idFirebase = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
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
    }
    
    func configuracionInicial(){
        
        scrollView.delegate = self
           
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        scrollView.addGestureRecognizer(tapGesture)
        
        // TEXTOS LABEL
        txtCorreo.text = TextoIdiomaController.localizedString(forKey: "correo_electronico")
        txtPassword.text = TextoIdiomaController.localizedString(forKey: "contrasena")
        
        edtCorreo.layer.cornerRadius = 10
        edtCorreo.clipsToBounds = true
        edtCorreo.delegate = self
        edtCorreo.setPadding(10)
        
        edtPassword.layer.cornerRadius = 10
        edtPassword.clipsToBounds = true
        edtPassword.delegate = self
        edtPassword.setPadding(10)
        
        btnLogin.layer.cornerRadius = 18
        btnLogin.clipsToBounds = true
        
        let textOlvide = TextoIdiomaController.localizedString(forKey: "olvido_su_contrasena")
        let textContinuar = TextoIdiomaController.localizedString(forKey: "continuar")
        
        if(tema){ // Dark
            
            // BOTON CONTNUAR
             
            btnLogin.backgroundColor = .white
                  
             let btnContinuarAtributo = NSAttributedString(string: textContinuar, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                NSAttributedString.Key.foregroundColor: UIColor.black,
             ])
                         
            btnLogin.setAttributedTitle(btnContinuarAtributo, for: .normal)
           
            
            // BOTON OLVIDE PASS
            let btnPassAtributo = NSAttributedString(string: textOlvide, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), // tamaño letra
                NSAttributedString.Key.foregroundColor: UIColor.white, // color letra
            ])
            
            btnOlvidePass.setAttributedTitle(btnPassAtributo, for: .normal)
            
            
        }else{
                 
            // BOTON CONTINUAR
                        
            btnLogin.backgroundColor = .black
                 
            let btnContinuarAtributo = NSAttributedString(string: textContinuar, attributes: [
               NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
               NSAttributedString.Key.foregroundColor: UIColor.white,
            ])
            
            let btnContinuarAtributoPress = NSAttributedString(string: textContinuar, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                NSAttributedString.Key.foregroundColor: UIColor.gray,
            ])
    
                btnLogin.setAttributedTitle(btnContinuarAtributo, for: .normal)
                btnLogin.setAttributedTitle(btnContinuarAtributoPress, for: .highlighted)
            
            
            // BOTON OLVIDE PASS
            let btnPassAtributo = NSAttributedString(string: textOlvide, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), // tamaño letra
                NSAttributedString.Key.foregroundColor: UIColor.black, // color letra
            ])
                       
            btnOlvidePass.setAttributedTitle(btnPassAtributo, for: .normal)
             
            if let myCustomColor = UIColor(named: "grisAAA") {
                edtCorreo.backgroundColor = myCustomColor
                edtPassword.backgroundColor = myCustomColor
            }
        }
        
        // *** HIGHLIGHTED BOTON CONTINUAR
        let btnContinuarAtributoPress = NSAttributedString(string: textContinuar, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
            NSAttributedString.Key.foregroundColor: UIColor.gray,
        ])

        btnLogin.setAttributedTitle(btnContinuarAtributoPress, for: .highlighted)
        
        
        // *** HIGHLIGHTED BOTON OLVIDE PASS
        let btnPassAtributoPress = NSAttributedString(string: textOlvide, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), // tamaño letra
            NSAttributedString.Key.foregroundColor: UIColor.gray, // color letra
        ])
        
        btnOlvidePass.setAttributedTitle(btnPassAtributoPress, for: .highlighted)
        
        
        // IDENTIFICADOR ONE SIGNAL
        let id: String = OneSignal.User.pushSubscription.id ?? ""
        idFirebase = id
    }
    
    
    @IBAction func flechaAtras(_ sender: Any) {
        let vista : LoginRegisterController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginRegisterController") as! LoginRegisterController
                
        self.present(vista, animated: true, completion: nil)
    }
    
    @IBAction func btnLogin(_ sender: Any) {
                
        if(ValidarTexto().validarEntradaRequerida(texto: edtCorreo.text ?? "") == 1){
            mensajeToastAzul(mensaje: TextoIdiomaController.localizedString(forKey: "correo_requerido"))
            return
        }
        
        if(ValidarTexto().validarCorreoElectronico(texto: edtCorreo.text ?? "") == false){
            mensajeToastAzul(mensaje: TextoIdiomaController.localizedString(forKey: "correo_no_valido"))
            return
        }
        
        // CONTRASEÑA
        
        if(ValidarTexto().validarEntradaRequerida(texto: edtPassword.text ?? "") == 1){
            mensajeToastAzul(mensaje: TextoIdiomaController.localizedString(forKey: "password_requerido"))
            return
        }
        
       iniciarSesion()
    }
    
    
    func iniciarSesion(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiIniciarSesion
        
        let parameters: [String: Any] = [
            "correo": edtCorreo.text ?? "",
            "password": edtPassword.text ?? "",
            "idonesignal": idFirebase,
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
                              // inicio sesion
                                let idCliente = json["id"].stringValue
                                let token = json["token"].stringValue
                               
                                // guardar id del cliente
                                UserDefaults.standard.setValueIdCliente(value: idCliente)
                                UserDefaults.standard.setValueTokenCliente(value: token)
                                
                              
                                self.redireccionarVistaPrincipal()
                            }
                            else if(successValue == 2){
                                self.datosInvalidos()
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
        .retry() // Retry indefinitely
        .subscribe(onNext: {
            // Hacer algo cuando la solicitud tenga éxito
            
        }, onError: { error in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.mensajeSinConexion()
        })
        .disposed(by: disposeBag)
    }
    
    
    func redireccionarVistaPrincipal(){
        
        let vista : TabBarPrincipalController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "TabBarPrincipalController") as! TabBarPrincipalController
        
        self.present(vista, animated: true, completion: nil)
    }
    
    
    
    func datosInvalidos(){
        let mens = TextoIdiomaController.localizedString(forKey: "correo_o_contrasena_incorrectos")
        mensajeToastAzul(mensaje: mens)
    }
        
    
    func mensajeSinConexion(){
        mensajeToastAzul(mensaje: TextoIdiomaController.localizedString(forKey: "sin_conexion_a_internet"))
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
    
    
    @IBAction func btnOlvidePass(_ sender: Any) {
        
        let vista : OlvidePasswordController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OlvidePasswordController") as! OlvidePasswordController
                
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
    
    
    @IBAction func bnFlechaAtras(_ sender: Any) {
        
        let vista : LoginRegisterController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginRegisterController") as! LoginRegisterController
                
        self.present(vista, animated: true, completion: nil)
    }
}
