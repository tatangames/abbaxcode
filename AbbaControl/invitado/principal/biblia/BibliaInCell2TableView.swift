//
//  BibliaInCell2TableView.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 26/3/24.
//

import UIKit

class BibliaInCell2TableView: UITableViewCell {
        
    
    @IBOutlet weak var txtNombre: UILabel!
    
    @IBOutlet weak var imgBiblia: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
