//
//  MusicSlider.swift
//  InRoZe
//
//  Created by Erick Olibo on 14/02/2018.
//  Copyright © 2018 Erick Olibo. All rights reserved.
//  Heavely copied and Inspired by CustomUISlider (Sergei Armodin)

//  *********************************************************
//  CustomUISlider
//
//  Created by mak on 24.11.2017.
//  Copyright © 2017 Sergei Armodin. All rights reserved.
//
//  *********************************************************

import UIKit

class MusicSlider: UISlider {

    
    /// Big position image view
    var bigImage = UIImageView()
    
    /// Thumb Image color
    var thumbColor = Colors.logoRed
    


    /// TrackRect Height
    var trackHeight: CGFloat = 8
    
    /// Small indicator counted size
    var indicatorSize: CGSize? = nil
    
    override var isHighlighted: Bool {
        didSet {
            // avoid situation when indicator size didn't count yet
            guard self.indicatorSize != nil else { return }
            
            UIView.animate(withDuration: 0.3) {
                if self.isHighlighted == true {
                    self.bigImage.transform = CGAffineTransform(scaleX: 3, y: 3)
                    
                } else {
                    self.bigImage.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            }
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let positionImage = UIImage.circle(diameter: 14, color: thumbColor)
        self.setThumbImage(positionImage, for: .normal)
        
        let positionImageBig = UIImage.circle(diameter: 60, color: thumbColor)
        self.bigImage.contentMode = .scaleAspectFit
        self.bigImage.clipsToBounds = false
        self.bigImage.image = positionImageBig
        
        self.addSubview(bigImage)
        self.bringSubview(toFront: bigImage)
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let unadjustedThumbrect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        let origin = unadjustedThumbrect.origin
        let size = unadjustedThumbrect.size
        
        if self.indicatorSize == nil && unadjustedThumbrect.size.width > 0 {
            self.bigImage.frame = unadjustedThumbrect
            self.indicatorSize = size
        }
        
        let bigImageSize = self.bigImage.frame.size
        
        self.bigImage.frame.origin = CGPoint(
            x: origin.x - (bigImageSize.width/2 - size.width/2),
            y: origin.y - (bigImageSize.height/2 - size.height/2)
        )
        
        self.bringSubview(toFront: bigImage)
        return unadjustedThumbrect
    }
    
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.trackRect(forBounds: bounds)
        newBounds.size.height = trackHeight
        return newBounds
    }
    
}






