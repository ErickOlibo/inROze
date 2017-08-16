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
    static let eventEventIDs = "eventEventIDs"
    static let cityCode =  "cityCode"
    static let errorType = "error"
    static let rows = "rows"
}

// cityCode requirement for loading right eventIDs
public struct CityCode {
    static let tallinn = "TLN"
    static let stockholm = "STO"
    static let helsinki = "HEL"
    static let riga = "RIG"
    static let brussels = "BRU"
}
