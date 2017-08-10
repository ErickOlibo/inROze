//
//  ServerKeyStringConvenience.swift
//  InRoZe
//
//  Created by Erick Olibo on 10/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation

/* Contains the conveniences structs for querying the InRoze Server
 * if labels are changing then update these structs
 */


// URLs to connect to the Server
public struct UrlFor {
    static let logInOut = "https://www.defkut.com/inroze/ServerRoze/users.php";
    static let currentEventsID = "https://www.defkut.com/inroze/ServerRoze/currentEvents.php";
}


// Fields name from the Server Database Columns
public struct DBLabels {
    static let eventID = "event_id"
    static let placeID = "place_id"
    static let responseKey = "eventPlaceIDs"
}
