//
//  DeejayGigsCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 27/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit

class DeejayGigsCell: UITableViewCell {

    static var identifier: String { return String(describing: self) }
    var event: Event? { didSet { configureCell() } }
    
    // outlets
    @IBOutlet weak var eventCover: UIImageView!

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDateTimeLocation: UILabel!
    
    private func configureCell() {
        guard let name = event?.name else { return }
        eventName.text = name
        guard let thisEvent = event else { return }
        eventDateTimeLocation.attributedText = dateTimeLocationFormatter(with: thisEvent)
        guard let thisURL = thisEvent.imageURL else { return }
        guard let eventURL = URL(string: thisURL) else { return }
        eventCover.kf.setImage(with: eventURL, options: [.backgroundDecode])
        
    }


}
