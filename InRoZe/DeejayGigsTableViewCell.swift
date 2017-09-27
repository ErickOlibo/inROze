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
    @IBOutlet weak var locationCover: UIImageView!
    @IBOutlet weak var eventName: UILabel! { didSet { updateUI() } }
    @IBOutlet weak var eventDateTimeLocation: UILabel!
    
    private func updateUI() {
        print("Inside DJ gigs Cell")
    }

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
