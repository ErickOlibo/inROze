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
    @IBOutlet weak var djProfileImage: UIImageView! { didSet { updateProfileImage() } }
    @IBOutlet weak var djProfileView: UIView! { didSet { updateProfileView() } }
    
    
    private func updateUI() {
        //print("EventInfoDJNameCell inside UPDATE")
        updateProfileImage()
        updateProfileView()
        guard let name = thisDJ?.name else { return }
        guard let djIsFollowed = thisDJ?.isFollowed else { return }
        djName.text = name
        djName.textColor = djIsFollowed ? .black: Colors.isNotFollowed
        
        container?.performBackgroundTask{ context in
            if let currentState = Artist.currentIsFollowedState(for: self.thisDJ!.id!, in: context) {
                self.thisDJ!.isFollowed = currentState
            }
        }
        guard let dj = thisDJ else { return }
        guard let picURL = preferedProfilePictureURL(for: dj) else { return }
        djProfileImage.kf.setImage(with: URL(string: picURL), options: [.backgroundDecode])
    }
    
    private func updateProfileImage () {
        djProfileImage.layer.masksToBounds = true
        djProfileImage.layer.cornerRadius = 25.0
        djProfileImage.layer.borderColor = UIColor.gray.cgColor
        djProfileImage.layer.borderWidth = 0.333
    }
    
    private func updateProfileView () {
        djProfileView.backgroundColor = .white
        djProfileView.layer.masksToBounds = true
        djProfileView.layer.cornerRadius = 30.0
        djProfileView.layer.borderColor = Colors.logoRed.cgColor
        djProfileView.layer.borderWidth = 2.0
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
