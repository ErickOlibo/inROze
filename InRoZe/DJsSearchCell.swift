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
    var searchText: String?


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
        
        // Line to change
        //deejayName.textColor = currentIsFollow ? .black : Colors.isNotFollowed
        deejayNameAttributed()
        // define later the number of mixtapes
        setSubtitleText(currentIsFollow, mixCount: 2)
        
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
    
    // Attribute substring that match searchtext
    private func deejayNameAttributed() {
        guard let currentIsFollow = deejay?.isFollowed else { return }
        guard let text = searchText, text.count > 0 else {
            //print("[deejayNameAttributed] - SearchText Count: [NIL]")
            deejayName.textColor = currentIsFollow ? .black : Colors.isNotFollowed
            return
        }
        //print("[deejayNameAttributed] - SearchText Count: [\(text.count)]")
        attributedDJName()
    }
    
    
    private func attributedDJName() {
        //print("attributedDJName")
        guard let currentIsFollow = deejay?.isFollowed else { return }
        guard let name = deejay?.name else { return }
        guard let text = searchText else { return }
        let searchTxt = text.uppercased()
        var attrName = NSMutableAttributedString(string: name)
        attrName = color(attributedString: attrName, color: currentIsFollow ? .black : Colors.isNotFollowed)
        let nameLength = attrName.string.count
        let searchTxtLength = searchTxt.count
        var range = NSRange(location: 0, length: attrName.length)
        while (range.location != NSNotFound) {
            range = (attrName.string as NSString).range(of: searchTxt, options: [], range: range)
            if (range.location != NSNotFound) {
                attrName.addAttribute(NSAttributedStringKey.foregroundColor, value: Colors.logoRed, range: NSRange(location: range.location, length: searchTxtLength))
                range = NSRange(location: range.location + range.length, length: nameLength - (range.location + range.length))
            }
        }
        deejayName.attributedText = attrName
        

        
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
    
    
    private func setSubtitleText(_ status: Bool, mixCount: Int) {
        // set the number of gigs
        var subtitle = ""
        guard let gigs = deejay?.gigs?.count else { return }
        let mixes = mixCount
        let combi = (gig: gigs, mix: mixes)
        
        switch combi {
        case (0, 0):
            subtitle = ""
        case (0, 1):
            subtitle = "\(combi.mix) mixtape"
        case (0, 2...):
            subtitle = "\(combi.mix) mixtapes"
        case (1, 0):
            subtitle = "\(combi.gig) gig"
        case (1, 1):
            subtitle = "\(combi.gig) gig - \(combi.mix) mixtape"
        case (1, 2...):
            subtitle = "\(combi.gig) gig - \(combi.mix) mixtapes"
        case (2..., 0):
            subtitle = "\(combi.gig) gigs"
        case (2..., 1):
            subtitle = "\(combi.gig) gigs - \(combi.mix) mixtape"
        case (2..., 2...):
            subtitle = "\(combi.gig) gigs - \(combi.mix) mixtapes"
        case (_, _):
            subtitle = ""
        }
        gigsMixesList.text = subtitle
        gigsMixesList.textColor = status ? .black : Colors.isNotFollowed

        
        
    }


}






