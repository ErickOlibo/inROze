//
//  MusicCollectionHeader.swift
//  InRoZe
//
//  Created by Erick Olibo on 04/01/2018.
//  Copyright © 2018 Erick Olibo. All rights reserved.
//

import UIKit

class MusicCollectionHeader: UICollectionReusableView {
    
    static var identifier: String { return String(describing: self) }
    
    @IBOutlet weak var catalogueLbl: UILabel!
    @IBOutlet weak var separator: UIView!
    
    
        
}
