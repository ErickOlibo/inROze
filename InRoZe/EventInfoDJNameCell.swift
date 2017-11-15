//
//  EventInfoDJNameCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 15/11/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData

class EventInfoDJNameCell: UICollectionViewCell
{

    // Core Data model container and context
    //var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    
    static var identifier: String { return String(describing: self) }
    
    var thisDJ: Artist? { didSet { updateUI() } }

    // Cell Outlets
    @IBOutlet weak var djName: UILabel!
    @IBOutlet weak var backgroundProfileImage: UIImageView!
    
    
    private func updateUI() {
        //print("EventInfoDJNameCell inside UPDATE")
        guard let name = thisDJ?.name else { return }
        djName.text = name
        djName.textColor = .black
        container?.performBackgroundTask{ context in
            if let currentState = Artist.currentIsFollowedState(for: self.thisDJ!.id!, in: context) {
                self.thisDJ!.isFollowed = currentState
            }
        }
        backgroundProfileImage.image = UIImage(named: profileImageForDJ(with: thisDJ!.id!, when: thisDJ!.isFollowed))
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
