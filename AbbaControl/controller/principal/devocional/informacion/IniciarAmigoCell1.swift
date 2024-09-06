//
//  IniciarAmigoCell1.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 20/3/24.
//

import UIKit

class IniciarAmigoCell1: UITableViewCell {

    
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var imgBandera: UIImageView!    
    @IBOutlet weak var txtPais: UILabel!
    
    @IBOutlet weak var txtNombre: UILabel!
    
    @IBOutlet weak var txtCorreo: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
