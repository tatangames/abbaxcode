//
//  LoginRegisterController.swift
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

class LoginRegisterController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
    

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnRegistro: UIButton!
    @IBOutlet weak var txtTitulo: UILabel!
    @IBOutlet weak var txtYaTienesCuenta: UILabel!
    @IBOutlet weak var btnIngresar: UIButton!
    @IBOutlet weak var txtTituloBajo: UILabel!
    
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Esta pantalla tendra tema Light siempre
        overrideUserInterfaceStyle = .light
        
        txtTitulo.text = TextoIdiomaController.localizedString(forKey: "bienvenidos_a_mi_caminar_con_Dios")
        
        txtYaTienesCuenta.text = TextoIdiomaController.localizedString(forKey: "ya_tines_una_cuenta")
        txtTituloBajo.text = TextoIdiomaController.localizedString(forKey: "levantado_el_ejercito")
        
        configuracionInicial()
        
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
    }
    
    
    func configuracionInicial(){
        
        scrollView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        scrollView.addGestureRecognizer(tapGesture)
        
        btnRegistro.layer.cornerRadius = 18
        btnRegistro.clipsToBounds = true
          
        
        btnRegistro.backgroundColor = .black
        btnRegistro.setTitleColor(.white, for: .normal)
        btnRegistro.setTitleColor(.gray, for: .highlighted)
        btnRegistro.setTitle(TextoIdiomaController.localizedString(forKey: "registrarse"), for: .normal)
       
        
        let textoIngresar = TextoIdiomaController.localizedString(forKey: "ingresar")
        let btnIngresarAtributoHold = NSAttributedString(string: textoIngresar, attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 23),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ])
        
        let btnIngresarAtributoPress = NSAttributedString(string: textoIngresar, attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 23),
            NSAttributedString.Key.foregroundColor: UIColor.gray
        ])

        btnIngresar.setAttributedTitle(btnIngresarAtributoHold, for: .normal)
        btnIngresar.setAttributedTitle(btnIngresarAtributoPress, for: .highlighted)
        
        
        if let myCustomColor = UIColor(named: "gris757575") {
            txtYaTienesCuenta.textColor = myCustomColor
        }
    }
    
    @IBAction func btnRegistro(_ sender: Any) {
        
        let vista : RegistroController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegistroController") as! RegistroController
                
        self.present(vista, animated: true, completion: nil)
    }
    
    @IBAction func btnIngresar(_ sender: Any) {
        let vista : LoginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as! LoginController
                
        self.present(vista, animated: true, completion: nil)
    }
    
    
    

    @objc func tapGestureHandler() {
        // Cerrar el teclado
        view.endEditing(true)
    }
    
    // cerrar teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func mensajeSinConexion(){
        mensajeToastAzul(mensaje: "Sin conexion")
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
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
