//
//  Place.swift
//  InRoZe
//
//  Created by Erick Olibo on 09/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData

class Place: NSManagedObject
{

    // Find or insert eventID to the Database
    // update placeID if eventID already present
    class func findOrInsertPlaceID(matching eventDict: [String : String], in context: NSManagedObjectContext) throws -> Place
    {
        
        let request: NSFetchRequest<Place> = Place.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", eventDict[DBLabels.placeID]!)
        do {
            
            let match = try context.fetch(request)
            if match.count > 0 {
                print("MATCH Place) --> findOrInsertPlaceID")
                assert(match.count == 1, "findOrInsertEventID -- database inconsistency")
                return match[0]
            }
        } catch {
            throw error
        }
        
        print("NEW Place) --> findOrInsertPlaceID")
        let place = Place(context: context)
        place.id = eventDict[DBLabels.placeID]
        return place
    }
    
    
    
}
