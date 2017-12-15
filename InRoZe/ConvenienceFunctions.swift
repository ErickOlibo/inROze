//
//  ConvenienceFunctions.swift
//  InRoZe
//
//  Created by Erick Olibo on 28/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation
import UIKit


// This method return the right profile picture URL (as String) for an artist
// depending on which URL is available by order of preference.
// 1) The MixCloud URL if NOT NULL
// 2) The FaceBook URL if NOT NULL
// 3) The Default URL if above are null

public func preferedProfilePictureURL(for artist: Artist) -> String? {

    if let mixURL = artist.picMixURL { return mixURL }
    if let fbURL = artist.picFbURL { return fbURL }
    if let defaultURL = artist.picDefaultURL { return defaultURL }
    return nil
}


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



// Get two strings, font names and 2 sizes
// and returns an attributed text formatted in 2 line with
public func twoLinesFormatter(withTwoString twoStrings: (first: String, second: String), fontNames: (first: String, second: String), fontSizes: (first: CGFloat, second: CGFloat), fontColors: (first: UIColor, second: UIColor) ) -> NSAttributedString {
    
    let twoLinesFormatted = NSMutableAttributedString()
    let lineOne = twoStrings.first + "\n"
    let lineTwo = twoStrings.second
    let attributeOne = [ NSAttributedStringKey.font: UIFont(name: fontNames.first, size: fontSizes.first)! ]
    let attributeTwo = [ NSAttributedStringKey.font: UIFont(name: fontNames.second, size: fontSizes.second)! ]
    let attrLineOne = NSAttributedString(string: lineOne, attributes: attributeOne)
    let attrLineTwo = NSAttributedString(string: lineTwo, attributes: attributeTwo)
    twoLinesFormatted.append(color(attributedString: attrLineOne, color: fontColors.first))
    twoLinesFormatted.append(color(attributedString: attrLineTwo, color: fontColors.second))
    
    return twoLinesFormatted
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














