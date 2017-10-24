//
//  EventDefaultCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 22/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import Kingfisher
import CoreData


class EventDefaultCell: UITableViewCell
{
    
    static var identifier: String {
        return String(describing: self)
    }
    var event: Event? { didSet { configureCell() } }
    

    // outlets to the UI components in the custom UITableViewCell
    @IBOutlet weak var eventCover: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventTimeLocation: UILabel!
    @IBOutlet weak var coverHeight: NSLayoutConstraint!
    
    
    // configure the Cell
    
    private func configureCell() {
        guard let event = event else { return }
        guard let name = event.name else { return }
        coverHeight.constant = eventCoverHeight
        eventCover.layoutIfNeeded()
        selectionStyle = .none
        eventTimeLocation.attributedText = dateTimeLocationFormatter(with: event)
        eventTitle.text = "[\(self.tag)] - \(name)"
        //eventTitle.text = name
        
        guard let imageURL = event.imageURL else { return }
        eventCover.kf.setImage(with: URL(string: imageURL), options: [.backgroundDecode])
        
        
        
        
    }

}










