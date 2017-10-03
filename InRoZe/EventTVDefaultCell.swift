//
//  EventTVDefaultCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 30/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit

class EventTVDefaultCell: UITableViewCell {
    
    // outlets to the UI components
    @IBOutlet weak var locationCover: CustomUIImageView!
    @IBOutlet weak var eventCover: CustomUIImageView!     
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventTimeLocation: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
