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
    static let logInOut = "https://www.inroze.com/ServerRoze/users.php"
    static let currentEventsID = "https://www.inroze.com/ServerRoze/currentEvents.php"
    static let updateSuccess = "https://www.inroze.com/ServerRoze/UpdateSuccess.php"
    static let facebook = "https://www.facebook.com/"
    static let mixcloud = "https://www.mixcloud.com/"
    
    // Default link to website folder for settings information
    static let webLink = "https://inroze.com/webROze/"
    
    // URL for Location/Support/About/ in the Setting section
    static let locationMissing = UrlFor.webLink + "missing.html"
    static let supportFAQ = UrlFor.webLink + "frequently.html"
    static let supportFeedback = UrlFor.webLink + "feedback.html"
    static let aboutInroze = UrlFor.webLink + "about-inroze.html"
    static let aboutTerms =  UrlFor.webLink + "terms.html"
    static let aboutPrivacy = UrlFor.webLink + "privacy.html"
    static let aboutSources = UrlFor.webLink + "open-source.html"

}

// SERVER response fields name
public struct DBLabels {
    
    // For the EVENT info fields from the Server
    static let artistsList = "artists_list"
    static let eventID = "event_id"
    static let placeID = "place_id"
    static let eventStartTime = "start_time"
    static let eventEndTime = "end_time"
    static let eventName = "event_name"
    static let eventCityCode = "event_city_code"
    static let eventCoverURL = "cover_url"
    static let eventCreatedTime = "created_time"
    static let eventUpdatedTime = "updated_time"
    static let eventIsActive = "is_active"
    
    // for the PLACE info fields from the server
    static let placeName = "place_name"
    static let placeCity = "city"
    static let placeCityCode = "city_code"
    static let placeCountry = "country"
    static let placeCountryCode = "country_code"
    static let placeLatitude = "latitude"
    static let placeLongitude = "longitude"
    static let placeProfileURL = "profile_url"
    static let placeStreet = "street"
    
    
    
    
    // JSON Dictionary names from Server
    static let errorType = "error"
    static let message = "message"
    static let cityCode =  "cityCode"
    static let rows = "rows"
    static let eventsToPlaces = "eventsToPlaces"
    static let artistsOfEvents = "artistsOfEvents"
    static let upToDateArtistsList = "upToDateArtistsList"
    static let mixtapesList = "mixtapesList"
    
    // for the ARTIST info fields from Server
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
    
    // for the MIXTAPE info fields from Server
    static let mixID = "mix_id"
    static let mixCountryCode = "country_code"
    static let mixArtistID = "artist_id"
    static let mixC320URL = "cover320_url"
    static let mixC640URL = "cover640_url"
    static let mixC768URL = "cover768_url"
    static let mixC1024URL = "cover1024_url"
    static let mixName = "name"
    static let mixLength = "length"
    static let mixCreatedTime = "created_time"
    static let mixURL = "mix_url"
    static let mixStreamURL = "stream_url"
    static let mixTag1 = "tag_1"
    static let mixTag2 = "tag_2"
    static let mixTag3 = "tag_3"
    static let mixTag4 = "tag_4"
    static let mixTag5 = "tag_5"
    static let mixIsActive = "is_active"
    
    
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
    static let toFacebook = TimeInterval(333 * 60 * 60 ) // 5 mins before new update from Facebook Graph API
    static let toServer = TimeInterval(1 * 1) // 1 min before collecting new eventIDS / Artist from server
    //static let toServerArtist = TimeInterval(2 * 60 * 60) // (1 min for test) 8 hours
}






