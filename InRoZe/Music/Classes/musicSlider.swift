//
//  musicSlider.swift
//  InRoZe
//
//  Created by Erick Olibo on 14/02/2018.
//  Copyright © 2018 Erick Olibo. All rights reserved.
//

import UIKit

class musicSlider: UISlider {

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.trackRect(forBounds: bounds)
        newBounds.size.height = 8
        return newBounds
    }
    
}
