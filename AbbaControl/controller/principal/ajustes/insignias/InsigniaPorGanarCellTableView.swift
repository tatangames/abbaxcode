//
//  InsigniaPorGanarCellTableView.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 14/3/24.
//

import UIKit

class InsigniaPorGanarCellTableView: UITableViewCell {

    
    @IBOutlet weak var imgInsignia: UIImageView!
    @IBOutlet weak var txtNombre: UILabel!
    @IBOutlet weak var txtDescripcion: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
