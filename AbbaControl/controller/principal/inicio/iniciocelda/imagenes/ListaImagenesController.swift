//
//  ListaImagenesController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 26/3/24.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Alamofire
import RxSwift
import Toast_Swift
import SDWebImage
import Photos



class ListaImagenesController: UIViewController,OverlayViewDelegateBotonDescargar
,OverlayViewDelegateBotonCompartir {

    
    @IBOutlet weak var toolbar: UINavigationItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var tema = false
    var styleAzul = ToastStyle()
    let disposeBag = DisposeBag()
    
    
    var items: [ModeloImagenesLista] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let instanciaTema = TemaController()
        if( instanciaTema.conocerTemaActual() == 1){
            tema = true
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
        
        toolbar.title = TextoIdiomaController.localizedString(forKey: "imagenes")
        
        styleAzul.backgroundColor = UIColor(named: "ColorAzulToast")!
        styleAzul.titleColor = .white
       
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
                
        apiSolicitarDatos()
    }
    
    
    func apiSolicitarDatos(){
              
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let encodeURL = apiListadoImagenes
        
        let iduser = UserDefaults.standard.getValueIdUsuario()
        let token = UserDefaults.standard.getValueTokenUsuario()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")"
          ]
        
        let parameters: [String: Any] = [
            "iduser": iduser ?? 0
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
                                                                 
                                json["arrayfinalimagenes"].array?.forEach({ (dataArray) in
                                           
                                    let imagen = dataArray["imagen"].string ?? ""
                                                                       
                                    let datoFinal = ModeloImagenesLista(imagen: imagen)
                                    self.items.append(datoFinal)
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
    
       
    
    

    @IBAction func flechaAtras(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    func mensajeSinConexion(){
        let msg = TextoIdiomaController.localizedString(forKey: "sin_conexion_a_internet")
        mensajeToastAzul(mensaje: msg)
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    
    func mensajeToastAzul(mensaje: String){
        self.view.makeToast(mensaje, duration: 3.0, position: .bottom, style: styleAzul)
    }

    var overlayViewController: OverlayView5?
    
    func vistaModal(urlimg: String){
        
        
        overlayViewController = OverlayView5()
       
        overlayViewController?.modalPresentationStyle = .custom
        overlayViewController?.transitioningDelegate = self
        overlayViewController?.delegate5 = self
        overlayViewController?.delegate6 = self
        
        overlayViewController?.urlFoto = urlimg
        
        self.present(overlayViewController!, animated: true, completion: nil)
    }

    
    
    
    
    func didTapBotonDescargar(urlfoto: String) {
       
        // cuando es pulsado que el usuario quiere guardar una imagen
               
        DispatchQueue.main.async { [self] in
            
            overlayViewController?.dismiss(animated: true, completion: nil)
            
            let union = baseUrlImagen+urlfoto
            
            let imageURL = URL(string: union)!
           
            SDWebImageManager.shared.loadImage(with: imageURL, options: [], progress: nil) { (image, data, error, cacheType, finished, imageURL) in
                    guard let image = image else {
                        let texto = TextoIdiomaController.localizedString(forKey: "error_al_guardar")
                       
                        
                        DispatchQueue.main.async {
                                   // Asegúrate de ejecutar esta operación en el hilo principal
                                   self.view.makeToast(texto, duration: 3.0, position: .bottom, style: self.styleAzul)
                               }
                        return
                    }
                    
                    // Guardar la imagen en la galería
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAsset(from: image)
                    }) { success, error in
                        if success {
                           
                            let texto = TextoIdiomaController.localizedString(forKey: "guardado")
                            DispatchQueue.main.async {
                                       // Asegúrate de ejecutar esta operación en el hilo principal
                                       self.view.makeToast(texto, duration: 3.0, position: .bottom, style: self.styleAzul)
                                   }
                            
                        } else {
                          
                            let texto = TextoIdiomaController.localizedString(forKey: "error_al_guardar")
                            DispatchQueue.main.async {
                                       // Asegúrate de ejecutar esta operación en el hilo principal
                                       self.view.makeToast(texto, duration: 3.0, position: .bottom, style: self.styleAzul)
                                   }
                          
                        }
                    }
                }
        }
        
    }
    
    
    func didTapBotonCompartir(urlfoto: String) {
        DispatchQueue.main.async { [self] in
                        
            overlayViewController?.dismiss(animated: true, completion: nil)
            
            let union = baseUrlImagen+urlfoto
            
            let imageURL = URL(string: union)!
            
            shareImageFromURL(imageURL: imageURL)
        }
    }
    
    
    
    func shareImageFromURL(imageURL: URL) {
         // Descarga la imagen utilizando SDWebImage
         SDWebImageManager.shared.loadImage(with: imageURL, options: [], progress: nil) { (image, data, error, cacheType, finished, imageURL) in
             guard let image = image else {
               
                 return
             }
             
             // Comparte la imagen descargada
             self.shareImage(image: image)
         }
     }
    
    
    
    func shareImage(image: UIImage) {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        // Excluye algunas actividades si es necesario
        activityViewController.excludedActivityTypes = [.airDrop, .addToReadingList]
        // Presenta el controlador de vista de actividad
        present(activityViewController, animated: true, completion: nil)
    }
 

}


extension ListaImagenesController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3 // Dividir el ancho de la collectionView por el número de celdas que deseas en una fila
               let height = collectionView.frame.height // Puedes ajustar la altura según tus necesidades
               return CGSize(width: width, height: height)
    }
    
 
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! ImagenesCell1
    
        let union = baseUrlImagen+items[indexPath.row].imagen
          
        cell.imgFoto.sd_setImage(with: URL(string: "\(union)"), placeholderImage: UIImage(named: "fotodefecto"))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let rowData = items[indexPath.row].imagen
        
        vistaModal(urlimg: rowData)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension ListaImagenesController: UIViewControllerTransitioningDelegate {
      
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        CodigoModalBibliaHtml(presentedViewController: presented, presenting: presenting)
    }
   
    
}
