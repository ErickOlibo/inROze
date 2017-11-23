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
    @IBOutlet weak var deejayName: UILabel!
    @IBOutlet weak var gigsMixesList: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    @IBAction func followTouched(_ sender: UIButton) {
        
    }
    
    
    
    private func configureCell() {
        guard let thisDJ = deejay else { return }
        guard let name = thisDJ.name else { return }
        
        deejayName.text = name
        if (thisDJ.isFollowed) {
            deejayName.textColor = .black
            followButton.tintColor = Colors.isFollowed
        } else {
            deejayName.textColor = Colors.isNotFollowed
            followButton.tintColor = Colors.isNotFollowed
        }
    }
    
    


}
