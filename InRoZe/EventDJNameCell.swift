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
    //var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    
    static var identifier: String { return String(describing: self) }
    
    var thisDJ: Artist? { didSet { updateUI() } }
    
    // Cell Outlets
    @IBOutlet weak var djName: UILabel!
    @IBOutlet weak var djProfileImage: UIImageView! { didSet { updateProfileImage() } }
    @IBOutlet weak var djProfileView: UIView! { didSet { updateProfileView() } }
    
    
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
        //backgroundProfileImage.image = UIImage(named: profileImageForDJ(with: thisDJ!.id!, when: thisDJ!.isFollowed))
        guard let dj = thisDJ else { return }
        //print("the DJ is not nil")
        guard let picURL = preferedProfilePictureURL(for: dj) else { return }
        //print("URL: ", picURL)
        djProfileImage.kf.setImage(with: URL(string: picURL), options: [.backgroundDecode])
        
        
    }
    
    private func updateProfileImage () {
        djProfileImage.layer.masksToBounds = true
        djProfileImage.layer.cornerRadius = 25.0
        djProfileImage.layer.borderColor = UIColor.gray.cgColor
        djProfileImage.layer.borderWidth = 0.333
        //djProfileImage.image = nil
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
        //print("Artist Before Reuse Cell: [\(thisDJ!.name!)]")
    }
    
    
}
