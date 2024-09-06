//
//  TiendaController.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 16/3/24.
//

import UIKit

let vehicleList = [
    VehicleData(sectionType: "Hero", productName: ["glamour", "hfdelu", "pasion", "splendo"]),
    VehicleData(sectionType: "Hero 2", productName: ["glamour2", "hfdelu2", "pasion2", "splendo2","glamour2", "hfdelu2", "pasion2", "splendo2"]),
]


class TiendaController: UIViewController {

    
  
    
 
    @IBOutlet weak var myTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    

   

}

extension TiendaController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTableView
        
        cell.myCollectionView.tag = indexPath.section
        cell.myCollectionView.reloadData()
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return vehicleList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return vehicleList[section].sectionType
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
}

