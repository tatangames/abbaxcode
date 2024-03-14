//
//  VerificarCodigoController.swift
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

class VerificarCodigoController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate  {

    
    public var correo = ""
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var txtTitulo: UILabel!
    @IBOutlet weak var txtCodigo: UILabel!
    @IBOutlet weak var edtCodigo: UITextField!
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
        
        
        let texto = TextoIdiomaController.localizedString(forKey: "ingresar_el_codigo_que_se") + "\n" + correo
        
        txtTitulo.text = texto
        
        txtCodigo.text = TextoIdiomaController.localizedString(forKey: "codigo")
        
        
        edtCodigo.layer.cornerRadius = 10
        edtCodigo.clipsToBounds = true
        edtCodigo.delegate = self
        edtCodigo.setPadding(10)
        
        btnEnviar.layer.cornerRadius = 18
        btnEnviar.clipsToBounds = true
        
        
        let textContinuar = TextoIdiomaController.localizedString(forKey: "continuar")
        
        
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
                edtCodigo.backgroundColor = myCustomColor
            }
        }
        
        // *** HIGHLIGHTED BOTON CONTINUAR
        let btnContinuarAtributoPress = NSAttributedString(string: textContinuar, attributes: [
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
    
    
    @IBAction func btnEnviar(_ sender: Any) {
            
        if(ValidarTexto().validarEntradaRequerida(texto: edtCodigo.text ?? "") == 1){
            mensajeToastAzul(mensaje: TextoIdiomaController.localizedString(forKey: "codigo_es_requerido"))
            return
        }
        
        verificar()
    }
    
    func verificar(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiVerificarCodigoCorreo
        
        
        let parameters: [String: Any] = [
            "codigo": edtCodigo.text ?? "",
            "correo": correo, // defecto español
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
                             
                                // codigo verificado
                                let token = json["token"].stringValue
                                UserDefaults.standard.setValueTokenCliente(value: token)
                                
                                self.siguientePantalla()
                                
                            }
                            else if(successValue == 2){
                                
                                // codigo invalido
                                self.codigoInvalido()
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
    
    
    
    func codigoInvalido(){
        mensajeToastAzul(mensaje: TextoIdiomaController.localizedString(forKey: "codigo_incorrecto"))
    }
    
    
    func siguientePantalla(){        
        let vistaSiguiente : NuevaPassController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NuevaPassController") as! NuevaPassController
                      
        self.present(vistaSiguiente, animated: true, completion: nil)
    }
    
        
    
    @IBAction func btnFlechaAtras(_ sender: Any) {
        
        let vistaSiguiente : OlvidePasswordController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OlvidePasswordController") as! OlvidePasswordController
        
        vistaSiguiente.correo = correo
              
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
