//
//  PreguntasAmigosTableViewCell.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 17/5/24.
//

import UIKit

class PreguntasAmigosTableViewCell: UITableViewCell {

    
    @IBOutlet weak var txtPregunta: UILabel!
    @IBOutlet weak var txtRespuesta: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }

}
