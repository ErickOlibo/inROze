//
//  MusicMixCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 04/01/2018.
//  Copyright © 2018 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData

class MusicMixCell: UICollectionViewCell
{
    
    // properties
    static var identifier: String { return String(describing: self) }
    var mixtape: Mixtape? { didSet { configureCell() }}
    
    
    // context & container
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    
    
    // outlets
    @IBOutlet weak var mixCover: UIImageView! { didSet { setCover() } }
    @IBOutlet weak var mixTitle: UILabel!
    @IBOutlet weak var mixMaker: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //print("[\(tag)] - MusicMixCell woke from Nib")
        self.backgroundColor = .white
        //self.layer.borderWidth = 0.333
        //self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
        

    }
    
    private func updateUI() {

    }
    
    private func setCover() {
        mixCover.backgroundColor = .white
        mixCover.layer.borderWidth = 0.333
        mixCover.layer.borderColor = UIColor.lightGray.cgColor
        mixCover.layer.cornerRadius = 6
        mixCover.layer.masksToBounds = true
    }
    
    private func configureCell() {
        guard let mix = mixtape else { return }
        
        guard let title = mix.name else { return }
        mixTitle.text = title
        guard let djName = mix.deejay?.name else { return }
        mixMaker.text = djName
        guard let coverURL = mix.cover768URL else { return }
        mixCover.kf.setImage(with: URL(string: coverURL), options: [.backgroundDecode, .transition(.fade(0.2))])
        
        
        
        
        
    }
    
    
}
