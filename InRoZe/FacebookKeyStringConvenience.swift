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

// Event convenience struct keys for string label from Facebook fetch
public struct FBEvent {
    static let id = "id"                    // (Type: numeric string)
    static let cover = "cover"              // (Type: CoverPhoto)
    static let descript = "description"     // (Type: string)
    static let endTime = "end_time"         // (Type: datetime string)
    static let name = "name"                // (Type: string)
    static let place = "place"              // (Type: Place)
    static let startTime = "start_time"     // (Type: datetime string)
    static let updatedTime = "updated_time" // (Type: datetime string)
}


// Place convenience struct label for string label from Fecebook fetch
public struct FBPlace {
    static let id = "id"
    static let name = "name"
    static let city = "city"
    static let country = "country"
    static let countryCode = "country_code"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let street = "street"
}


public struct FBCoverPhoto {
    static let id = "id" // (Type: numeric string)
    static let source = "source" // (Type: string - direct URL)
}


public struct FBlocation {
    
}
