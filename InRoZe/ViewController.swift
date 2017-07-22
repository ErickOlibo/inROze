//
//  ViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 21/07/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        var imagesNames = [
            "logoCut_01", "logoCut_02", "logoCut_03", "logoCut_04", "logoCut_05", "logoCut_06", "logoCut_07", "logoCut_08", "logoCut_09", "logoCut_10",
            "logoCut_11", "logoCut_12", "logoCut_13", "logoCut_14", "logoCut_15", "logoCut_16", "logoCut_17", "logoCut_18", "logoCut_19", "logoCut_20",
            "logoCut_21", "logoCut_22", "logoCut_23", "logoCut_24", "logoCut_25", "logoCut_26", "logoCut_27", "logoCut_28", "logoCut_29", "logoCut_30",
            "logoCut_31", "logoCut_32", "logoCut_33", "logoCut_34", "logoCut_35", "logoCut_36", "logoCut_37", "logoCut_38", "logoCut_39", "logoCut_40",
            "logoCut_41"] // depending on number of images
        
        var images = [UIImage]()
        
        for i in 0..<imagesNames.count {
            images.append(UIImage(named: imagesNames[i])!)
        }
        
        imageView.animationImages = images
        imageView.animationDuration = 4.0
        imageView.animationRepeatCount = 1
        imageView.startAnimating()
        if !imageView.isAnimating {
            print("Animation Stopped")
        }
        
    }


}

