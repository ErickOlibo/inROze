//
//  UIColorExtension.swift
//  InRoZe
//
//  Created by Erick Olibo on 25/07/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit

extension UIColor {
    public class func changeColorToHexString(_ color: UIColor) -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 1
        
        _ = color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return String(format: "#%02X%02X%02X", Int(red * 0xff), Int(green * 0xff), Int(blue * 0xff))
        
        
    }
    
    
    public class func changeHexStringToColor(_ hex: String) -> UIColor {
        var color = hex.uppercased()
        
        // Remove the hashtag if any
        if (color.hasPrefix("#")) {
            let index = color.index(color.startIndex, offsetBy: 1)
            color = color.substring(from: index)
        }
        
        // Return a default color if HexString in of bad formating
        if (color.characters.count != 6) {
            return UIColor.lightGray
        }
        
        let red = color.substring(with: rangeOfSubstringFromInts(string: color, start: 0, end: 2))
        let green = color.substring(with: rangeOfSubstringFromInts(string: color, start: 2, end: 4))
        let blue = color.substring(with: rangeOfSubstringFromInts(string: color, start: 4, end: 6))
        var r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0
        
        Scanner(string: red).scanHexInt32(&r)
        Scanner(string: green).scanHexInt32(&g)
        Scanner(string: blue).scanHexInt32(&b)
        
        return UIColor(colorLiteralRed: Float(r) / 255.0, green: Float(g) / 255.0, blue: Float(b) / 255.0, alpha: Float(1))
    }
    
    
    fileprivate class func rangeOfSubstringFromInts(string: String, start: Int, end: Int) -> Range<String.Index> {
        let s = string.index(string.startIndex, offsetBy: start)
        let e = string.index(string.startIndex, offsetBy: end)
        return s..<e
        
        
    }
    
    
}


func coloredString(_ string: String, color: UIColor) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString(string: string)
    let stringRange = NSRange(location: 0, length: attributedString.length)
    attributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: stringRange)
    return attributedString
}


func colorsToHexString(with imageColors: UIImageColors) -> ColorsInHexString {
    var result = ColorsInHexString()
    result.background = UIColor.changeColorToHexString(imageColors.background)
    result.primary = UIColor.changeColorToHexString(imageColors.primary)
    result.secondary = UIColor.changeColorToHexString(imageColors.secondary)
    result.detail = UIColor.changeColorToHexString(imageColors.detail)
    
    return result
}


func colorsFromHexString(with hexColors: ColorsInHexString) -> UIImageColors {
    var result = UIImageColors()
    result.background = UIColor.changeHexStringToColor(hexColors.background)
    result.primary = UIColor.changeHexStringToColor(hexColors.primary)
    result.secondary = UIColor.changeHexStringToColor(hexColors.secondary)
    result.detail = UIColor.changeHexStringToColor(hexColors.detail)

    return result
}




public struct ColorsInHexString {
    public var background: String!
    public var primary: String!
    public var secondary: String!
    public var detail: String!
}

public struct EventCell {
    public var event: Event!
    public var colors: UIImageColors!
    public var img: UIImage!
    
    
}

























