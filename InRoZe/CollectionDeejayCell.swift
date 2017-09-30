//
//  CollectionDeejayCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 30/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData

class CollectionDeejayCell: UICollectionViewCell {
    
    // Core Data model container and context
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    // get full artist for this cell
    var thisDJ: Artist? //{ didSet { updateUI() } }
    
    let followedColor: UIColor = UIColor.changeHexStringToColor(ColorInHexFor.logoRed)
    let notFollowedColor: UIColor = .lightGray
    let moreGigsString = " more gigs"
    let moreGigString = " more gig"
    let noGigString = "no other gig"
    let blankString = ""
    
    // Outlets for Cell UI
    @IBOutlet weak var outerCircle: CustomUIView!
    @IBOutlet weak var innerCircle: CustomUIView!
    @IBOutlet weak var followDJBottonView: UIButton!
    @IBOutlet weak var firstLetter: UILabel!
    @IBOutlet weak var djName: UILabel!
    @IBOutlet weak var moreGigs: UILabel!
    @IBOutlet weak var djCellFrame: CustomUIImageView!
    
    @IBAction func followDJButton(_ sender: UIButton) {
        
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
