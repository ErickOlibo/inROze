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

    if let mcURL = artist.mcPicURL { return mcURL }
    if let fbURL = artist.fbPicURL { return fbURL }
    if let dfURL = artist.dfPicURL { return dfURL }
    return nil
}

// This method return the right profile Cover URL (as String) for an artist
// depending on which URL is available by order of preference.
// 1) The FaceBook URL if NOT NULL
// 2) The MixCloud URL if NOT NULL
// 3) The Default URL if above are null

public func preferedProfileCoverURL(for artist: Artist) -> String? {
    
    if let fbURL = artist.fbCoverURL { return fbURL }
    if let mcURL = artist.mcCoverURL { return mcURL }
    if let dfURL = artist.dfCoverURL { return dfURL }
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

public func mixtapesDayLengthLabelFormatter(for mixtape: Mixtape) -> MixtapeAttributedInfo {
    var day = NSAttributedString(string: "")
    var time = NSAttributedString(string: "")
    let attributeOne = [ NSAttributedStringKey.font: UIFont(name: "FontAwesome", size: 18.0)! ]
    
    
    // Format the Created Time of the mix
    guard let createdTime = mixtape.createdTime else { return MixtapeAttributedInfo(mixDay: day, mixLength: time) }
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMM, yyyy"
    let separ = "  "
    day = NSAttributedString(string: formatter.string(from: createdTime))
    
    let iconCal = FAType.FACalendar.text! + separ
    let timeIcon = NSAttributedString(string: iconCal, attributes: attributeOne)
    let combined = NSMutableAttributedString()
    combined.append(color(attributedString: timeIcon, color: .black))
    combined.append(color(attributedString: day, color: .black))
    day = combined
    
    // format the length on the mix
    guard let length = mixtape.length, let lengthInt = Int(length) else { return MixtapeAttributedInfo(mixDay: day, mixLength: time) }
    let formatterL = DateComponentsFormatter()
    formatterL.allowedUnits = [.hour, .minute, .second]
    formatterL.unitsStyle = .abbreviated
    time = NSAttributedString(string: formatterL.string(from: TimeInterval(lengthInt))!)
    
    let iconLength = FAType.FAHeadphones.text! + separ
    let lengthIcon = NSAttributedString(string: iconLength, attributes: attributeOne)
    let combinedTwo = NSMutableAttributedString()
    combinedTwo.append(color(attributedString: lengthIcon, color: .black))
    combinedTwo.append(color(attributedString: time, color: .black))
    time = combinedTwo

    return  MixtapeAttributedInfo(mixDay: day, mixLength: time)
}



public struct MixtapeAttributedInfo {
    public var mixDay: NSAttributedString?
    public var mixLength: NSAttributedString?

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


// Get a string like integer and format it to a time like string
public func timeDuration(from length: String) -> String? {
    guard let lengthInt = Int(length) else { return nil }
    var str: String?
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.unitsStyle = .positional
    if (lengthInt < 60) {
        if (lengthInt < 10) {
           str = "0:0" + formatter.string(from: TimeInterval(lengthInt))!
            return str
        }
        str = "0:" + formatter.string(from: TimeInterval(lengthInt))!
        return str
    }
    return formatter.string(from: TimeInterval(lengthInt))
}












