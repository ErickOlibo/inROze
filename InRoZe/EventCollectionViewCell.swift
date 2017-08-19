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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var placeHolderPicture: UIImageView!
    
    @IBOutlet weak var cellBackground: UIView!

    @IBOutlet weak var coverImage: UIImageView!

    @IBOutlet weak var eventName: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var footer: UIView!
    
    @IBOutlet weak var eventLocation: UILabel!
    
    @IBOutlet weak var dateDisplay: UIView! {
        didSet {
            dateDisplay.layer.cornerRadius = 10

        }
    }
    
    // OUTLETS to test he UIImageColor class
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var primary: UIView!
    @IBOutlet weak var secondary: UIView!
    @IBOutlet weak var detail: UIView!

    
    // cleaning the cell before reuse
    public func clear () {
        cellBackground.backgroundColor = .clear
        coverImage.image = nil
        eventName.text = nil
        date.text = nil
        footer.backgroundColor = .clear
        eventLocation.text = nil
        dateDisplay.backgroundColor = .clear
        background.backgroundColor = .clear
        primary.backgroundColor = .clear
        secondary.backgroundColor = .clear
        detail.backgroundColor = .clear
    }
    
    
        override func prepareForReuse() {
            super.prepareForReuse()
            clear()
        }
    

}
