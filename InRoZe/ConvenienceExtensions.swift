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

        let newFormatter = DateFormatter()
        // To make this one in relation to the City chosen
        //newFormatter.timeZone = TimeZone(identifier: currentCity.timeZone.rawValue)!
        
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

//*********************************************
// Extracted from website: https://gist.github.com/minorbug/468790060810e0d29545
// Commentor: jinthagerman commented on Feb 26, 2017
//*********************************************

struct DateComponentUnitFormatter {
    
    private struct DateComponentUnitFormat {
        let unit: Calendar.Component
        
        let singularUnit: String
        let pluralUnit: String
        
        let futureSingular: String
        let pastSingular: String
    }
    
    private let formats: [DateComponentUnitFormat] = [
        
        DateComponentUnitFormat(unit: .year,
                                singularUnit: "year",
                                pluralUnit: "years",
                                futureSingular: "Next year",
                                pastSingular: "Last year"),
        
        DateComponentUnitFormat(unit: .month,
                                singularUnit: "month",
                                pluralUnit: "months",
                                futureSingular: "Next month",
                                pastSingular: "Last month"),
        
        DateComponentUnitFormat(unit: .weekOfYear,
                                singularUnit: "week",
                                pluralUnit: "weeks",
                                futureSingular: "Next week",
                                pastSingular: "Last week"),
        
        DateComponentUnitFormat(unit: .day,
                                singularUnit: "day",
                                pluralUnit: "days",
                                futureSingular: "Tomorrow",
                                pastSingular: "Yesterday"),
        
        DateComponentUnitFormat(unit: .hour,
                                singularUnit: "hour",
                                pluralUnit: "hours",
                                futureSingular: "In an hour",
                                pastSingular: "An hour ago"),
        
        DateComponentUnitFormat(unit: .minute,
                                singularUnit: "minute",
                                pluralUnit: "minutes",
                                futureSingular: "In a minute",
                                pastSingular: "A minute ago"),
        
        DateComponentUnitFormat(unit: .second,
                                singularUnit: "second",
                                pluralUnit: "seconds",
                                futureSingular: "Just now",
                                pastSingular: "Just now"),
        
        ]
    
    func string(forDateComponents dateComponents: DateComponents, useNumericDates: Bool) -> String {
        for format in self.formats {
            let unitValue: Int
            
            switch format.unit {
            case .year:
                unitValue = dateComponents.year ?? 0
            case .month:
                unitValue = dateComponents.month ?? 0
            case .weekOfYear:
                unitValue = dateComponents.weekOfYear ?? 0
            case .day:
                unitValue = dateComponents.day ?? 0
            case .hour:
                unitValue = dateComponents.hour ?? 0
            case .minute:
                unitValue = dateComponents.minute ?? 0
            case .second:
                unitValue = dateComponents.second ?? 0
            default:
                assertionFailure("Date does not have requried components")
                return ""
            }
            
            switch unitValue {
            case 2 ..< Int.max:
                return "\(unitValue) \(format.pluralUnit) ago"
            case 1:
                return useNumericDates ? "\(unitValue) \(format.singularUnit) ago" : format.pastSingular
            case -1:
                return useNumericDates ? "In \(-unitValue) \(format.singularUnit)" : format.futureSingular
            case Int.min ..< -1:
                return "In \(-unitValue) \(format.pluralUnit)"
            default:
                break
            }
        }
        
        return "Just now"
    }
}


extension Date {
    
    // Allows the social type of display for time (just now, yesterday, etc.
    func timeAgoSinceNow(useNumericDates: Bool = false) -> String {
        
        let calendar = Calendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let components = calendar.dateComponents(unitFlags, from: self, to: now)
        
        let formatter = DateComponentUnitFormatter()
        return formatter.string(forDateComponents: components, useNumericDates: useNumericDates)
    }
}














