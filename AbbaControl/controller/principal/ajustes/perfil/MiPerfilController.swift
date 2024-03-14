//
//  MiPerfilController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 13/3/24.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import RxSwift
import Toast_Swift

class MiPerfilController: UIViewController,  UIScrollViewDelegate, UITextFieldDelegate {
   
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var txtNombre: UILabel!
    @IBOutlet weak var edtNombre: UITextField!
    
    
    @IBOutlet weak var txtApellido: UILabel!
    @IBOutlet weak var edtApellido: UITextField!
        
    @IBOutlet weak var txtFechaNac: UILabel!
    @IBOutlet weak var pickerFecha: UIDatePicker!
    
    @IBOutlet weak var txtCorreo: UILabel!
    @IBOutlet weak var edtCorreo: UITextField!
    
    @IBOutlet weak var btnEnviar: UIButton!
    
    @IBOutlet weak var toolbar: UINavigationItem!
    
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    var tema = false
    var fechaNacimiento = ""
    
    // para poder decirle a AjusteController que se actualice al
    // hacer dismiss aqui
    var delegate: protocolPerfilController!
    var recargarVistaAnterior = false
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
        delegate.pasarDatosProtocol(data: recargarVistaAnterior)
    }
    
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
        
        toolbar.title = TextoIdiomaController.localizedString(forKey: "perfil")
        
        configuracionInicial()
        
        apiSolicitarDatos()
    }
        
    func configuracionInicial(){
        
        scrollView.delegate = self
           
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        scrollView.addGestureRecognizer(tapGesture)
        
        pickerFecha.datePickerMode = .date
        pickerFecha.maximumDate = Date()
        
        scrollView.delegate = self
            
        edtNombre.layer.cornerRadius = 10
        edtNombre.clipsToBounds = true
        edtNombre.delegate = self
        edtNombre.setPadding(10)
                
        edtApellido.layer.cornerRadius = 10
        edtApellido.clipsToBounds = true
        edtApellido.delegate = self
        edtApellido.setPadding(10)
             
        edtCorreo.layer.cornerRadius = 10
        edtCorreo.clipsToBounds = true
        edtCorreo.delegate = self
        edtCorreo.setPadding(10)
        
        btnEnviar.layer.cornerRadius = 18
        btnEnviar.clipsToBounds = true
        
        let textContinuar = TextoIdiomaController.localizedString(forKey: "actualizar")
        
        if(tema){ // Dark
             
            btnEnviar.backgroundColor = .white
                  
             let btnContinuarAtributo = NSAttributedString(string: textContinuar, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                NSAttributedString.Key.foregroundColor: UIColor.black,
             ])
                         
            btnEnviar.setAttributedTitle(btnContinuarAtributo, for: .normal)
        }else{
          
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
                edtNombre.backgroundColor = myCustomColor
                edtApellido.backgroundColor = myCustomColor
                edtCorreo.backgroundColor = myCustomColor
            }
        }
        
        txtNombre.text = TextoIdiomaController.localizedString(forKey: "primer_nombre")
        
        txtApellido.text = TextoIdiomaController.localizedString(forKey: "apellido")
        txtFechaNac.text = TextoIdiomaController.localizedString(forKey: "seleccionar_edad")
        txtCorreo.text = TextoIdiomaController.localizedString(forKey: "correo_electronico")
    }
    
   
    func apiSolicitarDatos(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiInfoMiPerfil
        
        let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "iduser": iduser ?? 0,
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
                                
                                let nombre = json["nombre"].stringValue
                                let apellido = json["apellido"].stringValue
                                let correo = json["correo"].stringValue
                                let fechaNacRaw = json["fecha_nac_raw"].stringValue
                                
                                self.fechaNacimiento = fechaNacRaw
                                
                                self.setearDatos(nombre: nombre, apellido: apellido, fechaNac: fechaNacRaw, correo: correo)
                                
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
    
    
    func setearDatos(nombre: String, apellido: String, fechaNac: String, correo: String){
        
        edtNombre.text = nombre
        edtApellido.text = apellido
        edtCorreo.text = correo
        
        // mover picker a una fecha
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
       
        if let fecha = dateFormatter.date(from: fechaNac) {
           pickerFecha.date = fecha
        }
        
        scrollView.isHidden = false
    }
    
    
    
    
    @IBAction func btnEnviar(_ sender: Any) {
        
       verificar()
    }
    
    func verificar(){
        
        if(ValidarTexto().validarEntradaRequerida(texto: edtNombre.text ?? "") == 1){
            mensajeToastAzul(mensaje: TextoIdiomaController.localizedString(forKey: "nombre_requerido"))
            return
        }
        
        if(ValidarTexto().validarEntradaRequerida(texto: edtApellido.text ?? "") == 1){
            mensajeToastAzul(mensaje: TextoIdiomaController.localizedString(forKey: "apellido_requerido"))
            return
        }
 
        // CORREO
        
        if(ValidarTexto().validarEntradaRequerida(texto: edtCorreo.text ?? "") == 1){
            mensajeToastAzul(mensaje: TextoIdiomaController.localizedString(forKey: "correo_requerido"))
            return
        }
        
        if(ValidarTexto().validarCorreoElectronico(texto: edtCorreo.text ?? "") == false){
            mensajeToastAzul(mensaje: TextoIdiomaController.localizedString(forKey: "correo_no_valido"))
            return
        }
        
        actualizarDatos()
    }
    
    
    func actualizarDatos(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiActualizarPerfil
        
        let token = UserDefaults.standard.getValueTokenUsuario()
        let idusuario = UserDefaults.standard.getValueIdUsuario()
        
        let parameters: [String: Any] = [
            "iduser": idusuario ?? 0,
            "nombre": edtNombre.text ?? "",
            "apellido": edtApellido.text ?? "",
            "fechanac": fechaNacimiento,
            "correo": edtCorreo.text ?? "",
        ]
                
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
                             
                                // correo ya registrado
                                self.correoYaRegistrado()
                            }
                            else if(successValue == 2){
                                // datos actualizados
                                self.infoActualizada()
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
            // Hacer algo cuando la solicitud tenga éxito
            
        }, onError: { error in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.mensajeSinConexion()
        })
        .disposed(by: disposeBag)
    }
    
    func infoActualizada(){
        let mensaje = TextoIdiomaController.localizedString(forKey: "actualizado")
        
        recargarVistaAnterior = true
        
        mensajeToastAzul(mensaje: mensaje)
    }
    
    func correoYaRegistrado(){
        let titulo = TextoIdiomaController.localizedString(forKey: "aviso")
        
        let mensaje = TextoIdiomaController.localizedString(forKey: "correo_ya_registrado")
                
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertController.Style.alert)
       
             alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
           
             }))
              
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
         
         // Crear un DateFormatter para cambiar el formato de la fecha
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd" // Establecer el formato deseado
         
         // Convertir la fecha seleccionada al formato deseado
         let formattedDate = dateFormatter.string(from: selectedDate)
        
        fechaNacimiento = formattedDate
    }
    
    

    @IBAction func flechaAtras(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func mensajeSinConexion(){
        mensajeToastAzul(mensaje: TextoIdiomaController.localizedString(forKey: "sin_conexion_a_internet"))
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
     

    // cerrar teclado al tocar boton intro
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
