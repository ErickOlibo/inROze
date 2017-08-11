//
//  FacebookKeyStringConvenience.swift
//  InRoZe
//
//  Created by Erick Olibo on 10/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation

/* Contains the conveniences structs for querying Facebook
 * Graph API. if labels are changing then update these structs
 */

public struct FBEvent {
    static let id = "id"                    // (Type: numeric string)
    static let cover = "cover"              // (Type: CoverPhoto)
    static let descript = "description"     // (Type: string)
    static let endTime = "end_time"         // (Type: datetime string)
    static let name = "name"                // (Type: string)
    static let place = "place"              // (Type: Place)
    static let startTime = "start_time"     // (Type: datetime string)
    static let updatedTime = "updated_time" // (Type: datetime string)
    static let placeDeep = "place.fields(name, id, location)"
    static let coverDeep = "cover.fields(id, source)"
}


public struct FBPlace {
    static let id = "id"                    // (Type: numeric string)
    static let location = "location"        // (Type: Location)
    static let name = "name"                // (Type: string)

}


public struct FBCoverPhoto {
    static let id = "id"                    // (Type: numeric string)
    static let source = "source"            // (Type: string - direct URL)
}


public struct FBLocation {
    static let city = "city"                // (Type: string)
    static let country = "country"          // (Type: string)
    static let countryCode = "country_code" // (Type: string)
    static let latitude = "latitude"        // (Type: float)
    static let longitude = "longitude"      // (Type: float)
    static let street = "street"            // (Type: string)
    static let zip = "zip"                  // (Type: string)
}


public struct FBUser {
    static let id = "id"                    // (Type: numeric string)
    static let email = "email"              // (Type: string)
    static let firstName = "first_name"     // (Type: string)
    static let lastName = "last_name"       // (Type: string)
    static let name = "name"                // (Type: string)
    static let gender = "gender"            // (Type: string)
    static let cover = "cover"              // (Type: CoverPhoto)
}
