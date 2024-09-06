//
//  ComoVanTableViewCell.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 22/6/24.
//

import UIKit

class ComoVanTableViewCell: UITableViewCell {

    
    @IBOutlet weak var txtNombre: UILabel!
    @IBOutlet weak var txtCorreo: UILabel!
    @IBOutlet weak var txtDevoTotal: UILabel!
    @IBOutlet weak var txtDevoRealizado: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
