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
    static let logInOut = "https://www.defkut.com/inroze/ServerRoze/users.php"
    static let currentEventsID = "https://www.defkut.com/inroze/ServerRoze/currentEvents.php"
    static let artistsTable = "https://www.defkut.com/inroze/ServerRoze/getArtistsList.php"
}


// Fields name from the Server Database Columns
public struct DBLabels {
    static let eventID = "event_id"
    static let placeID = "place_id"
    static let placeCountryCode = "country_code"
    static let artistsList = "artists_list"
    static let cityCode =  "cityCode"
    static let errorType = "error"
    static let rows = "rows"
    static let profileURL = "profile_url"
    
    static let eventsToPlaces = "eventsToPlaces"
    static let artistsOfEvents = "artistsOfEvents"
    static let upToDateArtistsList = "upToDateArtistsList"
    
    // for the Artist info fields
    static let artistID = "artist_id"
    static let artistName = "name"
    static let artistType = "type"
    static let artistCountry = "country"
    static let artistCountryCode = "country_code"
    
}

// List of cities available
private struct AvailableCities {
    static let list = ["Tallinn", "Helsinki", "Stockholm", "Riga", "Brussels"]
    
}

public func availableCities() -> [String] {
    let cities = AvailableCities.list
    return cities.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
}


// cityCode requirement for loading right eventIDs
public struct CityCode {
    static let tallinn = "TLN"
    static let stockholm = "STO"
    static let helsinki = "HEL"
    static let riga = "RIG"
    static let brussels = "BRU"
    static let none = "NONE"
}

// countryCode keyString
public struct CountryCode {
    static let estonia = "EE"
    static let finland = "FI"
    static let sweden = "SE"
    static let latvia = "LV"
    static let belgium = "BE"
    
}


// Session Type for taskForURLSeesion to Server
public struct SessionType {
    static let user = "user"
    static let events = "events"
    static let artists = "artists"
}



public struct RequestDate {
    static let toFacebook = "RequestDateToFacebook\(UserDefaults().currentCityCode)"
    static let toServer = "RequestDateToServer\(UserDefaults().currentCityCode)"
    static let toServerArtist = "RequestDateToServer\(UserDefaults().currentCountryCode)"
    
}


public struct IntervalBetweenRequest {
    static let toFacebook = TimeInterval(1 * 60) // 1 hour before new update from Facebook Graph API
    static let toServer = TimeInterval(1 * 10) // (3 mins for test)3 hours before collecting new eventIDS from server
    static let toServerArtist = TimeInterval(1 * 60) // (1 min for test) 24 hours
}

public struct UserKeys {
    static let cityCode = "cityCode"
    static let countryCode = "countryCode"
}


public func countryCodeFrom(cityCode: String) -> String {
    
    switch cityCode.uppercased() {
    case CityCode.tallinn:
        return CountryCode.estonia
    case CityCode.helsinki:
        return CountryCode.finland
    case CityCode.stockholm:
        return CountryCode.sweden
    case CityCode.riga:
        return CountryCode.latvia
    case CityCode.brussels:
        return CountryCode.belgium
        
    default:
        return CountryCode.estonia
    }
}


