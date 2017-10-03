//
//  EventDefaultCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 22/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit


class EventDefaultCell: UITableViewCell
{
    
    static var identifier: String {
        return String(describing: self)
    }
    var event: Event?

    // outlets to the UI components in the custom UITableViewCell
    @IBOutlet weak var locationCover: UIImageView!
    @IBOutlet weak var eventCover: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventTimeLocation: UILabel!

}










