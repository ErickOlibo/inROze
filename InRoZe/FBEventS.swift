//
//  FBEventS.swift
//  InRoZe
//
//  Created by Erick Olibo on 29/07/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation

public struct FBEventS: CustomStringConvertible {
    public var events: [FBEvent]
    public var description: String {return "size: \(events.count) and location: \(events[0])"}
    
    init(size: Int) {
        events = makeArray(repeating: FBEvent(), numberOfTimes: size)
        
    }
}
