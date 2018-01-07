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

// NEED TO REWRITE ALL USING A CLASS OR Struct
// Struct init with CityName, CityCode, CountryName, CountryCode, Nationality


// URLs to connect to the Server
public struct UrlFor {
    static let logInOut = "https://www.defkut.com/inroze/ServerRoze/users.php"
    static let currentEventsID = "https://www.defkut.com/inroze/ServerRoze/currentEvents.php"
    static let facebook = "https://www.facebook.com/"
    static let mixcloud = "https://www.mixcloud.com/"
    
    // URL for About in the Setting section
    static let aboutInroze = "https://www.pipedrive.com/en/about"
    static let aboutTerms = "https://www.meetagainapp.com/terms_and_conditions.html"
    static let aboutPrivacy = "https://www.mixcloud.com/hurmet/makmorr-januar-2010-mix/"
    
    //"https://www.mixcloud.com/ivonaries7/midsummer-bling-2017-landing-mix/"
    static let aboutSources = "https://api.mixcloud.com/hurmet/makmorr-januar-2010-mix/embed-html/?height=600&color=D23900"
    
    
    //"https://soundcloud.com/defkut/ice-cream-remix-defkut-feat-wu"
}

// Fields name from the Server Database Columns
public struct DBLabels {
    static let eventID = "event_id"
    static let placeID = "place_id"
    static let createdTime = "created_time"
    static let placeCountryCode = "country_code"
    static let artistsList = "artists_list"
    static let cityCode =  "cityCode"
    static let errorType = "error"
    static let eventIsActive = "is_active"
    static let rows = "rows"
    static let profileURL = "profile_url"
    
    static let eventsToPlaces = "eventsToPlaces"
    static let artistsOfEvents = "artistsOfEvents"
    static let upToDateArtistsList = "upToDateArtistsList"
    static let mixtapesList = "mixtapesList"
    
    // for the Artist info fields
    static let artistID = "artist_id"
    static let artistName = "name"
    static let artistType = "type"
    static let artistCountry = "country"
    static let artistCountryCode = "country_code"
    static let artistFbPicURL = "fbpic_url"
    static let artistMcPicURL = "mcpic_url"
    static let artistDfPicURL = "dfpic_url"
    static let artistFbCoverURL = "fbcover_url"
    static let artistMcCoverURL = "mccover_url"
    static let artistDfCoverURL = "dfcover_url"
    static let artistNameMC = "name_mc"
    static let artistFbPageID = "fbpage_id"
    
    // for the Mixtape fields from Server
    static let mixID = "mix_id"
    static let mixCoverURL = "cover_url"
    static let mixC320URL = "cover320_url"
    static let mixC640URL = "cover640_url"
    static let mixC768URL = "cover768_url"
    static let mixC1024URL = "cover1024_url"
    static let mixName = "name"
    static let mixLength = "length"
    static let mixCreatedTime = "created_time"
    static let mixURL = "mix_url"
    static let mixTag1 = "tag_1"
    static let mixTag2 = "tag_2"
    static let mixTag3 = "tag_3"
    static let mixTag4 = "tag_4"
    static let mixTag5 = "tag_5"
    static let mixIsActive = "is_active"
    static let mixStreamURL = "stream_url"
    
}


// Session Type for taskForURLSeesion to Server
public struct SessionType {
    static let user = "user"
    static let events = "events"
    static let artists = "artists"
}



public struct RequestDate {
    static let toFacebook = "RequestDateToFacebook\(currentCity.code.rawValue)"
    static let toServer = "RequestDateToServer\(currentCity.code.rawValue)"
    static let toServerArtist = "RequestDateToServer\(currentCity.countryCode.rawValue)"
    
}


public struct IntervalBetweenRequest {
    static let toFacebook = TimeInterval(10 * 60 ) // 5 mins before new update from Facebook Graph API
    static let toServer = TimeInterval(1 * 10) // 1 min before collecting new eventIDS / Artist from server
    //static let toServerArtist = TimeInterval(2 * 60 * 60) // (1 min for test) 8 hours
}






