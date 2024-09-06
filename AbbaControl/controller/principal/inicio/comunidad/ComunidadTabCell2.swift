//
//  ComunidadTabCell2.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 23/3/24.
//

import UIKit

class ComunidadTabCell2: UITableViewCell {

    
    @IBOutlet weak var vista: UIView!
    @IBOutlet weak var txtNombre: UILabel!
    @IBOutlet weak var txtCorreo: UILabel!
    @IBOutlet weak var imgPais: UIImageView!
    @IBOutlet weak var txtPais: UILabel!
    
     
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
