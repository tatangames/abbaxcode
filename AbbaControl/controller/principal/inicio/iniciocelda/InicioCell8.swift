//
//  InicioCell8.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 4/8/24.
//

import UIKit
import SDWebImage

protocol CollectionViewCellDelegateImagenRecursos: AnyObject {
    func didSelectItemAtIndexImagenRecursos(index: Int)
}

class InicioCell8: UITableViewCell {
    
    
    @IBOutlet weak var vista: UIView!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var miCollection: UICollectionView!
        
    var propios: [ModeloRecursos] = []
    
    
    weak var delegate8: cellDelegateImagenRecursosClick?
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        miCollection.delegate = self
        miCollection.dataSource = self
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
      
    
}

extension InicioCell8: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return propios.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        let cell = miCollection.dequeueReusableCell(withReuseIdentifier: "cell8c", for: indexPath) as! InicioCell8Collect
        
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
        
        delegate8?.imagenRecursosClickTapped(link: selected.link)
    }
    
    
}


extension InicioCell8: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 2
    }
}
