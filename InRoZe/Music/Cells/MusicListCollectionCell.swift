//
//  MusicListCollectionCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 05/01/2018.
//  Copyright © 2018 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData

class MusicListCollectionCell: UICollectionViewCell {
    
    // Core Data model container and context
    //var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    
    
    static var identifier: String { return String(describing: self) }
    var mixtape: Mixtape? { didSet { configureCell() } }
    
    // Outlets
    @IBOutlet weak var mixtapeTitle: UILabel!
    @IBOutlet weak var mixtapeMaker: UILabel!
    @IBOutlet weak var mixtapeCover: UIImageView! { didSet { setCover() } }
    
    
    private func configureCell() {
        guard let mix = mixtape else { return }
        guard let title = mix.name else { return }
        mixtapeTitle.text = title
        guard let djName = mix.deejay?.name else { return }
        mixtapeMaker.text = djName
        guard let coverURL = mix.cover320URL else { return }
        mixtapeCover.kf.setImage(with: URL(string: coverURL), options: [.backgroundDecode, .transition(.fade(0.2))])
        
    }
    
    
    private func setCover() {
        mixtapeCover.backgroundColor = .white
        mixtapeCover.layer.borderWidth = 0.333
        mixtapeCover.layer.borderColor = UIColor.lightGray.cgColor
        mixtapeCover.layer.cornerRadius = 6
        mixtapeCover.layer.masksToBounds = true
    }
    
}
