//
//  FBEventSOld.swift
//  InRoZe
//
//  Created by Erick Olibo on 29/07/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation

public struct FBEventSOld: CustomStringConvertible {
    public var events: [FBEventOld]
    public var description: String {return "size: \(events.count) and location: \(events[0])"}
    
    init(size: Int) {
        events = [FBEventOld]()
        for _ in 0..<size {
            let event = FBEventOld()
            events.append(event)
        }
        
    }
}
