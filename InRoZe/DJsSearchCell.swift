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
        pressedFollowed()
    }
    
    
    
    private func configureCell() {
        selectionStyle = .none
        guard let name = deejay?.name else { return }
        deejayName.text = name
        updateFollowedButton()
    }
    
    @objc private func pressedFollowed() {
        guard let djID = deejay?.id else { return }
        print("Cell [\(tag)] - pressed: [\(deejay?.name ?? "NOT HERE")]")
        if let context = container?.viewContext {
            context.perform {
                if let artistState = Artist.currentIsFollowedState(for: djID, in: context) {
                    self.deejay!.isFollowed = !artistState
                    self.updateFollowedButton()
                    self.changeState()
                }
            }
        }
    }
    
    private func updateFollowedButton() {
        guard let currentIsFollow = deejay?.isFollowed else { return }
        deejayName.textColor = currentIsFollow ? .black : Colors.isNotFollowed
        
        if (currentIsFollow) {
            followButton.tintColor = Colors.isFollowed
            followButton.setImage((UIImage(named: "2_FollowsFilled")?.withRenderingMode(.alwaysTemplate))!, for: .normal)
            followButton.tintColor = Colors.isFollowed
        } else {
            followButton.tintColor = Colors.isNotFollowed
            followButton.setImage((UIImage(named: "2_Follows")?.withRenderingMode(.alwaysTemplate))!, for: .normal)
            followButton.tintColor = Colors.isNotFollowed
        }
    }
    
    
    private func changeState() {
        guard let djID = deejay?.id else { return }
        // Change state of isFollowed
        container?.performBackgroundTask{ context in
            let success = Artist.changeIsFollowed(for: djID, in: context)
            if (success) {
                
            } else {
                print("[pressedFollowed] in DJsSearchCell Failed")
            }
        }
    }


}






