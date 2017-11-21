//
//  ConvenienceExtensions.swift
//  InRoZe
//
//  Created by Erick Olibo on 18/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation
import UIKit


// extension for type Dictionary
extension Dictionary {
    mutating func merge<K, V>(dict: [K: V]){
        for (k, v) in dict {
            self.updateValue(v as! Value, forKey: k as! Key)
        }
    }
}


// extension for the Date

extension Date {
    func split(this date: Date) -> (hour: String, day: String, num: String, month: String)
    {
        // FIX THIS
        let cityCode = UserDefaults().currentCityCode
        let cityName = cityNameFrom(cityCode: cityCode)
        
        let locale = convertToTypeCity(fromCityName: cityName)
        let newFormatter = DateFormatter()
        // To make this one in relation to the City chosen
        newFormatter.timeZone = TimeZone(identifier: timeZoneIdentifier(forCity: locale))!
        
        newFormatter.dateFormat = "d"
        let splitNum = newFormatter.string(from: date)
        newFormatter.dateFormat = "MMM"
        let splitMonth = newFormatter.string(from: date)
        newFormatter.dateFormat = "E"
        let splitDay = newFormatter.string(from: date)
        newFormatter.dateFormat = "HH:mm"
        let splitHours = newFormatter.string(from: date)
        
        return (splitHours, splitDay, splitNum, splitMonth)
    }
}


// Extension ot UIView to allow one-sided border on UIViews
// MrJAckdaw/UIView+Border

extension UIView {
    
    // Example use: myView.addBorder(toSide: .Left, withColor: UIColor.redColor().CGColor, andThickness: 1.0)
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        switch side {
        case .Left:
            border.frame = CGRect(x: 0.0, y: 0.0, width: thickness, height: frame.height)
        case .Right:
            border.frame = CGRect(x: frame.width, y: 0.0, width: thickness, height: frame.height)
        case .Top:
            border.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: thickness)
        case .Bottom:
            border.frame = CGRect(x: 0.0, y: frame.height, width: frame.width, height: thickness)
        }
        
        layer.addSublayer(border)
    }
    
    
    func addBorder(lengthFromStart length: CGFloat, toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        switch side {
        case .Left:
            border.frame = CGRect(x: 0.0, y: 0.0, width: thickness, height: length)
        case .Right:
            border.frame = CGRect(x: frame.width, y: 0.0, width: thickness, height: length)
        case .Top:
            border.frame = CGRect(x: 0.0, y: 0.0, width: length, height: thickness)
        case .Bottom:
            border.frame = CGRect(x: 0.0, y: frame.height, width: length, height: thickness)
        }
        
        layer.addSublayer(border)
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat, withOffset offset: (begin: CGFloat , end: CGFloat) ) {
        
        let border = CALayer()
        border.backgroundColor = color
        switch side {
        case .Left:
            border.frame = CGRect(x: 0.0, y: 0.0 + offset.begin, width: thickness, height: frame.height - offset.begin - offset.end)
        case .Right:
            border.frame = CGRect(x: frame.width, y: 0.0 + offset.begin, width: thickness, height: frame.height - offset.begin - offset.end)
        case .Top:
            border.frame = CGRect(x: 0.0 + offset.begin, y: 0.0, width: frame.width - offset.begin - offset.end, height: thickness)
        case .Bottom:
            border.frame = CGRect(x: 0.0 + offset.begin, y: frame.height, width: frame.width - offset.begin - offset.end, height: thickness)
        }
        
        layer.addSublayer(border)
    }
    
}



extension String {
    public func isValidHexColor() -> Bool {
        let chars = CharacterSet(charactersIn: "#0123456789ABCDEF").inverted
        let charsNum = self.count
        guard charsNum == 6 || charsNum == 7 && self.hasPrefix("#") else { return false }
        
        if (charsNum == 6) && uppercased().rangeOfCharacter(from: chars) != nil { return false }
        if (charsNum == 7 && self.hasPrefix("#")) && uppercased().rangeOfCharacter(from: chars) != nil { return false }
        return true
    }
}















