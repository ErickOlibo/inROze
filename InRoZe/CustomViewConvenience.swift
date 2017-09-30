//
//  CustomViewConvenience.swift
//  InRoZe
//
//  Created by Erick Olibo on 30/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit

@IBDesignable class CustomUIView: UIView {
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
            
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var masksToBound: Bool {
        set {
            layer.masksToBounds = newValue
        }
        get {
            return layer.masksToBounds
            
        }
    }
}

// custom for ImageView
@IBDesignable class CustomUIImageView: UIImageView {
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
            
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var masksToBound: Bool {
        set {
            layer.masksToBounds = newValue
        }
        get {
            return layer.masksToBounds
            
        }
    }
}
