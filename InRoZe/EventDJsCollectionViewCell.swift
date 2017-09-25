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
    
    // get full artist for this cell
    var thisDJ: Artist? { didSet { updateUI() } }
    
    let followedColor: UIColor = UIColor.changeHexStringToColor(ColorInHexFor.logoRed)
    let notFollowedColor: UIColor = .lightGray

    @IBOutlet weak var textDisplayBg: UIView! {
        didSet {
            textDisplayBg.layer.masksToBounds = true // no change
            textDisplayBg.layer.borderWidth = 2 // no change
            textDisplayBg.layer.cornerRadius = 10 // no vhange
        }
    }
    
    @IBOutlet weak var outerCircle: UIView! {
        didSet {
            outerCircle.layer.borderWidth = 6 // no change
            outerCircle.layer.cornerRadius = outerCircle.bounds.width / 2 // no change
        }
    }
    
    @IBOutlet weak var innerCircle: UIView! {
        didSet {
            innerCircle.layer.borderWidth = 2 // no vhange
            innerCircle.layer.cornerRadius = innerCircle.bounds.width / 2 // no change
        }
    }
    
    @IBOutlet weak var textDisplayGigs: UIView! {
        didSet {
            textDisplayGigs.layer.borderWidth = 1 // no change
        }
    }
    
    @IBOutlet weak var followDJBottonView: UIButton! {
        didSet {
            followDJBottonView.layer.borderWidth = 1 // no change
        }
    }
    
    @IBAction func followDJButton(_ sender: UIButton) {
        print("Follow button was Pressed: Name: \(thisDJ!.name!) -> gigs: [\(thisDJ!.gigs!.count)] -> Follow Before Press: [\(thisDJ!.isFollowed)]")
        
        thisDJ?.isFollowed = !thisDJ!.isFollowed
        setIsFollowButton(for: thisDJ!.isFollowed)
    }
    
    
    
    private func updateUI() {
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
        if (state) {
            textDisplayBg.layer.borderColor = followedColor.cgColor
            outerCircle.layer.borderColor = followedColor.cgColor
            
            innerCircle.layer.borderColor = followedColor.cgColor
            innerCircle.backgroundColor = followedColor
            textDisplayGigs.layer.borderColor = followedColor.cgColor
            followDJBottonView.layer.borderColor = followedColor.cgColor
            
            
        } else {
            textDisplayBg.layer.borderColor = notFollowedColor.cgColor
            outerCircle.layer.borderColor = notFollowedColor.cgColor
            
            innerCircle.layer.borderColor = notFollowedColor.cgColor
            innerCircle.backgroundColor = .white
            textDisplayGigs.layer.borderColor = notFollowedColor.cgColor
            followDJBottonView.layer.borderColor = notFollowedColor.cgColor
            
            
        }
    }
    
    
}







