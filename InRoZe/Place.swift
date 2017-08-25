//
//  Place.swift
//  InRoZe
//
//  Created by Erick Olibo on 09/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData

public class Place: NSManagedObject
{
    // Find or insert eventID to the Database
    // update placeID if eventID already present
    class func findOrInsertPlaceID(matching eventDict: [String : Any], in context: NSManagedObjectContext) throws -> Place
    {
        
        
        let request: NSFetchRequest<Place> = Place.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", eventDict[DBLabels.placeID] as! String)
        do {
            
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "findOrInsertEventID -- database inconsistency")
                return match[0]
            }
        } catch {
            throw error
        }
        let place = Place(context: context)
        place.id = eventDict[DBLabels.placeID]! as? String
        return place
    }
    
    
    // Update PlaceID missing attributes
    class func updatePlaceInfoForEvent(with eventPlace: [String : Any], in context: NSManagedObjectContext) throws -> Place
    {
        
        var place = Place()
        let request: NSFetchRequest<Place> = Place.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", eventPlace[FBPlace.id] as! String)
        
        do {
            var places = try context.fetch(request)
            if places.count > 0 {
                assert(places.count == 1, "inconsistency: unique place identifier is duplicate")
                place = places[0]
                let placeName = eventPlace[FBPlace.name] as? String ?? ""
                if (place.name == placeName) {
                    print("NO UPDATE NEEDED -> PLACE ALREADY IN DATA")
                    return place
                } else {
                    print("UPDATE NEEDED -> PLACE NAME HAS CHANGED")
                    place.name = placeName
                    if let location = eventPlace[FBPlace.location] as? [String : Any] {
                        place.city = location[FBLocation.city] as? String ?? ""
                        place.country = location[FBLocation.country] as? String ?? ""
                        place.street = location[FBLocation.street] as? String ?? ""
                        place.latitude = location[FBLocation.latitude] as? Float ?? 0.0
                        place.longitude = location[FBLocation.longitude] as? Float ?? 0.0
                        
                    }
                }
            }
        } catch {
            throw error
        }
       return place
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

