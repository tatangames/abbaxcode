//
//  MiDevocionalController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 20/3/24.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import RxSwift
import Toast_Swift
import SDWebImage

protocol YourTableViewCellDelegate: AnyObject {
    func checkButtonTapped(model: ModeloBloqueFechaSub)
    func shareButtonTapped(model: ModeloBloqueFechaSub)
}

class MiDevocionalController: UIViewController, UICollectionViewDelegateFlowLayout, YourTableViewCellDelegate {
    
    // PANTALLA VISTA DE BLOQUE FECHAS, AQUI APARECE LAS CAJAS
    
    
    var idplan = 0
    var tema = false
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var toolbar: UINavigationItem!
    @IBOutlet weak var imgDevo: UIImageView!
    @IBOutlet weak var collectionHorizontal: UICollectionView!
    @IBOutlet weak var tableViewVertical: UITableView!
    
    
    var datosBloques: [ModeloBloqueFecha] = []
    var itemsVertical: [ModeloBloqueFechaSub] = []
    
    var datoPortada = ""
    
    
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
        
        toolbar.title = TextoIdiomaController.localizedString(forKey: "informacion")
                
        collectionHorizontal.delegate = self
        collectionHorizontal.dataSource = self
        
        tableViewVertical.delegate = self
        tableViewVertical.dataSource = self
  
        apiBuscarDatos()
    }
    
    
    // API BUSCAR DATOS
    func apiBuscarDatos(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiInformacionPlanBloque
        
        let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
        let idiomaPlan = UserDefaults.standard.getValueIdiomaApp()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "iduser": iduser ?? 0,
            "idiomaplan": idiomaPlan ?? 1,
            "idplan": idplan
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
                                
                                // success, portada, listado
                                    // id, id_planes, fecha_inicio, textopersonalizado, detalle
                                        // id, redireccionar_web, url_link, titulo, completado
                                
                                
                                self.datoPortada = json["portada"].string ?? ""
                                var contador = 1
                             
                                                                
                                json["listado"].array?.forEach({ (dataArray) in
                                                       
                                    let id = dataArray["id"].int ?? 0
                                    let textoPerso = dataArray["textopersonalizado"].string ?? ""
                                                                        
                                    var myList: [ModeloBloqueFechaSub] = []
                                                                         
                                    dataArray["detalle"].array?.forEach({ (dataArrayJJ) in
                                                           
                                        let iddeta = dataArrayJJ["id"].int ?? 0
                                        let titulo = dataArrayJJ["titulo"].string ?? ""
                                        let completado = dataArrayJJ["completado"].int ?? 0
                                                                
                                        myList.append(ModeloBloqueFechaSub(id: iddeta, titulo: titulo, completado: completado))
                                    })
                                    
                                    
                                    
                                    let datoFinal = ModeloBloqueFecha(id: id, textoPersonalizado: textoPerso, detalle: myList)
                                    
                                    
                                    if(contador == 1){
                                        self.itemsVertical = myList
                                        contador += 1
                                    }
                                     
                                                                     
                                    self.datosBloques.append(datoFinal)
                                })
                                                              
                                    
                                self.setearDatos()
                                self.collectionHorizontal.reloadData()
                                
                             
                                
                                self.tableViewVertical.reloadData()
                                                                                                         
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
        .retry()
        .subscribe(onNext: {
            
        }, onError: { error in
         
            MBProgressHUD.hide(for: self.view, animated: true)
        })
        .disposed(by: disposeBag)
    }
    
    func setearDatos(){
        let union = baseUrlImagen+datoPortada
            imgDevo.sd_setImage(with: URL(string: "\(union)"), placeholderImage: UIImage(named: "fotodefecto"))
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
    
 
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
   
    
    
       func checkButtonTapped(model: ModeloBloqueFechaSub) {
           // MANEJAR EVENTO CUANDO SE TOCQUE EL IMG CHECK
           
           actualizarCheck(idmodelo: model.id, valor: model.completado)
       }
       
       func shareButtonTapped(model: ModeloBloqueFechaSub) {
           informacionCompartir(id: model.id)
       }
    
    
    func vistaBloqueDevoTabs(id: Int){
        
        let vista : DevoPreguntaTabController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "DevoPreguntaTabController") as! DevoPreguntaTabController
        
        vista.id = id
        
        self.present(vista, animated: true, completion: nil)
    }
    
    
    // PETICION AL SERVIDOR AL HACER CHECK
    func actualizarCheck(idmodelo: Int, valor: Int){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiActualizarCheckBloqueFecha
        
        let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
        let idiomaPlan = UserDefaults.standard.getValueIdiomaApp()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "iduser": iduser ?? 0,
            "idblockdeta": idmodelo,
            "valor": valor,
            "idplan": idplan,
            "idiomaplan": idiomaPlan ?? 1,
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
                                // NO HA RESPONDIDO PREGUNTAS Y HAY ACTIVADAS Y REQUERIDAS
                                
                                let msg = TextoIdiomaController.localizedString(forKey: "completar_devocional")
                                self.mensajeToastAzul(mensaje: msg)
                            }
                            else if(successValue == 2){
                                
                                // SE COLOCA A COMPLETADO, EL CHECK QUE MARCO, ASI AL RECARGAR TABLA VA A ESTAR BLOQUEADO
                               
                                if let index = self.itemsVertical.firstIndex(where: { $0.id == idmodelo }) {
                                    self.itemsVertical[index].completado = 1
                                 }
                                 
                                self.tableViewVertical.reloadData()
                              
                                self.actualizado()
                               
                                                               
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
        .retry()
        .subscribe(onNext: {
            
        }, onError: { error in
            MBProgressHUD.hide(for: self.view, animated: true)
        })
        .disposed(by: disposeBag)
    }
    
    
    func actualizado(){
        let msg = TextoIdiomaController.localizedString(forKey: "actualizado")
        mensajeToastAzul(mensaje: msg)
    }
            
    
    // PETICION API PARA PEDIR LOS TEXTOS DE LOS DEVOCIONALES, SI YA CONTESTO O NO HA CONTESTADO
    func informacionCompartir(id: Int){
                
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiInfoPreguntasTextoCompartir
        
        let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
        let idiomaPlan = UserDefaults.standard.getValueIdiomaApp()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "iduser": iduser ?? 0,
            "idblockdeta": id,
            "idiomaplan": idiomaPlan ?? 1,
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
                                // FALTA COMPLETAR DEVOCIONAL
                                                                
                                self.completarDevocional()
                            }
                            else if(successValue == 2){
                                                                           
                                var textoGlobal = json["formatoPregu"].string ?? ""
                                                                
                                /*json["listado"].array?.forEach({ (dataArray) in
                                                                                     
                                    let titulo = dataArray["titulo"].string ?? ""
                                    let texto = dataArray["texto"].string ?? ""
                                    
                                    var textoPregunta = ""
                                    
                                    if let textoExtraido = self.extraerTextoHTML2(htmlString: titulo) {
                                        textoPregunta = textoExtraido
                                    }
                                                                                               
                                    let linea = textoPregunta + "\n" + "R// " + texto + "\n" + "\n"
                                    textoCompartir += linea
                                })*/
                                     
                                self.compartirDevo(texto: textoGlobal, desde: self)
                                                               
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
            
            
        }, onError: { error in
            // Manejar el error de la solicitud
            MBProgressHUD.hide(for: self.view, animated: true)
        })
        .disposed(by: disposeBag)
    }
    
    
    
    func extraerTextoHTML2(htmlString: String) -> String? {
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
    
    
    
    func compartirDevo(texto: String, desde viewController: UIViewController) {
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
        return ""
    }
    
        
    func completarDevocional(){
        let msg = TextoIdiomaController.localizedString(forKey: "completar_devocional")
        
        mensajeToastAzul(mensaje: msg)
    }
   
}




// ESTO ES LO VERTICAL DEL ITEM
extension MiDevocionalController: UITableViewDelegate, UITableViewDataSource{
    
    // METODOS TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
       return itemsVertical.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                 
        let selectedItem = itemsVertical[indexPath.row]
        
        // TITULO DE PANTALLA
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! MiBloqueCell2
        
        cell.txtNombre.numberOfLines = 0
        cell.txtNombre.text = selectedItem.titulo
                   
        cell.selectionStyle = .none
 
        
        cell.imgCheck.isUserInteractionEnabled = true
        cell.imgShare.isUserInteractionEnabled = true
               
        cell.model = selectedItem
        cell.delegate = self
        
        cell.imgShare.image = UIImage(named: "ic_share")?.withRenderingMode(.alwaysTemplate)
          
        
        if(selectedItem.completado == 1){
            cell.imgCheck.image = UIImage(named: "check")?.withRenderingMode(.alwaysTemplate)
            cell.imgCheck.isHidden = true
        }else{
            cell.imgCheck.image = UIImage(named: "nocheck")?.withRenderingMode(.alwaysTemplate)
            cell.imgCheck.isHidden = false
        }
        
        if(tema){
            cell.imgCheck.tintColor = UIColor.white
            cell.imgShare.tintColor = UIColor.white
        }else{
            cell.imgCheck.tintColor = UIColor.black
            cell.imgShare.tintColor = UIColor.black
        }
                
        cell.imgShare.isHidden = false
                
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItem = itemsVertical[indexPath.row]
        vistaBloqueDevoTabs(id: selectedItem.id)
    }
    
}




extension MiDevocionalController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datosBloques.count
    }
    
  
    
    // ESTO CARGA LA CAJA
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                                
            let selectedItem = datosBloques[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! MiBloqueCell1
                          
            cell.texto.text = selectedItem.textoPersonalizado
            cell.texto2.isHidden = true
                  
            // colores de texto
            if(tema){
                cell.vistaFondo.backgroundColor = .white
                cell.texto.textColor = .black
                cell.texto2.textColor = .black
            }else{
                cell.vistaFondo.backgroundColor = .lightGray
                cell.texto.textColor = .white
                cell.texto2.textColor = .white
            }
               
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                 
            let selectedItem = datosBloques[indexPath.row]
        
            itemsVertical = selectedItem.detalle

            collectionHorizontal.reloadData()
            tableViewVertical.reloadData()
    }
    
    

    
    
}


