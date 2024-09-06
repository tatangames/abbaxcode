//
//  LibrosBibliaController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 15/3/24.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import RxSwift
import Toast_Swift


class LibrosBibliaController: UIViewController, UISearchBarDelegate {
    
    var idbiblia = 0    
   
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    

    
    var tema = false
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    
    
    var datosLibros: [ModeloLibro] = []
    var datosLibrosSearch: [ModeloLibro] = []
    
    var textoReferencia = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let instanciaTema = TemaController()
        if( instanciaTema.conocerTemaActual() == 1){
            tema = true
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
  
        searchBar.delegate = self
        
        textoReferencia = TextoIdiomaController.localizedString(forKey: "referencias")
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        searchBar.isUserInteractionEnabled = false

        tableView.delegate = self
        tableView.dataSource = self
        

        apiSolicitarDatos()
    }
    
    
    // cerrar teclado
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func apiSolicitarDatos(){
        
        let datoRef = ModeloLibro(tipo: 1, estado: false, titulo: textoReferencia, detalle: [])
        self.datosLibros.append(datoRef)
        
               
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiListadoBibliaCapitulos
        
        let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
        let idiomaDevo = UserDefaults.standard.getValueIdiomaApp()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "iduser": iduser ?? 0,
            "idiomaplan": idiomaDevo ?? 1,
            "idbiblia": idbiblia
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
                                                                 
                                json["listado"].array?.forEach({ (dataArray) in
                                                       
                                    let titulo = dataArray["titulo"].string ?? ""
                                    
                                    var myList: [ModeloLibroSub] = []
                                                                        
                                                  
                                    dataArray["detalle"].array?.forEach({ (dataArrayJJ) in
                                                           
                                        let id = dataArrayJJ["id"].int ?? 0
                                        let nombre = dataArrayJJ["titulo"].string ?? ""
                                        
                                        print(nombre)
                                                                
                                        myList.append(ModeloLibroSub(id: id, nombre: nombre))
                                    })
                                    
                                    let datoFinal = ModeloLibro(tipo: 2, estado: false, titulo: titulo, detalle: myList)
                                    self.datosLibros.append(datoFinal)
                                    
                                })
                                    
                                self.searchBar.isUserInteractionEnabled = true
                                self.datosLibrosSearch = self.datosLibros
                                                            
                                self.tableView.reloadData()
                              
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
  
   
}



extension LibrosBibliaController: UITableViewDataSource, UITableViewDelegate {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
           return datosLibros.count
       }

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          
         
 
           if datosLibros[section].getEstado() == true {
               return datosLibros[section].getDetalle().count + 1
                 }else{
                     return 1
                 }
                    
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
           let tipo = datosLibros[indexPath.section].getTipo()
           
           if(tipo == 1){
               let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! LibroBibliaCell3
               cell.txtTituloPrincipal.text = datosLibros[indexPath.section].getTitulo()
               
               cell.selectionStyle = .none
               
               return cell
           }else {
               
               let dataIndex = indexPath.row - 1
               if indexPath.row == 0 {
                   let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! LibroBibliaCell1
                   cell.txtTitulo.text = datosLibros[indexPath.section].getTitulo()
                   
                   cell.selectionStyle = .none
                   
                   if (datosLibros[indexPath.section].getEstado()){
                       cell.imgFlecha.image = UIImage(named: "flecha_arriba")?.withRenderingMode(.alwaysTemplate)
                   }else{
                       cell.imgFlecha.image = UIImage(named: "flecha_abajo")?.withRenderingMode(.alwaysTemplate)
                   }
                                     
                   if(tema){
                       cell.imgFlecha.tintColor = UIColor.white
                   }else{
                       cell.imgFlecha.tintColor = UIColor.black
                   }
                                 
                  return cell
                   
               }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! LibroBibliaCell2
                    cell.txtNumero.text = datosLibros[indexPath.section].detalle[dataIndex].getNombre()
                   
                    cell.selectionStyle = .none
                   
                    return cell
               }
           }
           
       }
   
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text: String = self.searchBar.text ?? ""
        
        self.datosLibros = []
       
        for item in self.datosLibrosSearch {
            if (item.getTitulo().lowercased().contains(text.lowercased())){
                self.datosLibros.append(item)
            }
        }
        
        if(text.isEmpty){
            self.datosLibros = self.datosLibrosSearch
        }
        
        self.tableView.reloadData()
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if datosLibros[indexPath.section].getEstado() == true {
                datosLibros[indexPath.section].estado = false
                  let sections = IndexSet.init(integer: indexPath.section)
                  tableView.reloadSections(sections, with: .none)
              }else{
                  datosLibros[indexPath.section].estado = true
                  let sections = IndexSet.init(integer: indexPath.section)
                  tableView.reloadSections(sections, with: .none)
              }
       }else{
         
           let rowData = datosLibros[indexPath.section].detalle[indexPath.row - 1]
                      
           vistaTexto(id: rowData.getId())
       }
    }
        
    func vistaTexto(id: Int){
                
        let vista : LecturaBibliaController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "LecturaBibliaController") as! LecturaBibliaController
        
        vista.idcapitulo = id
        
        self.present(vista, animated: true, completion: nil)
    }
    
   
}


