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

    @IBOutlet weak var coverImage: UIImageView!

    @IBOutlet weak var eventName: UILabel!
    
    
    // Set Outlets
    var eventImage: String? {
        didSet{
            coverImage.image = UIImage(named: eventImage!)
        }
    }
    
    var eventTitle: String? {
        didSet{
            eventName.text = eventTitle!
        }
    }
    
}
