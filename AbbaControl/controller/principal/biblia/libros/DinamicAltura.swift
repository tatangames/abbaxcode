//
//  DinamicAltura.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 16/3/24.
//

import UIKit

class DinamicAltura: UICollectionView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if bounds.size != intrinsicContentSize{
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize{
        
        return collectionViewLayout.collectionViewContentSize
        
    }
    
}
