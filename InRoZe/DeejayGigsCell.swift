//
//  DeejayGigsCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 27/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit

class DeejayGigsCell: UITableViewCell {

    static var identifier: String {
        return String(describing: self)
    }
    
    // outlets
    @IBOutlet weak var eventCover: UIImageView!

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDateTimeLocation: UILabel!
    
    private func updateUI() {
        
    }


}
