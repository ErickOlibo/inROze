//
//  Event.swift
//  InRoZe
//
//  Created by Erick Olibo on 09/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData

public class Event: NSManagedObject
{
    
    // Find or insert eventID to the Database
    // update placeID if eventID already present
    class func findOrInsertEventID(matching eventDict: [String : String], in context: NSManagedObjectContext) throws -> Event
    {
        //print(eventDict)
        if let artistsList = eventDict[DBLabels.artistsList] {
        print("[\(eventDict[DBLabels.eventID]!)] - ArtistList: [\(artistsList)]")
        }
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", eventDict[DBLabels.eventID]!)
        do {
            
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "findOrInsertEventID -- database inconsistency")
                //update artists for eventID -> remove all then add new
                return match[0]
            }
        } catch {
            throw error
        }
        // add artists to new event
        

        let event = Event(context: context)
        event.id = eventDict[DBLabels.eventID]
        do {
        event.location = try Place.findOrInsertPlaceID(matching: eventDict, in: context)
        } catch {
            print("[Event] - Error findOrInsertEventID TO Location: \(error)")
        }
        return event
    }
    
    
    class func addArtistsListToEvent(with eventDict: [String : String], in context: NSManagedObjectContext) throws -> Bool {
        let id = eventDict[DBLabels.eventID]!
        let artistsListArr = eventDict[DBLabels.artistsList]!.components(separatedBy: ", ")
        var artsArr = [Artist]()
        
        for artistID in artistsListArr {
            do {
                if let match = try Artist.findArtistWith(id: artistID, in: context) {
                    artsArr.append(match)
                }
            } catch {
                throw error
            }
        }
        
        let artsNSSet = NSSet(array: artsArr)
        
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "addArtistsListToEvent -- database inconsistency")
                let event = match[0]
                event.performers = artsNSSet
                //print("[\(id)] - event.performers: [\(event.performers!)]")
                return true
            }
        } catch {
            throw error
        }
       
        return false
    }
    
    
    class func updateArtistsListForEvent(with eventDict: [String : String], in context: NSManagedObjectContext) throws -> Bool {
        let id = eventDict[DBLabels.eventID]!
        do {
            let _ = try removeAllArtistsFromEvent(id: id, in: context)
            let _ = try addArtistsListToEvent(with: eventDict, in: context)
        } catch {
            throw error
        }
        
        
        return true
    }
    
    class func removeAllArtistsFromEvent(id: String, in context: NSManagedObjectContext) throws -> Bool {
        // look for artist that are in EventID and set event to nil
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "removeAllArtistsFromEvent -- database inconsistency")
                let event = match[0]
                event.performers = nil
                return true
            }
        } catch {
            throw error
        }
        return false
    }
    
    
    
    
    // Update eventID missing attributes
    class func updateInfoForEvent(matching eventID: (key: String, value: Any), in context: NSManagedObjectContext, with request: NSFetchRequest<Event>) throws -> Bool
    {
        request.predicate = NSPredicate(format: "id = %@", eventID.key)
        
        do {
            let events = try context.fetch(request)
            if events.count > 0 {
                assert(events.count == 1, "Inconsistency: unique event identifier is duplicate")
                
                let event = events[0]
                
                if let eventInfo = eventID.value as? [String : Any] {
                    
                    if let name = eventInfo[FBEvent.name] as? String,
                        let sTime = eventInfo[FBEvent.startTime] as? String,
                        let uTime = eventInfo[FBEvent.updatedTime] as? String {
                        
                        event.name = name
                        
//                        if let descript = uniqID["description"] as? String {
//                            let pDesc = descript.utf16
//                            print("************************ DataToString: \(pDesc)")
//                        }
                        
                        if let eventText = eventInfo[FBEvent.description] as? String {
                            event.text = eventText
                        }
                        
                        if let cover = eventInfo[FBEvent.cover] as? [String : Any],
                            let coverSource = cover[FBPhoto.source] as? String,
                            let coverID = cover[FBPhoto.id] as? String {
                            event.offsetX = cover[FBPhoto.offsetX] as? Float ?? 0.0
                            event.offsetY = cover[FBPhoto.offsetY] as? Float ?? 0.0
                            event.imageID = coverID
                            event.imageURL = coverSource
                        }
                        
                        // Formatting DateTime
                        let formatter = ISO8601DateFormatter()
                        event.startTime = formatter.date(from: sTime)! as NSDate
                        event.updatedTime = formatter.date(from: uTime)! as NSDate
                        
                        // If end_time is nil (from FB request) add default: +12 hours of Start_time
                        if let eTime = eventInfo[FBEvent.endTime] as? String {
                            event.endTime = formatter.date(from: eTime)! as NSDate
                        } else {
                            event.endTime = (formatter.date(from: sTime)! as NSDate).addingTimeInterval(12 * 60 * 60)
                        }
                        
                        // updating Location ralationship for eventID
                        if let eventPlace = eventInfo[FBEvent.place] as? [String : Any] {
                            do {
                                if let location = try Place.updatePlaceInfoForEvent(with: eventPlace, in: context){
                                   event.location = location
                                }
                            } catch {
                                print("[Event] - EVENT To Location Error: \(error)")
                            }
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
    // ADD the LOCATION (city or country) selector as a parameter
    // of the FUNC. Revise when several Cities are implemented
    class func eventsStartingAfterNow(in context: NSManagedObjectContext) -> [Event]
    {
        var response = [Event]()
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        let nowTime = NSDate()
        request.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true, selector: nil)]
        request.predicate = NSPredicate(format: "startTime > %@ AND imageURL != nil", nowTime)
        
        do {
            let events = try context.fetch(request)
            if events.count > 0 {
                response = events
            }
        } catch {
            print("[Event] - eventsStartingAfterNow ERROR: \(error)")
        }
        return response
    }
    
    
    // update event with ImageColors
    class func updateEventImageColors(with id: String, and colors: ColorsInHexString, in context: NSManagedObjectContext) -> Bool
    {
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "EventID is not unique in the database")
                let event = match[0]
                event.background = colors.background
                event.primary = colors.primary
                event.secondary = colors.secondary
                event.detail = colors.detail
                
            }
        } catch {
            print("[Event] - UpdateEventImageColors failed with error: \(error)")
        }
        
        
        
        return true
    }
    
    
    
    // Deletes older (where endTime < NOW) from the database
    class func deleteEventsEndedBeforeNow(in context: NSManagedObjectContext, with request: NSFetchRequest<Event>) -> Bool
    {
        //var response = [Event]()
        let nowTime = NSDate()
        request.sortDescriptors = [NSSortDescriptor(key: "endTime", ascending: true, selector: nil)]
        request.predicate = NSPredicate(format: "endTime < %@", nowTime)
        
        do {
            let events = try context.fetch(request)
            if events.count > 0 {
                for event in events {
                    // to make sure events are being deleted
                    print("[DELETE_EVENT] -> EndTime: [\(event.endTime!)] | Name: \(event.name!) | Place: \(event.location!.name!)")
                    context.delete(event)
                }
            }
        } catch {
            print("[Event] - deleteEventsEndedBeforeNow: \(error)")
        }
        
        return true
    }
    
    
}













