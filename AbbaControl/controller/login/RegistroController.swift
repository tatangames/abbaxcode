//
//  RegistroController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 10/3/24.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import RxSwift
import Toast_Swift
import OneSignalFramework


class RegistroController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
        
    
    // PANTALLA DE REGISTRO
    
    
    @IBOutlet weak var txtPrimerNombre: UILabel!
    @IBOutlet weak var edtPrimerNombre: UITextField!
    
    @IBOutlet weak var txtApellido: UILabel!
    @IBOutlet weak var edtApellido: UITextField!
    
    @IBOutlet weak var txtFechaNac: UILabel!
    @IBOutlet weak var datePickerFechaNac: UIDatePicker!
    
    @IBOutlet weak var txtGenero: UILabel!
    @IBOutlet weak var pickerGenero: UIPickerView!
    
    @IBOutlet weak var txtPais: UILabel!    
    @IBOutlet weak var pickerPais: UIPickerView!
    
    @IBOutlet weak var txtDepartamento: UILabel!
    @IBOutlet weak var pickerDepartamento: UIPickerView!
    
    @IBOutlet weak var txtIglesia: UILabel!
    @IBOutlet weak var pickerIglesia: UIPickerView!
    
    @IBOutlet weak var txtCorreo: UILabel!
    @IBOutlet weak var edtCorreo: UITextField!
    
    @IBOutlet weak var txtPassword: UILabel!
    @IBOutlet weak var edtPassword: UITextField!
    
    @IBOutlet weak var contenedorStack: UIStackView!

    @IBOutlet weak var btnRegistro: UIButton!
    
    
    @IBOutlet weak var stackPaisOtros: UIStackView!
    @IBOutlet weak var stackCiudadOtros: UIStackView!
    
    @IBOutlet weak var stackDepartamento: UIStackView!
    @IBOutlet weak var stackIglesia: UIStackView!
    
    
    @IBOutlet weak var labelPaisOtros: UILabel!
    @IBOutlet weak var labelCiudadOtros: UILabel!
    
    
    
    var boolPaisOtros = false
    
    @IBOutlet weak var edtPaisOtros: UITextField!
    @IBOutlet weak var edtCiudadOtros: UITextField!
    
    
    
    var tema = false
    var yaSeleccionoFecha = false
    var fechaNacimiento = ""
    var idIglesia = 0
    var idGenero = 0
    var idFirebase = ""
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var styleAzul = ToastStyle()
    
    var modeloIglesias: [ModeloIglesia] = []
    
    let disposeBag = DisposeBag()
    
    
    let generos: [ModeloGenero] = [
        
        ModeloGenero(id: 0, nombre: TextoIdiomaController.localizedString(forKey: "seleccionar_opcion")),
        
        ModeloGenero(id: 1, nombre: TextoIdiomaController.localizedString(forKey: "masculino")),
        
        ModeloGenero(id: 2, nombre: TextoIdiomaController.localizedString(forKey: "femenino"))
    ]
    
    
    let pais: [ModeloPais] = [
        
        ModeloPais(id: 0, nombre: TextoIdiomaController.localizedString(forKey: "seleccionar_opcion")),
        
        ModeloPais(id: 1, nombre: TextoIdiomaController.localizedString(forKey: "el_salvador"), imagen: UIImage(named: "flag_elsalvador")),
        
        ModeloPais(id: 2, nombre: TextoIdiomaController.localizedString(forKey: "guatemala"), imagen: UIImage(named: "flag_guatemala")),
        
        ModeloPais(id: 3, nombre: TextoIdiomaController.localizedString(forKey: "honduras"), imagen: UIImage(named: "flag_honduras")),
        
        ModeloPais(id: 4, nombre: TextoIdiomaController.localizedString(forKey: "nicaragua"), imagen: UIImage(named: "flag_nicaragua")),
        
        ModeloPais(id: 5, nombre: TextoIdiomaController.localizedString(forKey: "mexico"), imagen: UIImage(named: "flag_mexico")),
        
        ModeloPais(id: 6, nombre: TextoIdiomaController.localizedString(forKey: "otros"), imagen: UIImage(named: "localizacion")),
    ]
    
    
    
    let departamentoElSalvador: [ModeloDepartamentos] = [ModeloDepartamentos(id: 0, nombre: TextoIdiomaController.localizedString(forKey: "seleccionar_opcion")),
                                                         ModeloDepartamentos(id: 1, nombre: TextoIdiomaController.localizedString(forKey: "santa_ana")),
                                                         ModeloDepartamentos(id: 2, nombre: TextoIdiomaController.localizedString(forKey: "chalatenango")),
                                                         ModeloDepartamentos(id: 3, nombre: TextoIdiomaController.localizedString(forKey: "sonsonate")),
                                                         ModeloDepartamentos(id: 4, nombre: TextoIdiomaController.localizedString(forKey: "la_libertad")),
                                                         ModeloDepartamentos(id: 5, nombre: TextoIdiomaController.localizedString(forKey: "ahuachapan"))
    ]
    
    
    let departamentoGuatemala: [ModeloDepartamentos] = [ModeloDepartamentos(id: 0, nombre: TextoIdiomaController.localizedString(forKey: "seleccionar_opcion")),
                                                         ModeloDepartamentos(id: 6, nombre: TextoIdiomaController.localizedString(forKey: "san_marcos")),
                                                         ModeloDepartamentos(id: 7, nombre: TextoIdiomaController.localizedString(forKey: "quetzaltenango")),
                                                         ModeloDepartamentos(id: 8, nombre: TextoIdiomaController.localizedString(forKey: "retalhuleu")),
                                                         ModeloDepartamentos(id: 9, nombre: TextoIdiomaController.localizedString(forKey: "suchitepequez")),
                                                         ModeloDepartamentos(id: 10, nombre: TextoIdiomaController.localizedString(forKey: "solola")),
                                                         ModeloDepartamentos(id: 11, nombre: TextoIdiomaController.localizedString(forKey: "sacatepequez")),
                                                         ModeloDepartamentos(id: 12, nombre: TextoIdiomaController.localizedString(forKey: "chimaltenango")),
                                                         ModeloDepartamentos(id: 13, nombre: TextoIdiomaController.localizedString(forKey: "guatemala")),
                                                         ModeloDepartamentos(id: 14, nombre: TextoIdiomaController.localizedString(forKey: "escuintla")),
                                                         ModeloDepartamentos(id: 15, nombre: TextoIdiomaController.localizedString(forKey: "santa_rosa")),
                                                         ModeloDepartamentos(id: 16, nombre: TextoIdiomaController.localizedString(forKey: "jalapa")),
                                                         ModeloDepartamentos(id: 17, nombre: TextoIdiomaController.localizedString(forKey: "jutiapa")),
                                                         ModeloDepartamentos(id: 18, nombre: TextoIdiomaController.localizedString(forKey: "chiquimula")),
                                                         ModeloDepartamentos(id: 19, nombre: TextoIdiomaController.localizedString(forKey: "zacapa")),
    ]
    
    
    let departamentoHonduras: [ModeloDepartamentos] = [ModeloDepartamentos(id: 0, nombre: TextoIdiomaController.localizedString(forKey: "seleccionar_opcion")),
                                                         ModeloDepartamentos(id: 20, nombre: TextoIdiomaController.localizedString(forKey: "francisco_morazan")),
                                                         ModeloDepartamentos(id: 21, nombre: TextoIdiomaController.localizedString(forKey: "olancho")),
                                                         ModeloDepartamentos(id: 22, nombre: TextoIdiomaController.localizedString(forKey: "el_paraiso")),
    ]
    
    let departamentoNicaragua: [ModeloDepartamentos] = [ModeloDepartamentos(id: 0, nombre: TextoIdiomaController.localizedString(forKey: "seleccionar_opcion")),
                                                         ModeloDepartamentos(id: 23, nombre: TextoIdiomaController.localizedString(forKey: "esteli")),
                                                         ModeloDepartamentos(id: 24, nombre: TextoIdiomaController.localizedString(forKey: "madriz")),
                                                         ModeloDepartamentos(id: 25, nombre: TextoIdiomaController.localizedString(forKey: "nueva_segovia")),
    ]
    
    let departamentoMexico: [ModeloDepartamentos] = [ModeloDepartamentos(id: 0, nombre: TextoIdiomaController.localizedString(forKey: "seleccionar_opcion")),
                                                         ModeloDepartamentos(id: 26, nombre: TextoIdiomaController.localizedString(forKey: "hidalgo")),
                                                         ModeloDepartamentos(id: 27, nombre: TextoIdiomaController.localizedString(forKey: "chiapas")),
    ]
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let instanciaTema = TemaController()
        if( instanciaTema.conocerTemaActual() == 1){
            tema = true
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
        
        configuracionInicial()
        
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
     
        // IDENTIFICADOR ONE SIGNAL
        let id: String = OneSignal.User.pushSubscription.id ?? ""
        idFirebase = id
    }
        
    
    
    func configuracionInicial(){
        
        datePickerFechaNac.datePickerMode = .date
        datePickerFechaNac.maximumDate = Date()
       
        scrollView.delegate = self
           
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        scrollView.addGestureRecognizer(tapGesture)
        
        edtPrimerNombre.layer.cornerRadius = 10
        edtPrimerNombre.clipsToBounds = true
        edtPrimerNombre.delegate = self
        edtPrimerNombre.setPadding(10)
                
        edtApellido.layer.cornerRadius = 10
        edtApellido.clipsToBounds = true
        edtApellido.delegate = self
        edtApellido.setPadding(10)
             
        edtCorreo.layer.cornerRadius = 10
        edtCorreo.clipsToBounds = true
        edtCorreo.delegate = self
        edtCorreo.setPadding(10)
        
        edtPassword.layer.cornerRadius = 10
        edtPassword.clipsToBounds = true
        edtPassword.delegate = self
        edtPassword.setPadding(10)
        
        edtPaisOtros.layer.cornerRadius = 10
        edtPaisOtros.clipsToBounds = true
        edtPaisOtros.delegate = self
        edtPaisOtros.setPadding(10)
        
        edtCiudadOtros.layer.cornerRadius = 10
        edtCiudadOtros.clipsToBounds = true
        edtCiudadOtros.delegate = self
        edtCiudadOtros.setPadding(10)
        
        
        btnRegistro.layer.cornerRadius = 18
        btnRegistro.clipsToBounds = true
          
        
        if(tema){ // Dark
             
            btnRegistro.backgroundColor = .white
            btnRegistro.setTitleColor(.black, for: .normal)
        }else{
            btnRegistro.backgroundColor = .black
            btnRegistro.setTitleColor(.white, for: .normal)
            
            if let myCustomColor = UIColor(named: "grisAAA") {
                edtPrimerNombre.backgroundColor = myCustomColor
                edtApellido.backgroundColor = myCustomColor
                edtCorreo.backgroundColor = myCustomColor
                edtPassword.backgroundColor = myCustomColor
                
                edtPaisOtros.backgroundColor = myCustomColor
                edtCiudadOtros.backgroundColor = myCustomColor
            }
        }
        
       
        // TEXTOS LABEL
        txtPrimerNombre.text = TextoIdiomaController.localizedString(forKey: "primer_nombre")
        txtApellido.text = TextoIdiomaController.localizedString(forKey: "apellido")
        txtFechaNac.text = TextoIdiomaController.localizedString(forKey: "fecha_de_nacimiento")
        txtGenero.text = TextoIdiomaController.localizedString(forKey: "seleccionar_genero")
        txtPais.text = TextoIdiomaController.localizedString(forKey: "seleccionar_pais")
        txtDepartamento.text = TextoIdiomaController.localizedString(forKey: "departamento")
        txtIglesia.text = TextoIdiomaController.localizedString(forKey: "municipio")
        txtCorreo.text = TextoIdiomaController.localizedString(forKey: "correo_electronico")
        txtPassword.text = TextoIdiomaController.localizedString(forKey: "contrasena")
        
        
        labelPaisOtros.text = TextoIdiomaController.localizedString(forKey: "pais")
        
        labelCiudadOtros.text = TextoIdiomaController.localizedString(forKey: "ciudad")
        
        
               
        btnRegistro.setTitle(TextoIdiomaController.localizedString(forKey: "crear_cuenta"), for: .normal)
        
        pickerGenero.dataSource = self
        pickerGenero.delegate = self
        pickerPais.dataSource = self
        pickerPais.delegate = self
    }
    
    @objc func tapGestureHandler() {
        // Cerrar el teclado
        view.endEditing(true)
    }
    
    // cerrar teclado al tocar boton intro
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
        
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
         
         // Crear un DateFormatter para cambiar el formato de la fecha
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd" // Establecer el formato deseado
         
         // Convertir la fecha seleccionada al formato deseado
         let formattedDate = dateFormatter.string(from: selectedDate)
        
        yaSeleccionoFecha = true
        fechaNacimiento = formattedDate
    }
       

    
    func mensajeSinConexion(){
        mensajeToastAzul(mensaje: TextoIdiomaController.localizedString(forKey: "sin_conexion_a_internet"))
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
     
    var selectedPaisIndex = 0
    
    
    @IBAction func btnRegistro(_ sender: Any) {
        
        verificar()
    }
    
    func verificar(){
        
        if(ValidarTexto().validarEntradaRequerida(texto: edtPrimerNombre.text ?? "") == 1){
            mensajeToastAzul(mensaje: TextoIdiomaController.localizedString(forKey: "nombre_requerido"))
            return
        }
        
        if(ValidarTexto().validarEntradaRequerida(texto: edtApellido.text ?? "") == 1){
            mensajeToastAzul(mensaje: TextoIdiomaController.localizedString(forKey: "apellido_requerido"))
            return
        }
 
        if(!yaSeleccionoFecha){
            mensajeToastAzul(mensaje: TextoIdiomaController.localizedString(forKey: "fecha_nacimiento_es_requerido"))
            return
        }

        if(idGenero == 0){
            mensajeToastAzul(mensaje: TextoIdiomaController.localizedString(forKey: "genero_es_requerido"))
            return
        }
        
        if(boolPaisOtros){
            
            if(ValidarTexto().validarEntradaRequerida(texto: edtPaisOtros.text ?? "") == 1){
                mensajeToastAzul(mensaje: TextoIdiomaController.localizedString(forKey: "escribir_pais"))
                return
            }
            
            if(ValidarTexto().validarEntradaRequerida(texto: edtCiudadOtros.text ?? "") == 1){
                mensajeToastAzul(mensaje: TextoIdiomaController.localizedString(forKey: "escribir_ciudad"))
                return
            }
            
            // IGLESIA DEFECTO
            idIglesia = 503
            
        }else{
            if(idIglesia == 0){
                mensajeToastAzul(mensaje: TextoIdiomaController.localizedString(forKey: "seleccionar_municipio"))
                return
            }
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
        
        // CONTRASEÑA
        
        if(ValidarTexto().validarEntradaRequerida(texto: edtPassword.text ?? "") == 1){
            mensajeToastAzul(mensaje: TextoIdiomaController.localizedString(forKey: "password_requerido"))
            return
        }
        
        if(ValidarTexto().validarPassword6minCaracteres(texto: edtPassword.text ?? "") == 1){
            mensajeToastAzul(mensaje: TextoIdiomaController.localizedString(forKey: "contrasena_minimo_seis"))
            return
        }
        
        preguntarFinalizar()
    }
    
    func preguntarFinalizar(){
        
        let textoEnviar = TextoIdiomaController.localizedString(forKey: "enviar")
        let textoEditar = TextoIdiomaController.localizedString(forKey: "editar")
        
        let alert = UIAlertController(title: TextoIdiomaController.localizedString(forKey: "completar_registro"), message: TextoIdiomaController.localizedString(forKey: "se_ve_genial"), preferredStyle: UIAlertController.Style.alert)
                 
             alert.addAction(UIAlertAction(title: textoEditar, style: UIAlertAction.Style.default, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
              
             }))
             
             alert.addAction(UIAlertAction(title: textoEnviar, style: UIAlertAction.Style.default, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
              self.registrarUsuario()
             }))
              
             self.present(alert, animated: true, completion: nil)
    }
    
    
    func registrarUsuario(){
                
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiRegistroUsuario
        
        let parameters: [String: Any] = [
            "nombre": edtPrimerNombre.text ?? "",
            "apellido": edtApellido.text ?? "",
            "edad": fechaNacimiento,
            "genero": idGenero,
            "iglesia": idIglesia,
            "correo": edtCorreo.text ?? "",
            "password": edtPassword.text ?? "",
            "idonesignal": idFirebase,
            "version": apiVersionApp,
            "paisotros": edtPaisOtros.text ?? "",
            "ciudadotros": edtCiudadOtros.text ?? ""
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
                              
                                self.correoYaRegistrado()
                                
                            }
                            else if(successValue == 2){
                                
                                let idCliente = json["id"].stringValue
                                let token = json["token"].stringValue
                               
                                // guardar id del cliente
                                UserDefaults.standard.setValueIdCliente(value: idCliente)
                                UserDefaults.standard.setValueTokenCliente(value: token)
                                
                                self.finalizar()
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
    
    
    func correoYaRegistrado(){
        
        let titulo = TextoIdiomaController.localizedString(forKey: "aviso")
        
        let mensaje = TextoIdiomaController.localizedString(forKey: "correo_ya_registrado")
                
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertController.Style.alert)
       
             alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
             }))
              
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // redireccionar pantalla para principal tab
    func finalizar(){
        
        let vista : TabBarPrincipalController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "TabBarPrincipalController") as! TabBarPrincipalController
        
        self.present(vista, animated: true, completion: nil)
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
    
    // volver a pantalla login
    @IBAction func bnFlechaAtras(_ sender: Any) {
        
        let vista : LoginRegisterController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginRegisterController") as! LoginRegisterController
                
        self.present(vista, animated: true, completion: nil)
    }
    
    
}

extension RegistroController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == pickerGenero {
            return generos.count
        }
        else if pickerView == pickerPais {
            return pais.count
        } else if pickerView == pickerDepartamento {
            
            
            
            let selectedPais = pais[pickerPais.selectedRow(inComponent: 0)]
            
            edtPaisOtros.text = ""
            edtCiudadOtros.text = ""
            
            if(selectedPais.id == 6){
                bloqueo1()
            }else{
                bloque2()
            }
            
            
            switch selectedPais.id {
            case 1: // El Salvador
                return departamentoElSalvador.count
            case 2: // Guatemala
                return departamentoGuatemala.count
            case 3: // Honduras
                return departamentoHonduras.count
            case 4: // Nicaragua
                return departamentoNicaragua.count
            case 5: // Mexico
                return departamentoMexico.count
       
            default:
                return 0
            }
            
            
        }
        else if pickerView == pickerIglesia {
            return modeloIglesias.count
        }
        return 0
    }
    
    
    func bloqueo1(){
        boolPaisOtros = true
        
        stackDepartamento.isHidden = true
        stackIglesia.isHidden = true
        
        stackPaisOtros.isHidden = false
        stackCiudadOtros.isHidden = false
    }
    
    func bloque2(){
        stackPaisOtros.isHidden = true
        stackCiudadOtros.isHidden = true
        
        stackDepartamento.isHidden = false
        stackIglesia.isHidden = false
        
        
        boolPaisOtros = false
        
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let containerView = UIView()
        
        if pickerView == pickerGenero {
            
            let label = UILabel(frame: CGRect(x: 40, y: 0, width: pickerView.frame.width - 40, height: 30))
            label.text = generos[row].nombre
            containerView.addSubview(label)
            
        } else if pickerView == pickerPais {
            
            
            if let imagen = pais[row].imagen {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                imageView.image = imagen
                containerView.addSubview(imageView)
            }
            
            let label = UILabel(frame: CGRect(x: 40, y: 0, width: pickerView.frame.width - 40, height: 30))
            label.text = pais[row].nombre
            containerView.addSubview(label)
            
            
            
            
            
        }
        
        else if pickerView == pickerDepartamento {
            let label = UILabel(frame: CGRect(x: 40, y: 0, width: pickerView.frame.width - 40, height: 30))
            
            let selectedPais = pais[pickerPais.selectedRow(inComponent: 0)]
           
            switch selectedPais.getId() {
            case 1: // El Salvador
                label.text = departamentoElSalvador[row].nombre
                containerView.addSubview(label)
            case 2: // Guatemala
                label.text = departamentoGuatemala[row].nombre
                containerView.addSubview(label)
            case 3: // Honduras
                label.text = departamentoHonduras[row].nombre
                containerView.addSubview(label)
            case 4: // Nicaragua
                label.text = departamentoNicaragua[row].nombre
                containerView.addSubview(label)
            case 5: // Mexico
                label.text = departamentoMexico[row].nombre
                containerView.addSubview(label)
            default:
                return containerView
            }
        }
        else  if pickerView == pickerIglesia {
            
            let label = UILabel(frame: CGRect(x: 40, y: 0, width: pickerView.frame.width - 40, height: 30))
            label.text = modeloIglesias[row].nombre
            containerView.addSubview(label)
        }
        
        return containerView
    }
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerGenero {
            let selectedGenero = generos[row]
            idGenero = selectedGenero.getId()
            
        } else if pickerView == pickerPais {
            let selectedPais = pais[row]
            selectedPaisIndex = selectedPais.id
            
            if (selectedPais.getId() == 0){
                
                idIglesia = 0
                pickerDepartamento.reloadAllComponents()
                
                modeloIglesias.removeAll()
                pickerIglesia.reloadAllComponents()
                pickerIglesia.selectRow(0, inComponent: 0, animated: true)
            }
            else{
                pickerDepartamento.dataSource = self
                pickerDepartamento.delegate = self
                pickerDepartamento.reloadAllComponents()
                pickerDepartamento.selectRow(0, inComponent: 0, animated: true)
            }
            
        } else if pickerView == pickerDepartamento {
            
            var selectedDepartamentoID: Int
            
            // El salvador
            if selectedPaisIndex == 1 {
                let selectedDepartamento = departamentoElSalvador[row]
                selectedDepartamentoID = selectedDepartamento.id
            }
            // Guatemala
            else if selectedPaisIndex == 2 {
                let selectedDepartamento = departamentoGuatemala[row]
                selectedDepartamentoID = selectedDepartamento.id
            }
            // Honduras
            else if selectedPaisIndex == 3 {
                let selectedDepartamento = departamentoHonduras[row]
                selectedDepartamentoID = selectedDepartamento.id
            }
            // Nicaragua
            else if selectedPaisIndex == 4 {
                let selectedDepartamento = departamentoNicaragua[row]
                selectedDepartamentoID = selectedDepartamento.id
            }
            // Honduras
            else if selectedPaisIndex == 5 {
                let selectedDepartamento = departamentoMexico[row]
                selectedDepartamentoID = selectedDepartamento.id
            }
            else {
                selectedDepartamentoID = 0 // Si no se ha seleccionado ningún país, el ID del departamento es 0
            }
            
            if(selectedDepartamentoID == 0){
                idIglesia = 0
                modeloIglesias.removeAll()
                pickerIglesia.dataSource = self
                pickerIglesia.delegate = self
                pickerIglesia.reloadAllComponents()
                pickerIglesia.selectRow(0, inComponent: 0, animated: true)
            }else{
                apiBuscarIglesia(iddepa: selectedDepartamentoID)
            }
        }
        else if pickerView == pickerIglesia {
            let selectedIgleisa = modeloIglesias[row]
            idIglesia = selectedIgleisa.getId()
        }
    }
    
    
    
    func apiBuscarIglesia(iddepa: Int){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiListadoIglesias
        
        let parameters: [String: Any] = [
            "iddepa": iddepa,
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
                                json["listado"].array?.forEach({ (dataArray) in
                                    
                                    let id = dataArray["id"].intValue
                                    let nombre = dataArray["nombre"].stringValue
                                    
                                    
                                    
                                    let iglesia = ModeloIglesia(id: id, nombre: nombre)
                                    self.modeloIglesias.append(iglesia)
                                })
                                
                                self.primerIdIglesiaModelo()
                                self.updatePickerViews()
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
    
    func primerIdIglesiaModelo(){
        if let primerModelo = modeloIglesias.first {
            idIglesia = primerModelo.id
          
        }
    }
        
    func updatePickerViews() {
      DispatchQueue.main.async {
          self.pickerIglesia.dataSource = self
          self.pickerIglesia.delegate = self
          self.pickerIglesia.reloadAllComponents()
          self.pickerIglesia.selectRow(0, inComponent: 0, animated: true)
      }
    }
    
    
}
