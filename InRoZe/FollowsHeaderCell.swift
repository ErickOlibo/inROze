//
//  FollowsHeaderCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 21/11/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit

class FollowsHeaderCell: UITableViewCell
{
    // properties
    static var identifier: String { return String(describing: self) }
    var sectionName: String?
    
    @IBOutlet weak var dayBackground: UIView! 
    @IBOutlet weak var dayWeekName: UILabel!
    
    func configureCell(withDate day: String) {
        dayBackground.backgroundColor = Colors.logoRed
        dayWeekName.textColor = .white
        
    }
}
