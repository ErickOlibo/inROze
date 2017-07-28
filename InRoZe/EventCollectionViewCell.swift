//
//  EventCollectionViewCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 25/07/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    
    var gradientColor: UIColor! {
        didSet {
            print("GradientColor SET")
            createGradientLayer()
        }
    }
    var gradientLayer: CAGradientLayer!
    
    // Creates outlets and an action for the bookmark icon
    @IBOutlet weak var cellBackground: UIView!

    @IBOutlet weak var coverImage: UIImageView!

    @IBOutlet weak var eventName: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var footer: UIView!
    
    @IBOutlet weak var eventLocation: UILabel!
    
    @IBOutlet weak var gradientView: UIView!
    
    
    @IBOutlet weak var dateDisplay: UIView! {
        didSet {
            dateDisplay.layer.cornerRadius = 10
            //dateDisplay.layer.masksToBounds = true
            dateDisplay.backgroundColor = Constants.InrozeColor.petal
        }
    }
    
    
    // OUTLETS to test he UIImageColor class
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var primary: UIView!
    @IBOutlet weak var secondary: UIView!
    @IBOutlet weak var detail: UIView!
    

    fileprivate func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, gradientColor.cgColor]
        gradientLayer.locations = [0.20, 1.0]
        gradientView.layer.addSublayer(gradientLayer)
    }
    
}
