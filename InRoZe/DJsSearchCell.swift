//
//  DJsSearchCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 23/11/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DJsSearchCell: UITableViewCell
{
    
    // properties
    static var identifier: String { return String(describing: self) }
    var deejay: Artist? { didSet { configureCell() } }


    // context & container
    //var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    
    // OUTlets
    
    
    
    private func configureCell() {
        print("Row: \(tag)) - [\(deejay?.name ?? "N/A")]")
    }

}
