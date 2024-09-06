//
//  LibroVersiculoInController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 27/3/24.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import RxSwift
import Toast_Swift

class LibroVersiculoInController: UIViewController, UICollectionViewDelegateFlowLayout{

    var idcapibloque = 0
    var tema = false
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolbar: UINavigationItem!
    
    
    var datosVersiculos: [ModeloVersiculo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let instanciaTema = TemaController()
        if( instanciaTema.conocerTemaActual() == 1){
            tema = true
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
        
        toolbar.title = TextoIdiomaController.localizedString(forKey: "versiculos")
  
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
                
        apiSolicitarDatos()
    }
    
    
    
    func apiSolicitarDatos(){
              
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiListadoVersiculosInvitado
        
        let idiomaDevo = UserDefaults.standard.getValueIdiomaApp()
  
        
        let parameters: [String: Any] = [
            "idiomaplan": idiomaDevo ?? 1,
            "idcapibloque": idcapibloque
        ]
        
        Observable<Void>.create { observer in
            let request = AF.request(encodeURL, method: .post, parameters: parameters, headers: nil)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        let json = JSON(data)
                   
                        if let successValue = json["success"].int {
                            
                            if(successValue == 1){
                                                                 
                                json["listado"].array?.forEach({ (dataArray) in
                                           
                                    let id = dataArray["id"].int ?? 0
                                    let titulo = dataArray["titulo"].string ?? ""
                                    
                                    let datoFinal = ModeloVersiculo(id: id, titulo: titulo)
                                    self.datosVersiculos.append(datoFinal)
                                })
                                                                                                
                                self.collectionView.reloadData()
                              
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
    
    func vistaHtml(id: Int){
        
        let vista : LecturaBibliaInController = UIStoryboard(name: "Main3", bundle: nil).instantiateViewController(withIdentifier: "LecturaBibliaInController") as! LecturaBibliaInController
        
        vista.idversiculo = id
        
        self.present(vista, animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}

extension LibroVersiculoInController: UICollectionViewDelegate, UICollectionViewDataSource {
  
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datosVersiculos.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! LibroVersiculoInCell1
        cell.txtNumero.text = datosVersiculos[indexPath.row].getTitulo()
        
        cell.vista.layer.cornerRadius = 20
        cell.vista.clipsToBounds = true
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let rowData = datosVersiculos[indexPath.row].getId()
        vistaHtml(id: rowData)
    }
}

