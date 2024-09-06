//
//  InsigniasAmigosTableViewCell.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 17/5/24.
//

import UIKit

class InsigniasAmigosTableViewCell: UITableViewCell {

    
    @IBOutlet weak var txtNivel: UILabel!
    @IBOutlet weak var txtNombre: UILabel!    
    @IBOutlet weak var imgFoto: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
