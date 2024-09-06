//
//  DevoPreguntaTab2Controller.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 21/3/24.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import RxSwift
import Toast_Swift
import SDWebImage

class DevoPreguntaTab2Controller: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var idblockdeta = 0

    
    var tema = false
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    
    var datoDescripcion = ""
    var datoHayRespuesta = 0
    var datoGenero = 0
    
    var items: [ModeloPreguntas] = []
    
    
    var textoCampoRequerido = ""
    
    
    @IBOutlet weak var tableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let instanciaTema = TemaController()
        if( instanciaTema.conocerTemaActual() == 1){
            tema = true
         
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
        
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        
        textoCampoRequerido = TextoIdiomaController.localizedString(forKey: "campo_requerido")
        
        tableview.dataSource = self
        tableview.delegate = self
        
        tableview.separatorStyle = .none
                
        // Agrega un gesto de reconocimiento de toque al UITableView para cerrar el teclado
             let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
             tableview.addGestureRecognizer(tapGesture)
                
        apiBuscarDatos()
    }
    
    @objc func tableViewTapped() {
           view.endEditing(true) // Cierra el teclado al tocar el UITableView
       }
    
    func apiBuscarDatos(){
                        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiInformacionPreguntasBloqueDeta
        
        let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
        let idiomaPlan = UserDefaults.standard.getValueIdiomaApp()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "iduser": iduser ?? 0,
            "idiomaplan": idiomaPlan ?? 1,
            "idblockdeta": idblockdeta
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
                                
                                self.datoDescripcion = json["descripcion"].string ?? ""
                                self.datoHayRespuesta = json["hayrespuesta"].int ?? 0
                                self.datoGenero = json["genero"].int ?? 0
                                
                                
                                // PRIMERA LLENADA ES PARA IMAGEN
                                let bloque1 = ModeloPreguntas(id: 0, requerido: 0, titulo: "", texto: "", idImagenPregunta: 0, imagen: "", tipo: 1, textoRequerido: "", activarTextoRequerido: false)
                                
                                self.items.append(bloque1)
                                
                             
                                // SEGUNDA ES PARA EL TEXTO DEBAJO DE IMAGEN
                                if(self.datoDescripcion.isEmpty){
                                    // no llenar nada
                                }else{
                                    let bloque2 = ModeloPreguntas(id: 0, requerido: 0, titulo: "", texto: "", idImagenPregunta: 0, imagen: "", tipo: 2, textoRequerido: "", activarTextoRequerido: false)
                                    
                                    self.items.append(bloque2)
                                }
                                
                                                                
                                json["listado"].array?.forEach({ (dataArray) in
                                                       
                                    let miid = dataArray["id"].int ?? 0
                                    let mirequerido = dataArray["requerido"].int ?? 0
                                    let mititulo = dataArray["titulo"].string ?? ""
                                    let mitexto = dataArray["texto"].string ?? ""
                                    let miidimagenpregunta = dataArray["id_imagen_pregunta"].int ?? 0
                                    let miimagen = dataArray["imagen"].string ?? ""
                                 
                                    
                                    let bloque3 = ModeloPreguntas(id: miid, requerido: mirequerido, titulo: mititulo, texto: mitexto, idImagenPregunta: miidimagenpregunta, imagen: miimagen, tipo: 3, textoRequerido: "", activarTextoRequerido: false)
                                    
                                    self.items.append(bloque3)
                                })
                                
                                                                
                                // BLOQUE 4 PARA BOTONERA
                                let bloque4 = ModeloPreguntas(id: 0, requerido: 0, titulo: "", texto: "", idImagenPregunta: 0, imagen: "", tipo: 4, textoRequerido: "", activarTextoRequerido: false)
                                
                                self.items.append(bloque4)
                                
                                
                                
                                self.tableview.reloadData()
                                                               
                            }
                            else if(successValue == 2){
                             
                                // no hay cuestionario, aunque no deberia entrar aqui, no cargara nada
                                
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
    
 
    
    
    
    func mensajeSinConexion(){
        let msg = TextoIdiomaController.localizedString(forKey: "sin_conexion_a_internet")
        mensajeToastAzul(mensaje: msg)
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }
    
    
    @objc func buttonGuardarTapped(_ sender: UIButton) {
        // Lógica cuando se pulsa el botón 1 en cualquier celda
        guardarDatos()
    }

    @objc func buttonCompartirTapped(_ sender: UIButton) {
        // Lógica cuando se pulsa el botón 2 en cualquier celda
        verificarCompartir()
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    // METODOS TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
       return items.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                 
        let selectedItem = items[indexPath.row]
        
        if(selectedItem.tipo == 1){
            
            // TITULO DE PANTALLA
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! PreguntasCell1
            
            if(datoGenero == 1){
                cell.imgDevo.image = UIImage(named: "icnino")
            }else{
                cell.imgDevo.image = UIImage(named: "icnina")
            }
            
               
            cell.selectionStyle = .none
            
            return cell
        }
        else if(selectedItem.tipo == 2){
            
            // TITULO DE PANTALLA
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! PreguntasCell2
                       
              // Convierte el texto HTML en un NSAttributedString
              if let attributedString = try? NSAttributedString(data: datoDescripcion.data(using: .utf16)!,
                                                                  options: [.documentType: NSAttributedString.DocumentType.html],
                                                                  documentAttributes: nil) {
                  // Asigna el NSAttributedString al UILabel
                  cell.txtHtml.attributedText = attributedString
                  
                  cell.txtHtml.font = UIFont.systemFont(ofSize: 24, weight: .bold)
              }
            
            if(tema){
                cell.txtHtml.textColor = .white
            }else{
                cell.txtHtml.textColor = .black
            }
            
            cell.txtHtml.numberOfLines = 0 // Permite múltiples líneas
            cell.txtHtml.lineBreakMode = .byWordWrapping //
               
            cell.selectionStyle = .none
            
            return cell
        }
        else if(selectedItem.tipo == 3){
            
            // TITULO DE PANTALLA
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! PreguntasCell3
            
            // Configura las esquinas redondeadas
            cell.vista.layer.cornerRadius = 20
            // Habilita la máscara de recorte para que las subvistas sigan la forma de las esquinas redondeadas
            cell.vista.clipsToBounds = true
            
            cell.edtTexto.layer.cornerRadius = 10
            cell.edtTexto.clipsToBounds = true
            cell.edtTexto.setPadding(10)
            
            
            let mitexto = selectedItem.titulo
            
            // Convierte el texto HTML en un NSAttributedString
            if let attributedString = try? NSAttributedString(data: mitexto.data(using: .utf16)!,
                                                                options: [.documentType: NSAttributedString.DocumentType.html],
                                                                documentAttributes: nil) {
                // Asigna el NSAttributedString al UILabel
                cell.txtTitulo.attributedText = attributedString
                
                cell.txtTitulo.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            }
              
            if(tema){
                cell.vista.backgroundColor = UIColor.white
            }else{
                cell.vista.backgroundColor = UIColor.systemGray6
            }
            
            cell.txtTitulo.textColor = .black
            
            if let myCustomColor = UIColor(named: "grisAAA") {
                cell.edtTexto.backgroundColor = myCustomColor
            }
            
            
            cell.edtTexto.delegate = self
            cell.edtTexto.tag = indexPath.row
            
            cell.edtTexto.text = selectedItem.texto
                 
            if(selectedItem.activarTextoRequerido){
                cell.txtRequerido.text = textoCampoRequerido
            }else{
                cell.txtRequerido.text = ""
            }
                
               
            cell.selectionStyle = .none
            
            return cell
        }
        else if(selectedItem.tipo == 4){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! PreguntasCell4
            
            cell.selectionStyle = .none
            
            cell.btnGuardar.layer.cornerRadius = 18
            cell.btnGuardar.clipsToBounds = true
            
            cell.btnCompartir.layer.cornerRadius = 18
            cell.btnCompartir.clipsToBounds = true
            
            let textoGuardar = TextoIdiomaController.localizedString(forKey: "guardar")
            let textoCompartir = TextoIdiomaController.localizedString(forKey: "compartir")
            
            if(tema){ // Dark
                
                // BOTON CONTNUAR
                 
                cell.btnGuardar.backgroundColor = .white
                cell.btnCompartir.backgroundColor = .white
                      
                 let btnGuardarAtributo = NSAttributedString(string: textoGuardar, attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                    NSAttributedString.Key.foregroundColor: UIColor.black,
                 ])
                             
                cell.btnGuardar.setAttributedTitle(btnGuardarAtributo, for: .normal)
               
                let btnCompartirAtributo = NSAttributedString(string: textoCompartir, attributes: [
                   NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                   NSAttributedString.Key.foregroundColor: UIColor.black,
                ])
                            
               cell.btnCompartir.setAttributedTitle(btnCompartirAtributo, for: .normal)
              
              
                
            }else{
                
                
                cell.btnGuardar.backgroundColor = .black
                cell.btnCompartir.backgroundColor = .black
                
                let btnAtributoGuardar = NSAttributedString(string: textoGuardar, attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                    NSAttributedString.Key.foregroundColor: UIColor.white,
                ])
                
                let btnAtributoCompartir = NSAttributedString(string: textoCompartir, attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                    NSAttributedString.Key.foregroundColor: UIColor.white,
                ])
                
                cell.btnGuardar.setAttributedTitle(btnAtributoGuardar, for: .normal)
                
                cell.btnCompartir.setAttributedTitle(btnAtributoCompartir, for: .normal)
            }
            
            // *** HIGHLIGHTED
            let btnAtributoPressGuardar = NSAttributedString(string: textoGuardar, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                NSAttributedString.Key.foregroundColor: UIColor.gray,
            ])

            cell.btnGuardar.setAttributedTitle(btnAtributoPressGuardar, for: .highlighted)
            
            let btnAtributoPressCompartir = NSAttributedString(string: textoCompartir, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
                NSAttributedString.Key.foregroundColor: UIColor.gray,
            ])

            cell.btnCompartir.setAttributedTitle(btnAtributoPressCompartir, for: .highlighted)
            
            
            // Asigna las acciones para los botones
            cell.btnGuardar.addTarget(self, action: #selector(buttonGuardarTapped(_:)), for: .touchUpInside)
            cell.btnCompartir.addTarget(self, action: #selector(buttonCompartirTapped(_:)), for: .touchUpInside)

            
            
            return cell
        }
                
        
        return UITableViewCell()
    }
    
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder() // Cierra el teclado al tocar el botón "Return" (Enter)
          return true
      }
    
    
     func textFieldDidEndEditing(_ textField: UITextField) {
         let newText = textField.text ?? ""
         let index = textField.tag
         
         // Actualiza tu modelo de datos con el nuevo texto
         items[index].texto = newText
     }
    
    
        
    // VERIFICAR COMPARTIR
    func verificarCompartir(){
        view.endEditing(true)
       
        var allFieldsFilled = true
        
        var textoCompartir = ""
                   
        var index = 0
        // recorrer modelo para ver datos
        for item in items {
            if(item.tipo == 3){
                           
                if(item.texto.isEmpty){
                    // TODAS LAS PREGUNTAS SON REQUERIDAS
                    allFieldsFilled = false
                    items[index].activarTextoRequerido = true
                }else{
                  // esta vacio, pero no es requerido
                  items[index].activarTextoRequerido = false
                }
                               
                var textoPregunta = ""
                var textoEdt = ""
                
                if let textoExtraido = extraerTextoHTML(htmlString: items[index].titulo) {
                    textoPregunta = textoExtraido
                }
               
                textoEdt = items[index].texto
                                        
                let linea = textoPregunta + "R// " + textoEdt + "\n" + "\n"
                textoCompartir += linea
            }
            
            index += 1
        }
        
       if allFieldsFilled {
          // TODOS LOS EDT TIENEN TEXTO, VERIFICANDO SI SON REQUERIDOS O NO
           
           apiGanarInsigniaDevoCompartir()
         
           compartir(texto: textoCompartir, desde: self)
       } else {
           // HAY ALGUN EDIT QUE NO TIENE TEXTO Y ES REQUERIDO
          
           let textoC = TextoIdiomaController.localizedString(forKey: "completar_campos")
           mensajeToastAzul(mensaje: textoC)
           
           tableview.reloadData()
       }
    }

    
    
    func guardarDatos(){
        view.endEditing(true)
       
        var allFieldsFilled = true
               
        var index = 0
        // recorrer modelo para ver datos
        for item in items {
            if(item.tipo == 3){
                                     
                if(item.texto.isEmpty){
                    // TODAS LAS PREGUNTAS SON REQUERIDAS
                   allFieldsFilled = false
                   items[index].activarTextoRequerido = true
                 
                }else{
                  // esta vacio, pero no es requerido
                  items[index].activarTextoRequerido = false
                }
            }
            
            index += 1
        }
        
       if allFieldsFilled {
          // TODOS LOS EDT TIENEN TEXTO, VERIFICANDO SI SON REQUERIDOS O NO
         
           apiGuardarDatos()
       } else {
           // HAY ALGUN EDIT QUE NO TIENE TEXTO Y ES REQUERIDO
          
           let textoC = TextoIdiomaController.localizedString(forKey: "completar_campos")
           mensajeToastAzul(mensaje: textoC)
           
           tableview.reloadData()
       }
    }
    
    
    func obtenerIdsDeModelosConEstadoTrue() -> [String: String]? {
        var idsConEstadoTrue: [String: String] = [:]

            // Recorre todo el modelo
            for model in items {
                // Verifica si el estado del modelo es true
                if model.tipo == 3 {
                    // Convierte el id del modelo a String
                    let idSolicitud = String(model.id)
                    
                    // Agrega el id del modelo y su estado al diccionario
                    idsConEstadoTrue[idSolicitud] = model.texto
                }
            }
        
        return idsConEstadoTrue
    }
    
    
    
    func apiGuardarDatos(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiActualizarPreguntas
        
        let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
        let idiomaPlan = UserDefaults.standard.getValueIdiomaApp()
                
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
         
        
        var datosClaveValor: [[String: Any]] = []

        for modelo in items {
            // Obtener el ID y el estado del modelo
            
            if(modelo.tipo == 3){
                let id = modelo.id // ID SOLICITUD
                let iduserFila = modelo.texto // IDUSUARIO
                 
                datosClaveValor.append(["id": id, "estado": iduserFila])
            }
        }
        
        
        // Definir otros parámetros adicionales
        let otrosParametros: [String: Any] = [
            "iduser": iduser ?? 0,
            "idblockdeta": idblockdeta,
            "idiomaplan": idiomaPlan ?? 1
        ]
        
                
        // Agregar el array de datos clave-valor a los parámetros
        var parametroFinal = otrosParametros
        parametroFinal["datos"] = datosClaveValor
        
               
            Observable<Void>.create { observer in
                let request = AF.request(encodeURL, method: .post, parameters: parametroFinal,  encoding: JSONEncoding.default, headers: headers)
  
                    .responseData { response in
                        switch response.result {
                        case .success(let data):
                                                                    
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let json = JSON(data)
                            
                            if let successValue = json["success"].int {
                                
                                if(successValue == 1){
                                    
                                    self.actualizado()
                                       
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
    
    
    func actualizado(){
        let msj = TextoIdiomaController.localizedString(forKey: "actualizado")
        mensajeToastAzul(mensaje: msj)
    }
    
    
    var puedeEnviarPeticionCompartir = true
    
    
    func apiGanarInsigniaDevoCompartir(){
        
        if(puedeEnviarPeticionCompartir){
            puedeEnviarPeticionCompartir = false
            
            let encodeURL = apiCompartirDevoBloquePreguntas
            
            let iduser = UserDefaults.standard.getValueIdUsuario()
            let token = UserDefaults.standard.getValueTokenUsuario()
            let idioma = UserDefaults.standard.getValueIdiomaApp()
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token ?? "")"
              ]
            
            let parameters: [String: Any] = [
                "iduser": iduser ?? 0,
                "idiomaplan": idioma ?? 1
            ]
            
            Observable<Void>.create { observer in
                let request = AF.request(encodeURL, method: .post, parameters: parameters, headers: headers)
                    .responseData { response in
                        switch response.result {
                        case .success(let data):
                  
                            self.puedeEnviarPeticionCompartir = true
                            
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
              
            })
            .disposed(by: disposeBag)
        }
    }
 
    
    // EXTRAER TEXTO HTML DEL MODELO DE DATOS
    func extraerTextoHTML(htmlString: String) -> String? {
        // Convierte el texto HTML en un NSAttributedString
        if let attributedString = try? NSAttributedString(data: htmlString.data(using: .utf16)!,
                                                           options: [.documentType: NSAttributedString.DocumentType.html],
                                                           documentAttributes: nil) {
            // Extrae el texto del NSAttributedString
            let texto = attributedString.string
            return texto
        }
        return nil
    }
    
    
    
    // MODAL PARA COMPARTIR
    func compartir(texto: String, desde viewController: UIViewController) {
        // Crea un objeto UIActivityViewController con el texto a compartir
        let activityViewController = UIActivityViewController(activityItems: [texto], applicationActivities: nil)
        
        // Configura el estilo del popover en dispositivos iPad
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        // Muestra el controlador de actividad
        viewController.present(activityViewController, animated: true, completion: nil)
    }
    
}
