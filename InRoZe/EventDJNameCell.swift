//
//  EventDJNameCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 03/10/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//  TO DELETE NOT NEEDED

import UIKit
import CoreData

class EventDJNameCell: UICollectionViewCell
{
    // Core Data model container and context
    //var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    
    static var identifier: String {
        return String(describing: self)
    }
    
    var thisDJ: Artist? { didSet { updateUI() } }
    
    // UI colors for isFollowed
    let followedColor: UIColor = Colors.logoRed
    let notFollowedColor: UIColor = .gray
    
    // Cell Outlets
    @IBOutlet weak var djName: UILabel!
    @IBOutlet weak var backgroundProfileImage: UIImageView!
    
    private func updateUI() {
        guard let name = thisDJ?.name else { return }
        djName.text = name
        djName.textColor = .black
        container?.performBackgroundTask{ context in
            //print("FETCHING isFollowed From CORE DATA || Current Thread: [\(Thread.current)]")
            if let currentState = Artist.currentIsFollowedState(for: self.thisDJ!.id!, in: context) {
                self.thisDJ!.isFollowed = currentState
            }
        }
        //updateCellColorforFollowed()
        backgroundProfileImage.image = UIImage(named: profileImageForDJ(with: thisDJ!.id!, when: thisDJ!.isFollowed))
    }
    
    private func updateCellColorforFollowed() {
        backgroundProfileImage.image = UIImage(named: profileImageForDJ(with: thisDJ!.id!, when: thisDJ!.isFollowed))
        //djName.textColor = (thisDJ!.isFollowed) ? followedColor : notFollowedColor
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //print("Artist Before Reuse Cell: [\(thisDJ!.name!)]")
    }
    
    
}
