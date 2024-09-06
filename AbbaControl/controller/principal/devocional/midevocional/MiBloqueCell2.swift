//
//  MiBloqueCell2.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 20/3/24.
//

import UIKit

class MiBloqueCell2: UITableViewCell {

    @IBOutlet weak var txtNombre: UILabel!
    
    @IBOutlet weak var imgCheck: UIImageView!
    
    @IBOutlet weak var imgShare: UIImageView!
    
    
    weak var delegate: YourTableViewCellDelegate?
       var model: ModeloBloqueFechaSub? 
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
          imgCheck.isUserInteractionEnabled = true
          imgShare.isUserInteractionEnabled = true
          
          // Agregar gesto de toque para imgCheck
          let checkTapGesture = UITapGestureRecognizer(target: self, action: #selector(imgCheckTapped))
          imgCheck.addGestureRecognizer(checkTapGesture)
          
          // Agregar gesto de toque para imgShare
          let shareTapGesture = UITapGestureRecognizer(target: self, action: #selector(imgShareTapped))
          imgShare.addGestureRecognizer(shareTapGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    @objc func imgCheckTapped() {
        // Aquí puedes realizar acciones cuando se toca imgCheck
        if let model = model {
            delegate?.checkButtonTapped(model: model)
        }
    }

    @objc func imgShareTapped() {
        // Aquí puedes realizar acciones cuando se toca imgShare
        if let model = model {
            delegate?.shareButtonTapped(model: model)
        }
    }
 

}
