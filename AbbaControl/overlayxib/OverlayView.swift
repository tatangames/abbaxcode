//
//  OverlayView.swift
//  SlideOverTutorial
//
//

import UIKit

protocol OverlayViewDelegateBotonMenos: AnyObject {
    func didTapBotonMenos()
}

protocol OverlayViewDelegateBotonMas: AnyObject {
    func didTapBotonMas()
}

protocol OverlayViewDelegatePicker: AnyObject {
    func didTapPicker(id: Int)
}

// MODAL PARA OPCIONES DE TEXTO HTML EN BIBLIA

class OverlayView: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
  
    weak var delegate: OverlayViewDelegateBotonMenos?
    weak var delegate2: OverlayViewDelegateBotonMas?
    weak var delegate3: OverlayViewDelegatePicker?
    
   
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var botonMenos: UIButton!
    @IBOutlet weak var botonMas: UIButton!
    
    
    @IBAction func botonMenos(_ sender: Any) {
        delegate?.didTapBotonMenos()
    }
    
    
    
    @IBAction func botonMas(_ sender: Any) {
        delegate2?.didTapBotonMas()
    }
    
    // Array de elementos
      var modeloLetra: [ModeloPickerLetra] = [
          ModeloPickerLetra(id: 0, titulo: "Noto Sans Light"),
          ModeloPickerLetra(id: 1, titulo: "Noto Sans Medium"),
          ModeloPickerLetra(id: 2, titulo: "Time New Roman"),
          ModeloPickerLetra(id: 3, titulo: "Recolecta Medium"),
          ModeloPickerLetra(id: 4, titulo: "Recolecta Regular"),
      ]
    
    
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    @IBOutlet weak var slideIdicator: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        slideIdicator.roundCorners(.allCorners, radius: 10)
        
        botonMenos.layer.cornerRadius = 18
        botonMenos.clipsToBounds = true
        
        botonMas.layer.cornerRadius = 18
        botonMas.clipsToBounds = true
                
        botonMenos.backgroundColor = .black
        botonMas.backgroundColor = .black
        
        pickerView.dataSource = self
        pickerView.delegate = self
             
        let btnMenosAtributo = NSAttributedString(string: "A-", attributes: [
           NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
           NSAttributedString.Key.foregroundColor: UIColor.white,
        ])
        
        let btnMenosAtributoPress = NSAttributedString(string: "A-", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), // tamaño letra
            NSAttributedString.Key.foregroundColor: UIColor.gray,
        ])
        
        botonMenos.setAttributedTitle(btnMenosAtributo, for: .normal)
        botonMenos.setAttributedTitle(btnMenosAtributoPress, for: .highlighted)
        
        
        
        // ****** BOTON MAS
        
        
        
        let btnMasAtributo = NSAttributedString(string: "A+", attributes: [
           NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22), // tamaño letra
           NSAttributedString.Key.foregroundColor: UIColor.white,
        ])
        
        let btnMasAtributoPress = NSAttributedString(string: "A+", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22), // tamaño letra
            NSAttributedString.Key.foregroundColor: UIColor.gray,
        ])
        
        botonMas.setAttributedTitle(btnMasAtributo, for: .normal)
        botonMas.setAttributedTitle(btnMasAtributoPress, for: .highlighted)
        
        
        // SI TIENE POSICION CAMBIARA SINO SE COLOCARA EN POSICION 0 DEFECTO
        let posPicker = UserDefaults.standard.getValueTipoLetraTexto() ?? 0
            
        selectRowWithID(posPicker)
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
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return modeloLetra.count
    }

    // MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return modeloLetra[row].getTitulo()
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedItem = modeloLetra[row].getId()
      
        UserDefaults.standard.setValueTipoLetraTexto(value: selectedItem)
        
        cambiarLetra(id: selectedItem)
    }
        
    func selectRowWithID(_ id: Int) {
           if let index = modeloLetra.firstIndex(where: { $0.id == id }) {
               pickerView.selectRow(index, inComponent: 0, animated: true)
           }
     }
    
    
    
    func cambiarLetra(id: Int){
        
        delegate3?.didTapPicker(id: id)
    }
    
}
