//
//  EventCollectionViewCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 25/07/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    
    // Creates outlets and an action for the bookmark icon
    @IBOutlet weak var eventCover: UIImageView!
    @IBOutlet weak var priceTag: UILabel!
    @IBOutlet weak var eventName: UILabel!
    
    
    @IBAction func bookmarkEvent(_ sender: UIButton) {
        print("Bookmark Pressed")
    }
    
    var imageName: String? {
        didSet{
            eventCover.image = UIImage(named: imageName!)
        }
    }
    
    var eventFee: String? {
        didSet{
            priceTag.text = eventFee
        }
    }
    
    var nameEvent: String? {
        didSet{
            eventName.text = nameEvent
        }
    }
    
    
    
    
    
}
