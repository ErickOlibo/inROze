//
//  EventCollectionViewCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 25/07/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    

    // The FacebookEvent struct
    var eventCell: FBEvent! {
        didSet {
            if eventCell.colors != nil {
                update()
            }
        }
    }
    
    // Creates outlets and an action for the bookmark icon
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

    private func update() {
        cellBackground.backgroundColor = eventCell.colors!.background
        coverImage.image = UIImage(named: eventCell.cover)
        eventName.attributedText = coloredString(eventCell.name, color: (eventCell.colors!.primary))
        let theDay = "\(eventCell.date.day.uppercased())\n" + "\(eventCell.date.num)\n" + "\(eventCell.date.month.uppercased())"
        if eventCell.colors!.primary.isDarkColor {
            date.attributedText = coloredString(theDay, color: .white)
        } else {
            date.attributedText = coloredString(theDay, color: .black)
        }
        
        footer.backgroundColor = eventCell.colors!.primary
        eventLocation.attributedText = coloredString(eventCell.location, color: eventCell.colors!.detail)
        dateDisplay.backgroundColor = eventCell.colors!.primary
        
        // 4 little Squares
        background.backgroundColor = eventCell.colors!.detail
        primary.backgroundColor = eventCell.colors!.primary
        secondary.backgroundColor = eventCell.colors!.secondary
        detail.backgroundColor = eventCell.colors!.detail
        
        
    }

    
}
