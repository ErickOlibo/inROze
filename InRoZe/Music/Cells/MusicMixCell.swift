//
//  MusicMixCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 04/01/2018.
//  Copyright © 2018 Erick Olibo. All rights reserved.
//

import UIKit

class MusicMixCell: UICollectionViewCell
{
    
    // properties
    static var identifier: String { return String(describing: self) }
    
    
    // outlets
    @IBOutlet weak var thisLabel: UILabel! { didSet { updateUI() } }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //print("[\(tag)] - MusicMixCell woke from Nib")
        self.backgroundColor = .red
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
        

    }
    
    private func updateUI() {
        thisLabel.text = String(tag)
        print("[\(tag)] - MusicMixCell updateUI")
    }
    
    
}
