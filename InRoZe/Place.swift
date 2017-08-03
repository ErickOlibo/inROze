//
//  Place.swift
//  InRoZe
//
//  Created by Erick Olibo on 03/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation

// Container to hold data about a Facebook place

public struct Place: CustomStringConvertible
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
            let placeID = data?.string(forKeyPath: FBplaceKey.placeID),
            let name = data?.string(forKeyPath: FBplaceKey.name),
            let city = data?.string(forKeyPath: FBplaceKey.city),
            let country = data?.string(forKeyPath: FBplaceKey.country)
            else {
                return nil
        }
        
        self.placeID = placeID
        self.name = name
        self.city = city
        self.country = country
        self.countryCode = data?.string(forKeyPath: FBplaceKey.countryCode) ?? ""
        self.street = data?.string(forKeyPath: FBplaceKey.street) ?? ""
        self.latitude = data?.double(forKeyPath: FBplaceKey.latitude) ?? 0.0
        self.longitude = data?.double(forKeyPath: FBplaceKey.longitude) ?? 0.0
        
        
    }
    
    var asPropertyList: [String:String] {
        return [
            FBplaceKey.placeID : placeID,
            FBplaceKey.name : name,
            FBplaceKey.city : city,
            FBplaceKey.country : country,
            FBplaceKey.countryCode : countryCode,
            FBplaceKey.street : street,
            FBplaceKey.latitude : String(latitude),
            FBplaceKey.longitude : String(longitude)
        ]
    }
    
    struct FBplaceKey {
        static let placeID = "id"
        static let name = "name"
        static let city = "city"
        static let country = "country"
        static let countryCode = "country_code"
        static let street = "street"
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
    
}
