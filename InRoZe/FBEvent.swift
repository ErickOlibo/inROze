//
//  FBEvent.swift
//  InRoZe
//
//  Created by Erick Olibo on 29/07/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation

// container to hold data about a Facebook Event

public struct FBEvent: CustomStringConvertible {
    
    public let name: String
    public let cover: String
    public let location: String
    public let fee: String
    public let date = FacebookEvents.getEventDate()
    public var colors: UIImageColors?
    
    public var description: String {
        let bgColor = colors?.background
        if  bgColor != nil {
            return "name: \(name) | location: \(location) | color back: \(bgColor!)"
        } else {
        return "name: \(name) | location: \(location) | color back: NO Color"
        }
    }
    
    init() {
        let rdm = Int(arc4random_uniform(10))
        self.name = FacebookEvents.eventNameArray[rdm]
        self.cover = FacebookEvents.eventCoverArray[rdm]
        self.location = FacebookEvents.eventLocationArray[rdm]
        self.fee = FacebookEvents.eventFeeArray[rdm]
        
    }
    
}
