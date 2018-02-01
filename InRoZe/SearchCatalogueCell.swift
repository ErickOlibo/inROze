//
//  SearchCatalogueCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 06/01/2018.
//  Copyright © 2018 Erick Olibo. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class SearchCatalogueCell: UITableViewCell {

    // properties
    static var identifier: String { return String(describing: self) }
    var mixtape: Mixtape? { didSet { configureCell() } }
    
    // context & container
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    
    
    // Outlets
    @IBOutlet weak var deejayName: UILabel!
    @IBOutlet weak var mixtapeName: UILabel!
    @IBOutlet weak var tagsList: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var mixtapeCover: UIImageView! { didSet { updateCoverFrame() } }
    @IBOutlet weak var followButtonView: UIView!
    
    @IBAction func followTouched(_ sender: UIButton) {
        pressedFollowed()
    }
    
    
    
    
    
    // Methods
    @objc private func pressedFollowed() {
        //print("Followed Pressed")
        guard let mixtapeID = mixtape?.id else { return }
        if let context = container?.viewContext {
            context.perform {
                if let  mixState = Mixtape.currentIsFollowedState(for: mixtapeID, in: context) {
                    self.mixtape!.isFollowed = !mixState
                    self.updateFollowedButton()
                    self.changeState()
                }
            }
        }
    }
    
    
    private func updateFollowedButton() {
        guard let currentIsFollow = mixtape?.isFollowed else { return }
        if (currentIsFollow) {
            followButton.tintColor = Colors.isFollowed
            followButton.setImage((UIImage(named: "3_MixtapesFilled")?.withRenderingMode(.alwaysTemplate))!, for: .normal)
        } else {
            followButton.tintColor = Colors.isNotFollowed
            followButton.setImage((UIImage(named: "3_Mixtapes")?.withRenderingMode(.alwaysTemplate))!, for: .normal)
        }
    }
    
    private func changeState() {
        guard let mixtapeID = mixtape?.id else { return }
        container?.performBackgroundTask{ context in
            _ = Mixtape.changeIsFollowed(for: mixtapeID, in: context)
        }
    }
    
    
    
    private func configureCell() {
        followButton.isHidden = true
        guard let name = mixtape?.name else { return }
        guard let djName = mixtape?.deejay?.name else { return }
        mixtapeName.text = name
        deejayName.text = djName
        tagsList.text = tagsToString()
        updateFollowedButton()
        guard let url = mixtape?.cover320URL else { return }
        guard let mixCoverURL = URL(string: url) else { return }
        mixtapeCover.kf.setImage(with: mixCoverURL, options: [.backgroundDecode, .transition(.fade(0.2))], completionHandler: {
            (img, err, cache, url) in
            self.followButton.isHidden = false
        })
    }
    
    
    private func updateCoverFrame() {
        mixtapeCover.layer.masksToBounds = true
        mixtapeCover.layer.cornerRadius = 5.0
        mixtapeCover.layer.borderColor = UIColor.gray.cgColor
        mixtapeCover.layer.borderWidth = 0.5
    }
    
    
    private func tagsToString () -> String {
        var tags = ""
        let between = " #"
        guard let tag1 = mixtape?.tag1, tag1 != ""  else { return tags }
        tags += "#" + tag1
        
        guard let tag2 = mixtape?.tag2, tag2 != "" else { return tags }
        tags += between + tag2
        guard let tag3 = mixtape?.tag3, tag3 != ""  else { return tags }
        tags += between + tag3
        guard let tag4 = mixtape?.tag4, tag4 != ""  else { return tags }
        tags += between + tag4
        guard let tag5 = mixtape?.tag5, tag5 != ""  else { return tags }
        tags += between + tag5
        
        return tags
    }
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}











