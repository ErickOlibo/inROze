//
//  DeejayMixesCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 18/12/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData

class DeejayMixesCell: UITableViewCell {
    
    static var identifier: String { return String(describing: self) }
    var mixtape: Mixtape? { didSet { configureCell() } }
    
    // context & container
    //var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    
    
    // outlets
    @IBOutlet weak var mixtapeCover: UIImageView!
    
    @IBOutlet weak var mixtapeName: UILabel!
    @IBOutlet weak var mixtapeTags: UILabel!
    @IBOutlet weak var createdDay: UILabel!
    @IBOutlet weak var mixLength: UILabel!
    
    @IBOutlet weak var mixIsFollowedView: UIView!
    @IBOutlet weak var mixIsFollowedButton: UIButton!
    @IBAction func mixIsFollowedTouched(_ sender: UIButton) {
        print("mixIsFollowedTouched")
        pressedFollowed()
    }
    
    
    @objc private func pressedFollowed() {
        guard let mixtapeID = mixtape?.id else { return }
        print("Cell [\(tag)] - preseed: [\(mixtape?.name ?? "No Name Mix")]")
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
            mixIsFollowedButton.tintColor = Colors.isFollowed
            mixIsFollowedButton.setImage((UIImage(named: "3_MixtapesFilled")?.withRenderingMode(.alwaysTemplate))!, for: .normal)
            
        } else {
            mixIsFollowedButton.tintColor = Colors.isNotFollowed
            mixIsFollowedButton.setImage((UIImage(named: "3_Mixtapes")?.withRenderingMode(.alwaysTemplate))!, for: .normal)
        }
    }
    
    
    private func colorsForCover() {
        // Get and/or Set colors for this cover after isFollowed set to true
        // CODE HERE
    
    }
    
    private func changeState() {
        guard let mixtapeID = mixtape?.id else { return }
        // Change state of isFollowed
        container?.performBackgroundTask{ context in
            let success = Mixtape.changeIsFollowed(for: mixtapeID, in: context)
            if (success) {
                print("Changed isFollowed State for id: ", mixtapeID)
            } else {
                print("[pressedFollowed] in DJsSearchCell Failed")
            }
        }
    }
    
    
    private func configureCell() {
        mixIsFollowedButton.isHidden = true
        guard let name = mixtape?.name else { return }
        mixtapeName.text = name
        mixtapeTags.text = tagsToString()
        mixDayLengthUI()
        updateFollowedButton()
        guard let url = mixtape?.cover768URL else { return }
        guard let mixCoverURL = URL(string: url) else { return }
        mixtapeCover.kf.setImage(with: mixCoverURL, options: [.backgroundDecode], completionHandler: {
            (img, err, cache, url) in
            self.mixIsFollowedButton.isHidden = false
        })
   
    }
    
    
    
    private func mixDayLengthUI() {
        guard let mix = mixtape else { return }
        let dayLength = mixtapesDayLengthLabelFormatter(for: mix)
        createdDay.attributedText = dayLength.mixDay
        mixLength.attributedText = dayLength.mixLength
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
    
    
}
