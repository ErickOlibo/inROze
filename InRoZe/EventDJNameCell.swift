//
//  EventDJNameCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 03/10/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData

class EventDJNameCell: UICollectionViewCell
{
    // Core Data model container and context
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    static var identifier: String {
        return String(describing: self)
    }
    
    var thisDJ: Artist? { didSet { updateUI() } }
    
    // UI colors for isFollowed
    let followedColor: UIColor = UIColor.changeHexStringToColor(ColorInHexFor.logoRed)
    let notFollowedColor: UIColor = .black
    
    // Cell Outlets
    @IBOutlet weak var outerCircle: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var djName: UILabel!
    
    private func updateUI() {
        //print("DJNAME - This DJ: \(thisDJ!.name!)")
        if let context = container?.viewContext {
            context.perform {
                if let currentState = Artist.currentIsFollowedState(for: self.thisDJ!.id!, in: context) {
                    self.thisDJ!.isFollowed = currentState
                }
            }
        }
        updateCellColorforFollowed()
    }
    
    private func updateCellColorforFollowed() {
        profileImage.image = UIImage(named: profileImageForDJ(with: thisDJ!.id!, when: thisDJ!.isFollowed))
        if (thisDJ!.isFollowed) {
            outerCircle.layer.borderColor = followedColor.cgColor
            //profileImage.backgroundColor = profileImageBackgroundColor(for: thisDJ!.name!)
        } else {
            outerCircle.layer.borderColor = notFollowedColor.cgColor
            
            //profileImage.backgroundColor = .white
        }
        
    }
    
    
    
    
}
