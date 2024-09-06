//
//  AgregarAmigoController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 23/3/24.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import RxSwift
import Toast_Swift

class AgregarAmigoController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {

    
    
    @IBOutlet weak var txtMensaje: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var txtNombre: UILabel!
    
    @IBOutlet weak var btnEnviar: UIButton!
    @IBOutlet weak var edtCorreo: UITextField!
    
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    var tema = false
        
    var textoIngresaCorreo = ""
    var textoSoliPendiAcep = ""
    var textoSoliAceptada = ""
    var textoSoliEnviada = ""
    
    
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
        
        textoIngresaCorreo = TextoIdiomaController.localizedString(forKey: "ingresa_correo_amigo")
        textoSoliPendiAcep = TextoIdiomaController.localizedString(forKey: "solicitud_pendiente_aceptacion")
        textoSoliAceptada = TextoIdiomaController.localizedString(forKey: "solicitud_ya_esta_aceptada")
        textoSoliEnviada = TextoIdiomaController.localizedString(forKey: "solicitud_enviada")
        
        txtNombre.text = TextoIdiomaController.localizedString(forKey: "correo_electronico")
        
        configuracionInicial()
    }
    
    func configuracionInicial(){
        
        scrollView.delegate = self
           
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        scrollView.addGestureRecognizer(tapGesture)
                
        txtMensaje.text = textoIngresaCorreo
        
        edtCorreo.layer.cornerRadius = 10
        edtCorreo.clipsToBounds = true
        edtCorreo.delegate = self
        edtCorreo.setPadding(10)
        
        btnEnviar.layer.cornerRadius = 18
        btnEnviar.clipsToBounds = true
                
        let textoEnviar = TextoIdiomaController.localizedString(forKey: "enviar")
        
        
        if(tema){ // Dark
            
            // BOTON CONTNUAR
             
            btnEnviar.backgroundColor = .white
                  
             let btnContinuarAtributo = NSAttributedString(string: textoEnviar, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                NSAttributedString.Key.foregroundColor: UIColor.black,
             ])
                         
            btnEnviar.setAttributedTitle(btnContinuarAtributo, for: .normal)
            
        }else{
                 
            // BOTON CONTINUAR
                        
            btnEnviar.backgroundColor = .black
                 
            let btnContinuarAtributo = NSAttributedString(string: textoEnviar, attributes: [
               NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
               NSAttributedString.Key.foregroundColor: UIColor.white,
            ])
      
            btnEnviar.setAttributedTitle(btnContinuarAtributo, for: .normal)
                        
            if let myCustomColor = UIColor(named: "grisAAA") {
                edtCorreo.backgroundColor = myCustomColor
            }
        }
        
        let btnContinuarAtributoPress = NSAttributedString(string: textoEnviar, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
            NSAttributedString.Key.foregroundColor: UIColor.gray,
        ])

        btnEnviar.setAttributedTitle(btnContinuarAtributoPress, for: .highlighted)
    }
    
    
    
    func mensajeSinConexion(){
        mensajeToastAzul(mensaje: TextoIdiomaController.localizedString(forKey: "sin_conexion_a_internet"))
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
    
    @objc func tapGestureHandler() {
        // Cerrar el teclado
        view.endEditing(true)
    }
    

    @IBAction func btnEnviar(_ sender: Any) {
        cerrarTeclado()
       
        
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
        
        let encodeURL = apiEnviarSolicitudComunidad
        
        let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
            
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "iduser": iduser ?? "",
            "correo": edtCorreo.text ?? "",
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
                                
                                let estado = json["estado"].int ?? 0
                                
                                if(estado == 0){
                                    // pendiente aceptacion
                                    self.msgPendienteAceptacion()
                                    
                                }else{
                                    // solicitud ya fue aceptada
                                    self.msgSoliAceptada()
                                }
                            }
                            else if(successValue == 2){
                                self.msgEnviada()
                                
                            }
                            else if(successValue == 3){
                                self.msgCorreoNoEncontrado()
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
    
    func msgPendienteAceptacion(){
        let texto = TextoIdiomaController.localizedString(forKey: "solicitud_pendiente_aceptacion")
        
        mensajeToastAzul(mensaje: texto)
    }
    
    func msgSoliAceptada(){
        let texto = TextoIdiomaController.localizedString(forKey: "solicitud_ya_esta_aceptada")
        
        mensajeToastAzul(mensaje: texto)
    }
    
    func msgEnviada(){
        
        edtCorreo.text = ""
        let texto = TextoIdiomaController.localizedString(forKey: "solicitud_enviada")
        mensajeToastAzul(mensaje: texto)
    }
    
    func msgCorreoNoEncontrado(){
        let texto = TextoIdiomaController.localizedString(forKey: "correo_no_encontrado")
        
        mensajeToastAzul(mensaje: texto)
    }
    
    
    @IBAction func flechaAtras(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
