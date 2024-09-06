//
//  MyTableViewCell.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 16/3/24.
//

import UIKit

class MyTableView: UITableViewCell {


    @IBOutlet weak var myCollectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension MyTableView: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vehicleList[myCollectionView.tag].productName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "collectioncell", for: indexPath) as! MyCollectionViewCell
        
        cell.txtNumero.text = vehicleList[myCollectionView.tag].productName[indexPath.row]
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.yellow.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(vehicleList[collectionView.tag].productName[indexPath.row])
    }
    
    
    
    
}

extension MyTableView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calcula y devuelve el tamaño deseado para la celda en el índice indexPath
        return CGSize(width: 170, height: 170)
    }
}
