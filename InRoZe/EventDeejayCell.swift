//
//  EventDeejayCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 02/10/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit


class EventDeejayCell: UITableViewCell
{
    static var identifier: String {
        return String(describing: self)
    }
    
    var event: Event?
    
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


extension EventDeejayCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
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
        
        // CHANGE THIS WITH A FETCH REQUEST
        var arrayDJsGigs = [String : Artist]()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventDeejayNameCell.identifier, for: indexPath) as! EventDeejayNameCell
        
        
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
        //-----------------------CHANGE
        
        return cell
    }
    
    // selected collection cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("row: \(indexPath.row)")
        
        
    }
    
    
    
}









