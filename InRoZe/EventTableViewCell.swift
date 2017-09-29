//
//  EventTableViewCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 22/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit


class EventTableViewCell: UITableViewCell
{

    
    var event: Event?

    let collectionDJCell = "Collection DJ Cell"
    
    // outlets to the UI components in the custom UITableViewCell
    @IBOutlet weak var locationCover: UIImageView!
    @IBOutlet weak var eventCover: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventTimeLocation: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }


}


extension EventTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionDJCell, for: indexPath) as! EventDJsCollectionViewCell
        
        //set up the collection Cell for Deejay
        cell.textDisplayBg.layer.masksToBounds = true
        cell.textDisplayBg.layer.borderWidth = 2
        cell.textDisplayBg.layer.cornerRadius = 10
        cell.outerCircle.layer.borderWidth = 6
        cell.outerCircle.layer.cornerRadius = cell.outerCircle.bounds.width / 2
        cell.innerCircle.layer.borderWidth = 2
        cell.innerCircle.layer.cornerRadius = cell.innerCircle.bounds.width / 2
        cell.textDisplayGigs.layer.borderWidth = 1
        cell.followDJBottonView.layer.borderWidth = 1
        
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








