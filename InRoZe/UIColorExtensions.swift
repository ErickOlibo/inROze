//
//  UIColorExtension.swift
//  InRoZe
//
//  Created by Erick Olibo on 25/07/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit

extension UIColor {
    
    public class func convertToHexColor(from color: UIColor) -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 1
        _ = color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return String(format: "#%02X%02X%02X", Int(red * 0xff), Int(green * 0xff), Int(blue * 0xff))
    }
    
    
    public class func convertToUIColor(fromHexColor hex: String) -> UIColor {
        var color = hex.uppercased()
        guard color.isValidHexColor() else { return UIColor.lightGray }
        
        // Remove the hashtag if any
        if (color.hasPrefix("#")) {
            let index = color.index(color.startIndex, offsetBy: 1)
            color = String(color[index...])
        }

        let indexTwo = color.index(color.startIndex, offsetBy: 2)
        let indexFour = color.index(color.startIndex, offsetBy: 4)
        let red = String(color[color.startIndex..<indexTwo])
        let green = String(color[indexTwo..<indexFour])
        let blue = String(color[indexFour..<color.endIndex])
        var r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0
        
        Scanner(string: red).scanHexInt32(&r)
        Scanner(string: green).scanHexInt32(&g)
        Scanner(string: blue).scanHexInt32(&b)
        return UIColor(red: CGFloat(Float(r) / 255.0), green: CGFloat(Float(g) / 255.0), blue: CGFloat(Float(b) / 255.0), alpha: 1)
    }
    
    
    fileprivate class func rangeOfSubstringFromInts(string: String, start: Int, end: Int) -> Range<String.Index> {
        let s = string.index(string.startIndex, offsetBy: start)
        let e = string.index(string.startIndex, offsetBy: end)
        return s..<e
        
        
    }
    
    public class func randomColor(alpha: CGFloat) -> UIColor {
        let red = CGFloat(arc4random_uniform(256)) / 255.0
        let green = CGFloat(arc4random_uniform(256)) / 255.0
        let blue = CGFloat(arc4random_uniform(256)) / 255.0
        return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}


// Allow to add boder layer for Key user settings at runtime
// in the Interface Builder
extension CALayer {
    var borderUIColor: UIColor {
        set {
            self.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: self.borderColor!)
        }
    }
}


// ARE THESE NECESSARY
func coloredString(_ string: String, color: UIColor) -> NSAttributedString {
    let attributeOne = [ NSAttributedStringKey.foregroundColor: color ]
    return NSAttributedString(string: string, attributes: attributeOne)
}

// ARE THESE NECESSARY
func color(attributedString attrString: NSAttributedString, color: UIColor) -> NSMutableAttributedString {
    
    let attributedString = NSMutableAttributedString(attributedString: attrString)
    let stringRange = NSRange(location: 0, length: attributedString.length)
    attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: stringRange)
    return attributedString    
}

// Colors from CD layout
func colorsToHexString(with colors: UIImageColors) -> ColorsInHexString {
    var result = ColorsInHexString()
    result.background = UIColor.convertToHexColor(from: colors.background)
    result.primary = UIColor.convertToHexColor(from: colors.primary)
    result.secondary = UIColor.convertToHexColor(from: colors.secondary)
    result.detail = UIColor.convertToHexColor(from: colors.detail)
    
    return result
}


func colorsFromHexString(with hexColors: ColorsInHexString) -> UIImageColors {
    var result = UIImageColors()
    result.background = UIColor.convertToUIColor(fromHexColor: hexColors.background)
    result.primary = UIColor.convertToUIColor(fromHexColor: hexColors.primary)
    result.secondary = UIColor.convertToUIColor(fromHexColor: hexColors.secondary)
    result.detail = UIColor.convertToUIColor(fromHexColor: hexColors.detail)

    return result
}




public struct ColorsInHexString {
    public var background: String!
    public var primary: String!
    public var secondary: String!
    public var detail: String!
}



























