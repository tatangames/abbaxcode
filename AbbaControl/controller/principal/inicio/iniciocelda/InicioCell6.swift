//
//  InicioCell6.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 26/3/24.
//

import UIKit
import SDWebImage

protocol CollectionViewCellDelegateImagenInsignia: AnyObject {
    func didSelectItemAtIndexImagenInsignia(index: Int)
}

class InicioCell6: UITableViewCell {
    
    
    @IBOutlet weak var vista: UIView!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var miCollection: UICollectionView!
        
    var propios: [ModeloInicioInsignias] = []
    
    
    weak var delegate6: cellDelegateImagenInsigniaClick?
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        miCollection.delegate = self
        miCollection.dataSource = self
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
  
    
}

extension InicioCell6: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       // return itemsGrupal[collectionView.tag].arrayVideos.count
        
        return propios.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        let cell = miCollection.dequeueReusableCell(withReuseIdentifier: "cell6c", for: indexPath) as! InicioCell6Collec
        
        let selectedItem = propios[indexPath.row]
        let union = baseUrlImagen+selectedItem.imagen
        cell.vista.backgroundColor = .white
       
        cell.imgFoto.sd_setImage(with: URL(string: "\(union)"), placeholderImage: UIImage(named: "fotodefecto"))
                
        let nn = TextoIdiomaController.localizedString(forKey: "nivel")
        
        cell.txtNivel.text = nn + ": " + String(selectedItem.nivelvoy)
        cell.txtNombre.text = selectedItem.titulo
        
        cell.txtNivel.textColor = .black
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
        
        delegate6?.imagenInsigniaClickTapped(idtipoin: selected.idtipoinsignia)
    }
    
    
}


extension InicioCell6: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 2
    }
}
