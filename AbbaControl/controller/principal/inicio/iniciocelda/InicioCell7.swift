//
//  InicioCell7.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 28/7/24.
//

import UIKit
import SDWebImage

protocol CollectionViewCellDelegateImagenRedes: AnyObject {
    func didSelectItemAtIndexImagenRedes(index: Int)
}

class InicioCell7: UITableViewCell {
    
    
    @IBOutlet weak var vista: UIView!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var miCollection: UICollectionView!
        
    var propios: [ModeloInicioRedes] = []
    
    
    weak var delegate7: cellDelegateImagenRedesClick?
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        miCollection.delegate = self
        miCollection.dataSource = self
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
      
    
}

extension InicioCell7: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return propios.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        let cell = miCollection.dequeueReusableCell(withReuseIdentifier: "cell7c", for: indexPath) as! InicioCell7Collect
        
        let selectedItem = propios[indexPath.row]
        let union = baseUrlImagen+selectedItem.imagen
        cell.vista.backgroundColor = .white
       
        cell.imgFoto.sd_setImage(with: URL(string: "\(union)"), placeholderImage: UIImage(named: "fotodefecto"))
                        
        cell.txtNombre.text = selectedItem.nombre
        cell.txtNombre.textColor = .black
        
        let instanciaTema = TemaController()
        if( instanciaTema.conocerTemaActual() == 1){
            cell.vista.backgroundColor = UIColor.white
          
        }else{
            cell.vista.backgroundColor = UIColor.systemGray6
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          
        let selected = propios[indexPath.row]
        
        delegate7?.imagenRedesClickTapped(link: selected.link)
    }
    
    
}


extension InicioCell7: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 2
    }
}
