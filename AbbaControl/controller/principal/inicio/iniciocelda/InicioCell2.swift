//
//  InicioCell2.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 24/3/24.
//

import UIKit
import SDWebImage


protocol CollectionViewCellDelegateVideo: AnyObject {
    func didSelectItemAtIndex(index: Int)
}


class InicioCell2: UITableViewCell {
    
    @IBOutlet weak var imgFlechaDer: UIImageView!
    
    
    @IBOutlet weak var vista: UIView!
    @IBOutlet weak var txtVideo: UILabel!
    @IBOutlet weak var miCollection: UICollectionView!
    weak var delegate: cellDelegateVideo?
    
   
    var propios: [ModeloInicioVideos] = []

    
    weak var delegate2: cellDelegateVideoClick?
    
    
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
             
        delegate?.flechaDerVideoTapped(iden: 1)
        
    }
}


extension InicioCell2: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       // return itemsGrupal[collectionView.tag].arrayVideos.count
        
        return propios.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        let cell = miCollection.dequeueReusableCell(withReuseIdentifier: "cell2c", for: indexPath) as! InicioCell2Collec
        
        let selectedItem = propios[indexPath.row]
        
        let union = baseUrlImagen+selectedItem.imagen
        
        
        
        let instanciaTema = TemaController()
        if( instanciaTema.conocerTemaActual() == 1){
            cell.vistaCollec.backgroundColor = UIColor.white
          
        }else{
            cell.vistaCollec.backgroundColor = UIColor.systemGray6
        }
        
  
        cell.imgImagen.sd_setImage(with: URL(string: "\(union)"), placeholderImage: UIImage(named: "fotodefecto"))
                
        
        // Configura las esquinas redondeadas
        cell.imgImagen.layer.cornerRadius = 10 // Elige el radio deseado

        // Asegúrate de que las esquinas redondeadas se apliquen correctamente
        cell.imgImagen.layer.masksToBounds = true
        
        cell.txtNombre.text = selectedItem.titulo
        cell.txtNombre.numberOfLines = 0
        cell.txtNombre.textColor = .black
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          
        let selected = propios[indexPath.row]
        
        delegate2?.videoClickTapped(url: selected.urlvideo)
    }
    
    
    
    
    
    
}


extension InicioCell2: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 2
    }
}
