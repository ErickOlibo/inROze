//
//  DeejayGigsTableViewCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 27/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit

class DeejayGigsTableViewCell: UITableViewCell {
    
    
    
    // outlets
    @IBOutlet weak var eventCover: UIImageView! {
        didSet {
            eventCover.layer.masksToBounds = true
            eventCover.layer.borderWidth = 0.5
            eventCover.layer.borderColor = UIColor.black.cgColor
            eventCover.layer.cornerRadius = 5
        }
    }

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDateTimeLocation: UILabel!
    
    private func updateUI() {
        
    }


}
