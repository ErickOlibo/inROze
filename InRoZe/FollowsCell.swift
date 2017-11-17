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
    
    // context & container
    //var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    
    
    // OUtlets
    @IBOutlet weak var verticalSeparator: UIView!
    @IBOutlet weak var dashedSeparator: UIView!
    @IBOutlet weak var dateCircle: UIView!
    @IBOutlet weak var deejaysTitleBar: UIView!
    
    
    private func configureCell() {
        
    }



}
