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

    let collectionDJCell = "Collection DJ Cell"
    // outlets to the UI components in the custom UITableViewCell
    @IBOutlet weak var locationCover: UIImageView! {
        didSet {
            locationCover.layer.masksToBounds = true
            locationCover.layer.borderWidth = 0.5
            locationCover.layer.borderColor = UIColor.black.cgColor
            locationCover.layer.cornerRadius = locationCover.bounds.width / 2
        }
    }
    @IBOutlet weak var eventCover: UIImageView! {
        didSet {
            eventCover.layer.masksToBounds = true
            eventCover.layer.borderWidth = 0.5
            eventCover.layer.borderColor = UIColor.black.cgColor
            eventCover.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventTimeLocation: UILabel!
    
    // public API of this TableViewCell subclass
    var event: Event? //{ didSet { updateUI() } }
    
    // Properties for the CollectionCell
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            //print("CollectionView was SET")
        }
    }
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
    
    
    
    
    private func updateUI() {
        if event!.performers!.count > 0 {
            for djs in event!.performers! {
                print("Place: [\(event!.location!.name!)] -> DJS print: \((djs as! Artist).name!)")
            }
        }
    }
    

    /*
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 */

}

extension EventTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        print("numberOfSections")
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        print("number of items in collection view: \(event?.performers?.count ?? 0)")
        return event?.performers?.count ?? 0
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 150, height: 200)
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        print("Collection Cell index: [\(indexPath.row)]")
        var arrayDJsGigs = [String : Artist]()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionDJCell, for: indexPath) as! EventDJsCollectionViewCell
        if let djsSet = event?.performers, djsSet.count > 0 {
            for deejay in djsSet {
                let thisDJ = deejay as! Artist
                arrayDJsGigs[thisDJ.name!] = thisDJ
   
                //print("DeeJay: \(thisDJ.name!) | TotalGigs count: \(thisDJ.gigs!.count) | isFollowed: \(thisDJ.isFollowed) | First letter: \((thisDJ.name!.uppercased()).characters.first!)")
            }
            
        }
        //let sortedDJs = arrayDJs.sorted()
        let sortedArr = arrayDJsGigs.sorted { $0.key < $1.key }
        
        cell.thisDJ = arrayDJsGigs[sortedArr[indexPath.row].key]
        //cell.otherGigs.text = "Total Gigs: \(sortedArr[indexPath.row].value)"
        
        return cell
    }
    

    
    
}








