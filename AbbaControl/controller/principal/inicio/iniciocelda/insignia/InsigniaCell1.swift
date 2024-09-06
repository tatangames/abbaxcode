//
//  InsigniaCell1.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 26/3/24.
//

import UIKit

class InsigniaCell1: UITableViewCell {

    
    @IBOutlet weak var imgInsignia: UIImageView!
    @IBOutlet weak var txtNivel: UILabel!
    @IBOutlet weak var txtTitulo: UILabel!
    @IBOutlet weak var txtDescripcion: UILabel!
    @IBOutlet weak var txtHito: UILabel!
    @IBOutlet weak var txtContador: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
   
}
