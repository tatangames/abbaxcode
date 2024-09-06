//
//  InicioCell1.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 24/3/24.
//


import UIKit

class InicioCell1: UITableViewCell {

    
    @IBOutlet weak var txtEtiqueta: UILabel!
    @IBOutlet weak var txtDevo: UILabel!
    
    @IBOutlet weak var imgCompartir: UIImageView!
    @IBOutlet weak var imgOpciones: UIImageView!
    
    
    weak var delegate: YourTableViewCellDelegate3?
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgCompartir.isUserInteractionEnabled = true
        imgOpciones.isUserInteractionEnabled = true
        
        // Agregar gesto de toque para imgCheck
        let compartirTapGesture = UITapGestureRecognizer(target: self, action: #selector(imgCompartirTapped))
        imgCompartir.addGestureRecognizer(compartirTapGesture)
        
        
        // Agregar gesto de toque para imgShare
        let opcTapGesture = UITapGestureRecognizer(target: self, action: #selector(imgOpcionesTapped))
        imgOpciones.addGestureRecognizer(opcTapGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @objc func imgCompartirTapped() {
        // Aquí puedes realizar acciones cuando se toca imgCheck
       
            delegate?.compartirButtonTapped()
        
    }

    @objc func imgOpcionesTapped() {
        // Aquí puedes realizar acciones cuando se toca imgShare

            delegate?.opcionesButtonTapped()
        
    }

}
