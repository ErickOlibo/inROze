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
    var event: Event? { didSet { updateUI() } }
    
    // Properties for the CollectionCell
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    
    
    
    private func updateUI() {

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
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return event?.performers?.count ?? 0
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 150, height: 200)
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var arrayDJs = [String]()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionDJCell, for: indexPath) as! EventDJsCollectionViewCell
        cell.djBackground.backgroundColor = UIColor.randomColor(alpha: 1.0)
        //event?.performers.
        if let djsSet = event?.performers, djsSet.count > 0 {
            for deejay in djsSet {
                print("DeeJay: \(deejay)")
            }
            
        }
        
        
        return cell
    }
    
    
}








