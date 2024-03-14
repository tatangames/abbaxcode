//
//  NuevaPassController.swift
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

class NuevaPassController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate  {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtPassword: UILabel!
    @IBOutlet weak var edtPassword: UITextField!
    
    @IBOutlet weak var btnEnviar: UIButton!
    
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    var tema = false
    
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
                
        txtPassword.text = TextoIdiomaController.localizedString(forKey: "nueva_contrasena")
                
        edtPassword.layer.cornerRadius = 10
        edtPassword.clipsToBounds = true
        edtPassword.delegate = self
        edtPassword.setPadding(10)
        
        btnEnviar.layer.cornerRadius = 18
        btnEnviar.clipsToBounds = true
                
        let textContinuar = TextoIdiomaController.localizedString(forKey: "actualizar")
                
        if(tema){ // Dark
            
            // BOTON CONTNUAR
             
            btnEnviar.backgroundColor = .white
                  
             let btnContinuarAtributo = NSAttributedString(string: textContinuar, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                NSAttributedString.Key.foregroundColor: UIColor.black,
             ])
                         
            btnEnviar.setAttributedTitle(btnContinuarAtributo, for: .normal)
            
        }else{
                 
            // BOTON CONTINUAR
                        
            btnEnviar.backgroundColor = .black
                 
            let btnContinuarAtributo = NSAttributedString(string: textContinuar, attributes: [
               NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
               NSAttributedString.Key.foregroundColor: UIColor.white,
            ])
            
            let btnContinuarAtributoPress = NSAttributedString(string: textContinuar, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                NSAttributedString.Key.foregroundColor: UIColor.gray,
            ])
    
            btnEnviar.setAttributedTitle(btnContinuarAtributo, for: .normal)
            btnEnviar.setAttributedTitle(btnContinuarAtributoPress, for: .highlighted)
                        
            if let myCustomColor = UIColor(named: "grisAAA") {
                edtPassword.backgroundColor = myCustomColor
            }
        }
        
        // *** HIGHLIGHTED BOTON CONTINUAR
        let btnContinuarAtributoPress = NSAttributedString(string: textContinuar, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
            NSAttributedString.Key.foregroundColor: UIColor.gray,
        ])

        btnEnviar.setAttributedTitle(btnContinuarAtributoPress, for: .highlighted)
    }

    
    @IBAction func btnEnviar(_ sender: Any) {
     
        verificar()
    }
    
    func verificar(){
        
        // CONTRASEÑA
        
        if(ValidarTexto().validarEntradaRequerida(texto: edtPassword.text ?? "") == 1){
            mensajeToastAzul(mensaje: TextoIdiomaController.localizedString(forKey: "password_requerido"))
            return
        }
        
        if(ValidarTexto().validarPassword6minCaracteres(texto: edtPassword.text ?? "") == 1){
            mensajeToastAzul(mensaje: TextoIdiomaController.localizedString(forKey: "contrasena_minimo_seis"))
            return
        }
        
        cerrarTeclado()
        
        resetear()
    }
    
    func resetear(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiActualizarPasswordReseteo        
        
        let parameters: [String: Any] = [
            "password": edtPassword.text ?? "",
        ]
        
        let token = UserDefaults.standard.getValueTokenUsuario()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
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
                             
                                // actualizado
                                self.salir()
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
        .retry()
        .subscribe(onNext: {
            // Hacer algo cuando la solicitud tenga éxito
            
        }, onError: { error in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.mensajeSinConexion()
        })
        .disposed(by: disposeBag)
    }
    
    
    
    func salir(){
        
        let texto = TextoIdiomaController.localizedString(forKey: "actualizado")
        
        let alert = UIAlertController(title: texto, message: "", preferredStyle: UIAlertController.Style.alert)
       
             alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
                 self.volverAtras()
             }))
              
        self.present(alert, animated: true, completion: nil)
    }
    
    func volverAtras(){
        
        let vistaSiguiente : LoginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as! LoginController
                      
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
        
        let vistaSiguiente : LoginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as! LoginController
                      
        self.present(vistaSiguiente, animated: true, completion: nil)
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
