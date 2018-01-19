//
//  Place.swift
//  InRoZe
//
//  Created by Erick Olibo on 09/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData
import Foundation

public class Place: NSManagedObject
{

    class func insertOrUpdatePlace(with eventDict: [String : String], in context: NSManagedObjectContext) throws -> Place
    {
        let request: NSFetchRequest<Place> = Place.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", eventDict[DBLabels.placeID]!)
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "findOrInsertPlaceID -- database inconsistency")
                let place = match[0]
                place.city = eventDict[DBLabels.placeCity]
                place.country = eventDict[DBLabels.placeCountry]
                place.countryCode = eventDict[DBLabels.placeCountryCode]
                place.name = eventDict[DBLabels.placeName]
                place.profileURL = eventDict[DBLabels.placeProfileURL]
                place.street = eventDict[DBLabels.placeStreet]
                guard let latitude = eventDict[DBLabels.placeLatitude] else { return place }
                guard let longitude = eventDict[DBLabels.placeLongitude] else { return place }
                place.latitude = Float(latitude) ?? 0.0
                place.longitude = Float(longitude) ?? 0.0
                //print("UPDATE PLACE -> INFO [\(place.city!)] -  [\(place.country!)] - [\(place.countryCode!)] - [\(place.name!)] - [\(place.street!)] - [\(place.latitude)] - [\(place.longitude)] ")
                return place
            }
        } catch {
            throw error
        }
        
        let place = Place(context: context)
        place.id = eventDict[DBLabels.placeID]
        place.city = eventDict[DBLabels.placeCity]
        place.country = eventDict[DBLabels.placeCountry]
        place.countryCode = eventDict[DBLabels.placeCountryCode]
        place.name = eventDict[DBLabels.placeName]
        place.profileURL = eventDict[DBLabels.placeProfileURL]
        place.street = eventDict[DBLabels.placeStreet]
        guard let latitude = eventDict[DBLabels.placeLatitude] else { return place }
        guard let longitude = eventDict[DBLabels.placeLongitude] else { return place }
        place.latitude = Float(latitude) ?? 0.0
        place.longitude = Float(longitude) ?? 0.0
        //print("INSERT PLACE -> INFO [\(place.city!)] -  [\(place.country!)] - [\(place.countryCode!)] - [\(place.name!)] - [\(place.street!)] - [\(place.latitude)] - [\(place.longitude)] ")
        return place
    }
    
    
    // Updates of Places from Facebook query
    class func updatePlaceInfoForFaceBookEvent(with eventPlace: [String : Any], in context: NSManagedObjectContext) throws -> Place?
    {
        let request: NSFetchRequest<Place> = Place.fetchRequest()
        if let pID = eventPlace[FBPlace.id] as? String {
            request.predicate = NSPredicate(format: "id = %@", pID)
        } else {
            print("PlaceID from EventPlace Dict: NULL")
        }
        
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "inconsistency: unique place identifier is duplicate")
                let place = match[0]
                let placeName = eventPlace[FBPlace.name] as? String ?? ""
                if (place.name != placeName) {
                    place.name = placeName
                    if let location = eventPlace[FBPlace.location] as? [String : Any] {
                        place.city = location[FBLocation.city] as? String ?? ""
                        place.country = location[FBLocation.country] as? String ?? ""
                        place.street = location[FBLocation.street] as? String ?? ""
                        place.latitude = location[FBLocation.latitude] as? Float ?? 0.0
                        place.longitude = location[FBLocation.longitude] as? Float ?? 0.0
                    }
                }
                return place
            }
            
        } catch {
            throw error
        }
        
        return nil
    }
   
}

