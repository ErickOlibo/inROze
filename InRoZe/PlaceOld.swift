//
//  Place.swift
//  InRoZe
//
//  Created by Erick Olibo on 03/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation

// Container to hold data about a Facebook place

public struct PlaceOld: CustomStringConvertible
{
    public let placeID: String
    public let name: String
    public let city: String
    public let country: String
    public let countryCode: String
    public let street: String
    public let latitude: Double
    public let longitude: Double
    
    
    public var description: String { return "\(name) - \(city) - \(country)" }
    
    
    
    // MARK: - Internal Implementation
    
    init?(data: NSDictionary?) {
        guard
            let placeID = data?.string(forKeyPath: PlaceKey.placeID),
            let name = data?.string(forKeyPath: PlaceKey.name),
            let city = data?.string(forKeyPath: PlaceKey.city),
            let country = data?.string(forKeyPath: PlaceKey.country)
            else {
                return nil
        }
        
        self.placeID = placeID
        self.name = name
        self.city = city
        self.country = country
        self.countryCode = data?.string(forKeyPath: PlaceKey.countryCode) ?? ""
        self.street = data?.string(forKeyPath: PlaceKey.street) ?? ""
        self.latitude = data?.double(forKeyPath: PlaceKey.latitude) ?? 0.0
        self.longitude = data?.double(forKeyPath: PlaceKey.longitude) ?? 0.0
        
        
    }
    
    var asPropertyList: [String:String] {
        return [
            PlaceKey.placeID : placeID,
            PlaceKey.name : name,
            PlaceKey.city : city,
            PlaceKey.country : country,
            PlaceKey.countryCode : countryCode,
            PlaceKey.street : street,
            PlaceKey.latitude : String(latitude),
            PlaceKey.longitude : String(longitude)
        ]
    }
    
    // places from InRoze Dataase so Key must be columns
    struct PlaceKey {
        static let placeID = "place_id"
        static let name = "name"
        static let city = "city"
        static let country = "country"
        static let countryCode = "country_code"
        static let street = "street"
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
    
}
