//
//  FollowsCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 17/11/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData


class FollowsCell: UITableViewCell
{

    // properties
    static var identifier: String { return String(describing: self) }
    var event: Event? { didSet { configureCell() } }
    var lastCell: Bool = false
    
    // for last Cell vertical separator
    let thick: CGFloat = 4.0
    let color = Colors.logoRed.cgColor
    let lengthFromTop: CGFloat = 25.0
    
    // context & container
    //var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    
    
    // OUtlets
    @IBOutlet weak var verticalSeparator: UIView!
    @IBOutlet weak var dashedSeparator: UIView!
    @IBOutlet weak var dateCircle: UIView!
    @IBOutlet weak var deejaysTitleBar: UIView!
    @IBOutlet weak var eventCover: UIImageView!
    
    
    private func configureCell() {
        cellSeparator(isLast: lastCell)

    }

    // Vertical separator constructor
    private func cellSeparator(isLast last: Bool) {
        if (last) {
            verticalSeparator.backgroundColor = .white
            verticalSeparator.addBorder(lengthFromStart:lengthFromTop, toSide: .Left, withColor: color, andThickness: thick)
        } else {
            verticalSeparator.backgroundColor = Colors.logoRed
        }
    }
    
}
