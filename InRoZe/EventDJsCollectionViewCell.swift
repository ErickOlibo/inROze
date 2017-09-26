//
//  EventDJsCollectionViewCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 23/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit

class EventDJsCollectionViewCell: UICollectionViewCell
{
    // Core Data model container and context
    private let context = AppDelegate.viewContext
    private let container = AppDelegate.persistentContainer
    
    // get full artist for this cell
    var thisDJ: Artist? { didSet { updateUI() } }
    
    let followedColor: UIColor = UIColor.changeHexStringToColor(ColorInHexFor.logoRed)
    let notFollowedColor: UIColor = .lightGray
    let moreGigsString = " more gigs"
    let moreGigString = " more gig"
    let noGigString = "no other gig"
    let blankString = ""

    // Outlets for Cell UI
    @IBOutlet weak var textDisplayBg: UIView! {
        didSet {
            textDisplayBg.layer.masksToBounds = true
            textDisplayBg.layer.borderWidth = 2
            textDisplayBg.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var outerCircle: UIView! {
        didSet {
            outerCircle.layer.borderWidth = 6
            outerCircle.layer.cornerRadius = outerCircle.bounds.width / 2
        }
    }
    
    @IBOutlet weak var innerCircle: UIView! {
        didSet {
            innerCircle.layer.borderWidth = 2
            innerCircle.layer.cornerRadius = innerCircle.bounds.width / 2
        }
    }
    
    @IBOutlet weak var textDisplayGigs: UIView! {
        didSet {
            textDisplayGigs.layer.borderWidth = 1
        }
    }
    
    @IBOutlet weak var followDJBottonView: UIButton! {
        didSet {
            followDJBottonView.layer.borderWidth = 1
        }
    }
    
    
    @IBOutlet weak var firstLetter: UILabel!
    @IBOutlet weak var djName: UILabel!
    @IBOutlet weak var moreGigs: UILabel!
    
    
    
    @IBAction func followDJButton(_ sender: UIButton) {
        print("Follow button was Pressed: Name: \(thisDJ!.name!) -> gigs: [\(thisDJ!.gigs!.count)] -> Follow Before Press: [\(thisDJ!.isFollowed)]")

        saveFollowed()
        
        setIsFollowButton(for: thisDJ!.isFollowed)
    }
    
    private func saveFollowed() {
        thisDJ?.isFollowed = !thisDJ!.isFollowed
        let artistId = thisDJ!.id!
        container.performBackgroundTask { context in
            _ = Artist.setIsFollowed(for: artistId, in: context)
        }
    }
    
    
    
    private func updateUI() {
        firstLetter.text = String((thisDJ!.name!.uppercased()).characters.first!)
        djName.text = thisDJ!.name!.uppercased()
        setIsFollowButton(for: thisDJ!.isFollowed)
        updateCellColorforFollowed(for: thisDJ!.isFollowed)
        
    }
    
    private func setIsFollowButton(for state: Bool) {
        var followImg = UIImage()
        updateCellColorforFollowed(for: state)
        if (state) {
            followImg = (UIImage(named: "2_FollowsFilled")?.withRenderingMode(.alwaysTemplate))!
            followDJBottonView.setImage(followImg, for: .normal)
            followDJBottonView.tintColor = UIColor.changeHexStringToColor(ColorInHexFor.logoRed)
        } else {
            followImg = (UIImage(named: "2_Follows")?.withRenderingMode(.alwaysTemplate))!
            followDJBottonView.setImage(followImg, for: .normal)
            followDJBottonView.tintColor = .lightGray
        }
        
    }
    
   
    private func updateCellColorforFollowed(for state: Bool) {
        let djInitial = String((thisDJ!.name!.uppercased()).characters.first!)
        let thisDJname = thisDJ!.name!.uppercased()
        if (state) {
            textDisplayBg.layer.borderColor = followedColor.cgColor
            outerCircle.layer.borderColor = followedColor.cgColor
            
            innerCircle.layer.borderColor = followedColor.cgColor
            innerCircle.backgroundColor = followedColor
            textDisplayGigs.layer.borderColor = followedColor.cgColor
            followDJBottonView.layer.borderColor = followedColor.cgColor
            firstLetter.attributedText = coloredString(djInitial, color: .white)
            djName.attributedText = coloredString(thisDJname, color: .black)
            moreGigs.attributedText = coloredString(moreGigsText(), color: .black)
            
            
        } else {
            textDisplayBg.layer.borderColor = notFollowedColor.cgColor
            outerCircle.layer.borderColor = notFollowedColor.cgColor
            
            innerCircle.layer.borderColor = notFollowedColor.cgColor
            innerCircle.backgroundColor = .white
            textDisplayGigs.layer.borderColor = notFollowedColor.cgColor
            followDJBottonView.layer.borderColor = notFollowedColor.cgColor
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







