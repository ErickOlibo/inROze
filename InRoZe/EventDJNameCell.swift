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
    @IBOutlet weak var backgroundProfileImage: UIImageView! { didSet { updateProfileImage() } }
    @IBOutlet weak var backgroundProfileView: UIView! { didSet { updateProfileView() } }
    
    
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
        print("URL: ", picURL)
        backgroundProfileImage.kf.setImage(with: URL(string: picURL), options: [.backgroundDecode])
        
        
    }
    
    private func updateProfileImage () {
        backgroundProfileImage.layer.masksToBounds = true
        backgroundProfileImage.layer.cornerRadius = 25.0
        backgroundProfileImage.layer.borderColor = UIColor.gray.cgColor
        backgroundProfileImage.layer.borderWidth = 0.333
        //backgroundProfileImage.image = nil
    }
    
    private func updateProfileView () {
        backgroundProfileView.backgroundColor = .white
        backgroundProfileView.layer.masksToBounds = true
        backgroundProfileView.layer.cornerRadius = 30.0
        backgroundProfileView.layer.borderColor = Colors.logoRed.cgColor
        backgroundProfileView.layer.borderWidth = 2.0
        
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //print("Artist Before Reuse Cell: [\(thisDJ!.name!)]")
    }
    
    
}
