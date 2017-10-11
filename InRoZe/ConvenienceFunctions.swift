//
//  ConvenienceFunctions.swift
//  InRoZe
//
//  Created by Erick Olibo on 28/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation


// Format the event day, time, and location to Attributed text for cell subtitle
// returns a Attributed string
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
