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
    @IBOutlet weak var djName: UILabel!
    @IBOutlet weak var backgroundProfileImage: UIImageView!
    
    private func updateUI() {
        container?.performBackgroundTask{ context in
            //print("FETCHING isFollowed From CORE DATA || Current Thread: [\(Thread.current)]")
            if let currentState = Artist.currentIsFollowedState(for: self.thisDJ!.id!, in: context) {
                self.thisDJ!.isFollowed = currentState
            }
        }
        updateCellColorforFollowed()
    }
    
    private func updateCellColorforFollowed() {
        backgroundProfileImage.image = UIImage(named: profileImageForDJ(with: thisDJ!.id!, when: thisDJ!.isFollowed))
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //print("Artist Before Reuse Cell: [\(thisDJ!.name!)]")
    }
    
    
}
