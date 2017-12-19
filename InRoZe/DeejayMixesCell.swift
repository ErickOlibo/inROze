//
//  DeejayMixesCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 18/12/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit

class DeejayMixesCell: UITableViewCell {
    
    static var identifier: String { return String(describing: self) }
    var mixtape: Mixtape? { didSet { configureCell() } }
    
    // outlets
    @IBOutlet weak var mixtapeCover: UIImageView!
    
    @IBOutlet weak var mixtapeName: UILabel!
    @IBOutlet weak var mixtapeTags: UILabel!
    
    
    
    
    
    private func configureCell() {
        guard let name = mixtape?.name else { return }
        mixtapeName.text = name
        mixtapeTags.text = tagsToString()
        guard let url = mixtape?.coverURL else { return }
        guard let mixCoverURL = URL(string: url) else { return }
        mixtapeCover.kf.setImage(with: mixCoverURL, options: [.backgroundDecode])

        
    }
    
    
    private func tagsToString () -> String {
        var tags = ""
        let between = " #"
        guard let tag1 = mixtape?.tag1, tag1 != ""  else { return tags }
        tags += "#" + tag1
        
        guard let tag2 = mixtape?.tag2, tag2 != "" else { return tags }
        tags += between + tag2
        guard let tag3 = mixtape?.tag3, tag3 != ""  else { return tags }
        tags += between + tag3
        guard let tag4 = mixtape?.tag4, tag4 != ""  else { return tags }
        tags += between + tag4
        guard let tag5 = mixtape?.tag5, tag5 != ""  else { return tags }
        tags += between + tag5
        
        return tags
    }
    
    
}
