//
//  ConvenienceFunctions.swift
//  InRoZe
//
//  Created by Erick Olibo on 28/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation
import UIKit


// Format the event day, time, and location to Attributed text for cell subtitle
// returns an Attributed string
public func dateTimeLocationFormatter(with event: Event) -> NSAttributedString {
    
    let splitDate = Date().split(this: event.startTime! as Date)
    let dateTimeText = "\(splitDate.day), \(splitDate.num) \(splitDate.month) - \(splitDate.hour) @ "
    let locationNameAttributedText = coloredString(event.location!.name!, color: .black)
    let dateTimeAttributedText = coloredString(dateTimeText, color: .gray)
    let combinedAttributedText = NSMutableAttributedString()
    
    combinedAttributedText.append(dateTimeAttributedText)
    combinedAttributedText.append(locationNameAttributedText)
    return combinedAttributedText
}


// get a particular icon of type FontAwesome and
// return an attributed string
public func fontAwesomeAttributedString(forString iconString: String, withColor iconColor: UIColor, andFontSize size: CGFloat) -> NSAttributedString {
    let attributeOne = [ NSAttributedStringKey.font: UIFont(name: "FontAwesome", size: size)! ]
    let iconAttributedText = NSMutableAttributedString()
    let iconAttributed = NSAttributedString(string: iconString, attributes: attributeOne)
    iconAttributedText.append(color(attributedString: iconAttributed, color: iconColor))
    return iconAttributedText
}


// Get the Event Object from a configureCell method
// Returns an attributed string ordering the DJlist by isFollowed,
// then by alphabetical order
public func deejaysListAttributed(for event: Event) -> NSAttributedString {
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


// manage the colors and image for Deejay's profile pic
// Deejays prifies are determin by the last 2 digits of their
// respective ID
public func profileImageForDJ(with id: String, when isFollowed: Bool) -> String {
    let lastTwo = id.suffix(2)
    let colorOrGrey = (isFollowed) ? "img_Color_DJcover_" : "img_Grey_DJcover_"
    return colorOrGrey + lastTwo
}














