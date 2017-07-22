//
//  GlassView.swift
//  InRoZe
//
//  Created by Erick Olibo on 22/07/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit

class GlassView: UIView

{
    
    let liquidView = UIView()
    let shapeView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.backgroundColor = UIColor.lightGray
        self.liquidView.backgroundColor = UIColor.orange
        
        self.shapeView.contentMode = .scaleAspectFit
        self.shapeView.image = UIImage(named: "InRoZe_Icon_Color_Trans_300")
        
        self.addSubview(liquidView)
        self.mask = shapeView
        layoutIfNeeded()
        reset()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        liquidView.frame = self.bounds
        shapeView.frame = self.bounds
    }
    
    func reset() {
        liquidView.frame.origin.y = bounds.height
    }
    
    func animate() {
        reset()
        UIView.animate(withDuration: 1) { [weak self] in
            self?.liquidView.frame.origin.y = 0
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
