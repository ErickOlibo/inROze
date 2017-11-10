//
//  DJNameView.swift
//  InRoZe
//
//  Created by Erick Olibo on 25/10/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData

class DJNameView: UIView {
    
    // Core Data model container and context
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    // UI colors for isFollowed
    let followedColor: UIColor = UIColor.changeHexStringToColor(ColorInHexFor.logoRed)
    let notFollowedColor: UIColor = .gray
    
    var djName = UILabel(frame: CGRect.zero)
    var djProfile = UIImageView(frame: CGRect.zero)
    var dj: Artist? { didSet { updateUI() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    private func setup() {
        // Set up the frame size
        //self.frame = CGRect(x: 0, y: 0, width: 80, height: 100)
        djProfile.frame = CGRect(x: 10, y: 0, width: 60, height: 60)
        djName.frame = CGRect(x: 0, y: 70, width: 80, height: 14)
        
        // set the label
        djName.textAlignment = .center
        djName.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 14)
        //updateUI()
    }
    
    private func updateUI() {
        container?.performBackgroundTask{ context in
            //print("FETCHING isFollowed From CORE DATA || Current Thread: [\(Thread.current)]")
            if let currentState = Artist.currentIsFollowedState(for: self.dj!.id! , in: context) {
                self.dj!.isFollowed = currentState
            }
        }
        updateCellColorforFollowed()
    }
    
    private func updateCellColorforFollowed() {
        djProfile.image = UIImage(named: profileImageForDJ(with: dj!.id!, when: dj!.isFollowed))
        djName.text = dj!.name
        djName.textColor = (dj!.isFollowed) ? followedColor : notFollowedColor
        
        // add view to superview
        self.addSubview(djName)
        self.addSubview(djProfile)
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
