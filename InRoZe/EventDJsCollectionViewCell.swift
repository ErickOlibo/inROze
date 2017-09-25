//
//  EventDJsCollectionViewCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 23/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit

class EventDJsCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var djBackground: UIView! {
        didSet {
            //print("DJ Background is Set")
        }
    }
    @IBOutlet weak var djName: UILabel! {
        didSet {
            //print("DJ Name is Set")
        }
    }
    
    @IBOutlet weak var otherGigs: UILabel!
    
    
}
