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
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var footer: UIView!
    
    @IBOutlet weak var dateDisplay: UIView! {
        didSet {
            dateDisplay.layer.cornerRadius = 10
            //dateDisplay.layer.masksToBounds = true
            dateDisplay.backgroundColor = Constants.InrozeColor.petal
        }
    }
    

    
}