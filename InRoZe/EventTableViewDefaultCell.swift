//
//  EventTableViewCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 22/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit


class EventTableViewDefaultCell: UITableViewCell
{
    
    
    var event: Event?
    
    //let collectionDJCell = "Collection DJ Cell"
    
    // outlets to the UI components in the custom UITableViewCell
    @IBOutlet weak var locationCover: UIImageView!
    @IBOutlet weak var eventCover: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventTimeLocation: UILabel!
    

    
}










