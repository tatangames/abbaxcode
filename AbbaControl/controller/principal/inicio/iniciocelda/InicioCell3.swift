//
//  InicioCell3.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 25/3/24.
//

import UIKit
import SDWebImage


protocol CollectionViewCellDelegateImagen: AnyObject {
    func didSelectItemAtIndexImagen(index: Int)
}


class InicioCell3: UITableViewCell {
    
    @IBOutlet weak var imgFlechaDer: UIImageView!
    
    
    @IBOutlet weak var vista: UIView!
    @IBOutlet weak var txtVideo: UILabel!
    @IBOutlet weak var miCollection: UICollectionView!
    weak var delegate: cellDelegateVideo?
   
    var propios: [ModeloInicioImagenes] = []

    
    weak var delegate3: cellDelegateImagenClick?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        miCollection.delegate = self
        miCollection.dataSource = self
        
        imgFlechaDer.isUserInteractionEnabled = true
        
        // Agregar gesto de toque para imgCheck
        let flechaDerVideoTapGesture = UITapGestureRecognizer(target: self, action: #selector(flechaDerVideoTapped))
       
        imgFlechaDer.addGestureRecognizer(flechaDerVideoTapGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @objc func flechaDerVideoTapped() {
             
        delegate?.flechaDerVideoTapped(iden: 2)
        
    }
}


extension InicioCell3: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       // return itemsGrupal[collectionView.tag].arrayVideos.count
        
        return propios.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        let cell = miCollection.dequeueReusableCell(withReuseIdentifier: "cell3c", for: indexPath) as! InicioCell3Collec
        
        let selectedItem = propios[indexPath.row]
        
        let union = baseUrlImagen+selectedItem.imagen
        
        
     
        let instanciaTema = TemaController()
        if( instanciaTema.conocerTemaActual() == 1){
            cell.vista.backgroundColor = UIColor.white
          
        }else{
            cell.vista.backgroundColor = UIColor.systemGray6
        }
  
        cell.imgImagen.sd_setImage(with: URL(string: "\(union)"), placeholderImage: UIImage(named: "fotodefecto"))
                
        
        // Configura las esquinas redondeadas
        cell.imgImagen.layer.cornerRadius = 10 // Elige el radio deseado

        // Asegúrate de que las esquinas redondeadas se apliquen correctamente
        cell.imgImagen.layer.masksToBounds = true
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          
        let selected = propios[indexPath.row]
        
        delegate3?.imagenClickTapped(urlimagen: selected.imagen)
    }
    
    
}


extension InicioCell3: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 2
    }
}



