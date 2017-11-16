//
//  ConvenienceFunctions.swift
//  InRoZe
//
//  Created by Erick Olibo on 28/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation
import UIKit
//import Font_Awesome_Swift


// Format the event day, time, and location to Attributed text for cell subtitle
// returns an Attributed string
func dateTimeLocationFormatter(with event: Event) -> NSAttributedString {
    
    let splitDate = Date().split(this: event.startTime! as Date)
    let dateTimeText = "\(splitDate.day), \(splitDate.num) \(splitDate.month) - \(splitDate.hour) @ "
    let locationNameAttributedText = coloredString(event.location!.name!, color: .black)
    let dateTimeAttributedText = coloredString(dateTimeText, color: .gray)
    let combinedAttributedText = NSMutableAttributedString()
    
    combinedAttributedText.append(dateTimeAttributedText)
    combinedAttributedText.append(locationNameAttributedText)
    return combinedAttributedText
}


// Takes a date at the current timeZone
// return the date at the selected City TimeZone
//func convertToLocalTimeZone(withDate date: Date) -> Date {
//    var calendar = Calendar.current
//    calendar.timeZone = TimeZone(identifier: appTimeZone(forThisCity: .Tallinn))!
//    
//}


// get a particular icon of type FontAwesome and
// return an attributed string
func fontAwesomeAttributedString(forString iconString: String, withColor iconColor: UIColor, andFontSize size: CGFloat) -> NSAttributedString {
    //let silence = NSAttributedString()
    
    let attributeOne = [ NSAttributedStringKey.font: UIFont(name: "FontAwesome", size: size)! ]
    let iconAttributedText = NSMutableAttributedString()
    let iconAttributed = NSAttributedString(string: iconString, attributes: attributeOne)
    iconAttributedText.append(color(attributedString: iconAttributed, color: iconColor))
    
    
    return iconAttributedText
}






// Get the Event Object from a configureCell method
// Returns an attributed string ordering the DJlist by isFollowed,
// then by alphabetical order
func deejaysListAttributed(for event: Event) -> NSAttributedString {
    let attributedDJsList = NSAttributedString(string: "")
    guard let performers = event.performers?.allObjects as? [Artist] else { return attributedDJsList }
    //let sorted = performers.sorted(by: {$0.name! < $1.name!})
    let myarray = Array(performers)
    
    let sorted = myarray.sorted(by: { lhs, rhs in
        if lhs.isFollowed == rhs.isFollowed {
            return lhs.name! < rhs.name!
        }
        return lhs.isFollowed && !rhs.isFollowed
    })
    let attributeOne = [ NSAttributedStringKey.font: UIFont(name: "FontAwesome", size: 20.0)! ]
    let faHash = FAType.FAHashtag.text!
    let hashtag = NSAttributedString(string: faHash, attributes: attributeOne)
    
    let attributedSpacing = coloredString("  ", color: .black)
    let combinedAttributedText = NSMutableAttributedString()
    
    for deejay in sorted {
        if (deejay != sorted[0]) {
            combinedAttributedText.append(attributedSpacing)
            
        }
        if let deejayName = deejay.name {
            if (deejay.isFollowed) {
                print("isFollowed: [\(deejayName)]")
                combinedAttributedText.append(color(attributedString: hashtag, color: Colors.isFollowed))
                combinedAttributedText.append(coloredString(deejayName, color: Colors.isFollowed))
            } else {
                combinedAttributedText.append(color(attributedString: hashtag, color: Colors.isNotFollowed))
                combinedAttributedText.append(coloredString(deejayName, color: Colors.isNotFollowed))
            }
        }
    }
    return combinedAttributedText
}















