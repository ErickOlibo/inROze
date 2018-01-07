//
//  FollowsItem.swift
//  InRoZe
//
//  Created by Erick Olibo on 07/01/2018.
//  Copyright © 2018 Erick Olibo. All rights reserved.
//

import Foundation

public class FollowsItem
{
    let event: Event?
    let mixtape: Mixtape?
    var createdTime: Date?
    var isEvent: Bool
    
    init(event: Event?, mixtape: Mixtape?) {
        self.event = event
        self.mixtape = mixtape
        self.createdTime = Date()
        self.isEvent = false
        
        if (event != nil) {
            guard let createdTime = event?.createdTime else { return }
            self.createdTime = createdTime
            self.isEvent = true
        } else {
            guard let createdTime = mixtape?.createdTime else { return }
            self.createdTime = createdTime
            self.isEvent = false
        }
    }
    
}


