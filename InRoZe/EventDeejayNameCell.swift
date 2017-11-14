//
//  EventDeejayNameCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 23/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//  TO DELETE NOT NEEDED

import UIKit
import CoreData

class EventDeejayNameCell: UICollectionViewCell
{
    // Core Data model container and context
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

    static var identifier: String {
        return String(describing: self)
    }
    
    // get full artist for this cell
    var thisDJ: Artist? { didSet { updateUI() } }
    
    let followedColor: UIColor = Colors.logoRed
    let notFollowedColor: UIColor = .lightGray
    let moreGigsString = " more gigs"
    let moreGigString = " more gig"
    let noGigString = "no other gig"
    let blankString = ""
    //private var currentFollowState = false

    // Outlets for Cell UI
    @IBOutlet weak var outerCircle: UIView!
    @IBOutlet weak var innerCircle: UIView!
    @IBOutlet weak var followDJBottonView: UIButton!
    @IBOutlet weak var firstLetter: UILabel!
    @IBOutlet weak var djName: UILabel!
    @IBOutlet weak var moreGigs: UILabel!
    @IBOutlet weak var djCellFrame: UIImageView!
    
    
    @IBAction func followDJButton(_ sender: UIButton) {
        if let context = container?.viewContext {
            context.perform {
                if let artistState = Artist.currentIsFollowedState(for: self.thisDJ!.id!, in: context) {
                    self.thisDJ!.isFollowed = !artistState
                    //self.currentFollowState = !artistState
                    self.setIsFollowButton()
                    self.updateCellColorforFollowed()
                    self.changeState()
                }
            }
        }
    }

    
    private func changeState() {
        // change state of isFollowed
        container?.performBackgroundTask{ context in
            let success = Artist.changeIsFollowed(for: self.thisDJ!.id!, in: context)
            if (!success) {
                print("[followDJButton] - FAILED")
            }
        }
    }
    
    
    private func updateUI() {
        if let context = container?.viewContext {
            context.perform {
                if let currentState = Artist.currentIsFollowedState(for: self.thisDJ!.id!, in: context) {
                    self.thisDJ!.isFollowed = currentState
                }
            }
        }
        firstLetter.text = String(thisDJ!.name!.uppercased().prefix(1))
        djName.text = thisDJ!.name!.uppercased()
        setIsFollowButton()
        updateCellColorforFollowed()
    }
    
    private func setIsFollowButton() {
        var followImg = UIImage()
        if (thisDJ!.isFollowed) {
            followImg = (UIImage(named: "2_FollowsFilled")?.withRenderingMode(.alwaysTemplate))!
            followDJBottonView.setImage(followImg, for: .normal)
            followDJBottonView.tintColor = Colors.logoRed
        } else {
            followImg = (UIImage(named: "2_Follows")?.withRenderingMode(.alwaysTemplate))!
            followDJBottonView.setImage(followImg, for: .normal)
            followDJBottonView.tintColor = .lightGray
        }
    }
    
    private func updateCellColorforFollowed() {
        let djInitial = String(thisDJ!.name!.uppercased().prefix(1))
        let thisDJname = thisDJ!.name!.uppercased()
        if (thisDJ!.isFollowed) {
            outerCircle.layer.borderColor = followedColor.cgColor
            innerCircle.layer.borderColor = followedColor.cgColor
            innerCircle.backgroundColor = followedColor
            djCellFrame.tintColor = followedColor
            djCellFrame.layer.borderColor = followedColor.cgColor
            //followDJBottonView.layer.borderColor = followedColor.cgColor
            firstLetter.attributedText = coloredString(djInitial, color: .white)
            djName.attributedText = coloredString(thisDJname, color: .black)
            moreGigs.attributedText = coloredString(moreGigsText(), color: .black)
            
            
        } else {
            outerCircle.layer.borderColor = notFollowedColor.cgColor
            innerCircle.layer.borderColor = notFollowedColor.cgColor
            innerCircle.backgroundColor = .white
            djCellFrame.tintColor = notFollowedColor
            djCellFrame.layer.borderColor = notFollowedColor.cgColor
            firstLetter.attributedText = coloredString(djInitial, color: notFollowedColor)
            djName.attributedText = coloredString(thisDJname, color: notFollowedColor)
            moreGigs.attributedText = coloredString(moreGigsText(), color: .lightGray)
            
        }
    }
    
    private func moreGigsText()  -> String {
        let totalOtherGigs = thisDJ!.gigs!.count - 1
        switch totalOtherGigs {
        case 0:
            return blankString
        case 1:
            return String(totalOtherGigs) + moreGigString
        default:
            return String(totalOtherGigs) + moreGigsString
            
        }
    }
    
    
}







