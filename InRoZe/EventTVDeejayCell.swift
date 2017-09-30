//
//  EventTVDeejayCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 30/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit

class EventTVDeejayCell: UITableViewCell {
    
    var event: Event?
    let collectionDeejayCell = "Collection Deejay Cell"
    
    // outlets to the UI components
    @IBOutlet weak var locationCover: CustomUIImageView!
    @IBOutlet weak var eventCover: CustomUIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventTimeLocation: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // function to datasource and delegate
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// Collectionview Data
extension EventTVDeejayCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return event?.performers?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var arrayDJsGigs = [String : Artist]()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionDeejayCell, for: indexPath) as! CollectionDeejayCell
        
        
        if let djsSet = event?.performers, djsSet.count > 0 {
            for deejay in djsSet {
                let thisDJ = deejay as! Artist
                arrayDJsGigs[thisDJ.name!] = thisDJ
            }
            
        }
        //let sortedDJs = arrayDJs.sorted()
        let sortedArr = arrayDJsGigs.sorted { $0.key < $1.key }
        let currentDJ = arrayDJsGigs[sortedArr[indexPath.row].key]
        cell.thisDJ = currentDJ
        
        // tag of cell for future reference
        cell.tag = indexPath.row
        return cell
    }
    
    // selected collection cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("row: \(indexPath.row)")
        
        
    }
    
    
    
}
