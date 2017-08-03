//
//  Event.swift
//  InRoZe
//
//  Created by Erick Olibo on 03/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation

// container to hold data about a Facebook event
// Set the Colors pattern at the cell level

public struct Event: CustomStringConvertible
{
    public let eventID: String
    public let placeID: String
    public let place: Place
    public let name: String
    public let startTime: String // DateTime format as string
    public let endTime: String // DateTime format as string
    public let updatedTime: String // DateTime format as string
    public let eventText: String
    public let coverURL: URL?
    
    public var description: String {
        return "\(name) | \(place) | ID: \(eventID)"
    }
    
    // MARK: - Internal Implementation
    
    init?(data: NSDictionary?) {
        guard
            let eventID = data?.string(forKeyPath: EventKey.eventID),
            let placeID = data?.string(forKeyPath: EventKey.placeID),
            let place = Place(data: data?.dictionary(forKeyPath: EventKey.place)),
            let name = data?.string(forKeyPath: EventKey.name),
            let startTime = data?.string(forKeyPath: EventKey.startTime)
            else {
                return nil
        }
        
        self.eventID = eventID
        self.placeID = placeID
        self.place = place
        self.name = name
        self.startTime = startTime
        self.endTime = data?.string(forKeyPath: EventKey.endTime) ?? "" //not real String (ATTENTION)
        self.updatedTime = data?.string(forKeyPath: EventKey.updatedTime) ?? "" // not real String (ATTENTION)
        self.eventText = data?.string(forKeyPath: EventKey.eventText) ?? ""
        self.coverURL = data?.url(forKeyPath: EventKey.coverURL)

        
    }
    
    
    
    
    // Events info from InRoZe server so Keys must be columns
    struct EventKey {
        static let eventID = "event_id"
        static let placeID = "place_id"
        static let place = "place" // make dictionary of dictionary label is correct
        static let name = "name"
        static let startTime = "start_time"
        static let endTime = "end_time"
        static let updatedTime = "updated_time"
        static let eventText = "description"
        static let coverURL = "cover_url" //cover.source from FB what's on the server??
    }
    
    
    
}
