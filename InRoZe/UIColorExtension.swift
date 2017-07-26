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