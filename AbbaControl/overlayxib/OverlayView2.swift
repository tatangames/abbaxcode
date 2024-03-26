//
//  OverlayView2.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 23/3/24.
//

import UIKit

protocol OverlayViewDelegatePicker2: AnyObject {
    func didTapPicker2(id: Int)
}


class OverlayView2: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate  {
  
    weak var delegate3: OverlayViewDelegatePicker2?
  
    @IBOutlet weak var txtVersiones: UILabel!
    @IBOutlet weak var pickerVersiones: UIPickerView!
    
    
    // Array de elementos
      var modeloVersiones: [ModeloVersionesClick] = []
    
    
    
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    @IBOutlet weak var slideIdicator: UIView!
    
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        slideIdicator.roundCorners(.allCorners, radius: 10)
        
    
        pickerVersiones.dataSource = self
        pickerVersiones.delegate = self
        
        
        txtVersiones.text = TextoIdiomaController.localizedString(forKey: "versiones")
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
        return modeloVersiones.count
    }

    // MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return modeloVersiones[row].titulo
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedItem = modeloVersiones[row]
              
        cambiarLetra(id: selectedItem.id)
    }
  
    
    
    
    func cambiarLetra(id: Int){
        
        delegate3?.didTapPicker2(id: id)
    }
   
    
}
