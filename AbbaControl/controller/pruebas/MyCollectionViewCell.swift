//
//  MyCollectionViewCell.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 16/3/24.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var txtNumero: UILabel!
    
    
    func configure(with item: String) {
           // Configurar la celda con los datos del ítem
           // Por ejemplo, si la celda tiene una etiqueta llamada 'titleLabel':
        txtNumero.text = item
           // Configurar otras propiedades de la celda según los datos del ítem
        
        
       }
}
