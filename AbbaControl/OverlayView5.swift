//
//  OverlayView5.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 25/3/24.
//

import UIKit
import Photos

protocol OverlayViewDelegateBotonDescargar: AnyObject {
    func didTapBotonDescargar(urlfoto: String)
}

protocol OverlayViewDelegateBotonCompartir: AnyObject {
    func didTapBotonCompartir(urlfoto: String)
}



// MODAL PARA OPCIONES DE TEXTO HTML EN BIBLIA

class OverlayView5: UIViewController {
  
    weak var delegate5: OverlayViewDelegateBotonDescargar?
    weak var delegate6: OverlayViewDelegateBotonCompartir?
    
    
    @IBOutlet weak var botonDescargar: UIButton!
    @IBOutlet weak var botonCompartir: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgFoto: UIImageView!
    
    
    
    @IBAction func botonDescargar(_ sender: Any) {
        delegate5?.didTapBotonDescargar(urlfoto: urlFoto)
    }
    
    var urlFoto = ""
    
    
    @IBAction func botonCompartir(_ sender: Any) {
        delegate6?.didTapBotonCompartir(urlfoto: urlFoto)
    }
    
       
    
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    @IBOutlet weak var slideIdicator: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        slideIdicator.roundCorners(.allCorners, radius: 10)
        
        scrollView.delegate = self
        
        let union = baseUrlImagen+urlFoto
          
        imgFoto.sd_setImage(with: URL(string: "\(union)"), placeholderImage: UIImage(named: "fotodefecto"))
        
        
        botonCompartir.layer.cornerRadius = 18
        botonCompartir.clipsToBounds = true
        
        botonDescargar.layer.cornerRadius = 18
        botonDescargar.clipsToBounds = true
                
        botonCompartir.backgroundColor = .black
        botonDescargar.backgroundColor = .black
     
        
        let textoDescargar = TextoIdiomaController.localizedString(forKey: "descargar")
        let textoCompartir = TextoIdiomaController.localizedString(forKey: "compartir")
        
        
        
        let btnCompartirAtributo = NSAttributedString(string: textoCompartir, attributes: [
           NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), // tamaño letra
           NSAttributedString.Key.foregroundColor: UIColor.white,
        ])
        
        let btnCompartirAtributoPress = NSAttributedString(string: textoCompartir, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), // tamaño letra
            NSAttributedString.Key.foregroundColor: UIColor.gray,
        ])
        
        botonCompartir.setAttributedTitle(btnCompartirAtributo, for: .normal)
        botonCompartir.setAttributedTitle(btnCompartirAtributoPress, for: .highlighted)
        
        
        
        // ****** BOTON MAS
                
        
        let btnDescargarAtributo = NSAttributedString(string: textoDescargar, attributes: [
           NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), // tamaño letra
           NSAttributedString.Key.foregroundColor: UIColor.white,
        ])
        
        let btnDescargarAtributoPress = NSAttributedString(string: textoDescargar, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), // tamaño letra
            NSAttributedString.Key.foregroundColor: UIColor.gray,
        ])
        
        botonDescargar.setAttributedTitle(btnDescargarAtributo, for: .normal)
        botonDescargar.setAttributedTitle(btnDescargarAtributoPress, for: .highlighted)
    }
    

    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let draggedToDismiss = (translation.y > view.frame.size.height/3.0)
            let dragVelocity = sender.velocity(in: view)
            if (dragVelocity.y >= 1300) || draggedToDismiss {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
    
   
}

extension OverlayView5: UIScrollViewDelegate{
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgFoto
    }
    
}
