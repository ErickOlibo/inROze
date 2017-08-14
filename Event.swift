//
//  Event.swift
//  InRoZe
//
//  Created by Erick Olibo on 09/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData

class Event: NSManagedObject
{
    // Find or insert eventID to the Database
    // update placeID if eventID already present
    class func findOrInsertEventID(matching eventDict: [String : String], in context: NSManagedObjectContext) throws -> Event
    {
        
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", eventDict[DBLabels.eventID]!)
        
        
        do {
            
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "findOrInsertEventID -- database inconsistency")
                return match[0]
            }
        } catch {
            throw error
        }

        let event = Event(context: context)
        event.id = eventDict[DBLabels.eventID]
        event.location = try? Place.findOrInsertPlaceID(matching: eventDict, in: context)
        return event
    }
    
    
    // Update eventID missing attributes
    class func updateInfoForEvent(matching eventID: (key: String, value: Any), in context: NSManagedObjectContext, with request: NSFetchRequest<Event>) throws -> Bool
    {
        request.predicate = NSPredicate(format: "id = %@", eventID.key)
        
        do {
            let events = try context.fetch(request)
            if events.count > 0 {
                assert(events.count == 1, "Inconsistency: unique event identifier, dublicate")
                
                // to move later as own function in Event.swift -> updateInfofor(arguments)
                let event = events[0]

                if let uniqID = eventID.value as? [String : Any] {
                    print(uniqID)
                    if let name = uniqID["name"] as? String,
                        let sTime = uniqID["start_time"] as? String,
                        let uTime = uniqID["updated_time"] as? String {
                        //print("Event Name: \(name)")
                        //print("Start Time: \(sTime)")
                        let formatter = ISO8601DateFormatter()
                        event.name = name
                        event.startTime = formatter.date(from: sTime)! as NSDate
                        print("StartTime after Conversion: \(event.startTime!)")
                        event.updatedTime = formatter.date(from: uTime)! as NSDate
                        if let eTime = uniqID["end_time"] as? String {
                            event.endTime = formatter.date(from: eTime)! as NSDate
                        } else {
                            event.endTime = (formatter.date(from: sTime)! as NSDate).addingTimeInterval(12 * 60 * 60)
                        }
                    }
                }
            }
        } catch {
            throw error
        }
        return true
    }
    
    
    // Select events where StartTime is after Now
    class func eventsStartingAfterNow(in context: NSManagedObjectContext) -> [Event] {
        var response = [Event]()
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        //request.predicate = NSPredicate(format: "startTime > %@", NSDate())
        
        do {
            let events = try context.fetch(request)
            if events.count > 0 {
                response = events
                
            }
            
        } catch {
            print("eventsStartingAfterNow ERROR: \(error)")
        }
        return response
    }
    
}













