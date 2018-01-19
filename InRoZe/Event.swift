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
    class func insertOrUpdateEvent(with eventDict: [String : String], in context: NSManagedObjectContext) throws -> Event
    {
        // Formatting DateTime
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", eventDict[DBLabels.eventID]!)
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "findOrInsertEventID -- database inconsistency")
                let thisEvent = match[0]
                
                let createdTime = eventDict[DBLabels.eventCreatedTime]
                thisEvent.createdTime = formatter.date(from: createdTime!)
                thisEvent.isActive = eventDict[DBLabels.eventIsActive] != nil ? true : false
                do {
                    thisEvent.location = try Place.insertOrUpdatePlace(with: eventDict, in: context)
                } catch {
                    print("[Event] - Error UPDATING findOrInsertEventID TO Location")
                }
                return thisEvent
            }
        } catch {
            throw error
        }

        let event = Event(context: context)
        event.id = eventDict[DBLabels.eventID]
        
        // Formatting DateTime
        let createdTime = eventDict[DBLabels.eventCreatedTime]
        event.createdTime = formatter.date(from: createdTime!)
        event.isActive = eventDict[DBLabels.eventIsActive] != nil ? true : false
        do {
        event.location = try Place.insertOrUpdatePlace(with: eventDict, in: context)
        } catch {
            print("[Event] - Error CREATING findOrInsertEventID TO Location")
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
                        event.text = eventInfo[FBEvent.description] as? String ?? "No Description!"
//                        if let eventText = eventInfo[FBEvent.description] as? String {
//                            event.text = eventText
//                        } else {
//                            event.text = "No Description!"
//                        }
                        
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
                        
                        // default time interval when endTime is nil or longer than 12 hours (same as SERVER)
                        let defaultInterval: Double = 12 * 60 * 60
                        
                        let startTimeDate = formatter.date(from: sTime)!
                        event.startTime = startTimeDate
                        event.updatedTime = formatter.date(from: uTime)!
                        //event.createdTime = event.updatedTime // TO ERASE AFTER
                        
                        // Set startDate as a time in string "YYYYMMdd" eample: 20171120 (2017 11 20 -> 2017 Nov 20)
                        let dayFormatter = DateFormatter()
                        dayFormatter.dateFormat = "YYYYMMdd"
                        event.startDay = dayFormatter.string(from: startTimeDate)
                        
                        if let eTime = eventInfo[FBEvent.endTime] as? String {
                            let endTimeDate = formatter.date(from: eTime)!
                            let diffEndStart = endTimeDate.timeIntervalSince(startTimeDate as Date)
                            
                            if (diffEndStart > TimeInterval(defaultInterval)) {
                                event.endTime = (formatter.date(from: sTime)!).addingTimeInterval(defaultInterval)
                            } else {
                                event.endTime = endTimeDate
                            }
                        } else {
                            event.endTime = (formatter.date(from: sTime)!).addingTimeInterval(defaultInterval)
                        }
                        
                        
                        // updating Location ralationship for eventID
                        if let eventPlace = eventInfo[FBEvent.place] as? [String : Any] {
                            do {
                                if let location = try Place.updatePlaceInfoForEvent(with: eventPlace, in: context){
                                   event.location = location
                                }
                            } catch {
                                print("[Event] - EVENT To Location Error")
                            }
                        }
                    }
                }
                
                // Delete event where endTime is older than now
                let nowTime = NSDate()
                if ((event.endTime! as Date) < (nowTime as Date)) {
                    //print("DELETE This Event: [\(event.name!)]")
                    context.delete(event)
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
            print("[Event] - eventsStartingAfterNow ERROR")
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
                event.colorBackground = colors.background
                event.colorPrimary = colors.primary
                event.colorSecondary = colors.secondary
                event.colorDetail = colors.detail
                
            }
        } catch {
            print("[Event] - UpdateEventImageColors failed with error")
        }
        return true
    }
    
    
    // Deletes older (where endTime < NOW) from the database
    class func deleteEventsEndedBeforeNow(in context: NSManagedObjectContext, with request: NSFetchRequest<Event>) -> Bool
    {
        let nowTime = NSDate()
        request.sortDescriptors = [NSSortDescriptor(key: "endTime", ascending: true, selector: nil)]
        request.predicate = NSPredicate(format: "endTime < %@", nowTime)
        
        do {
            let events = try context.fetch(request)
            if events.count > 0 {
                print("DELETE EVENTS ENDED Count: [\(events.count)]")
                for event in events {
                    context.delete(event)
                }
            }
        } catch {
            print("[Event] - deleteEventsEndedBeforeNow Error")
        }
        
        return true
    }
    
    // Delete Events with NO performers meaning Events.Performers.count = 0
    class func deleteEventsWithoutPerformers(in context: NSManagedObjectContext, with request: NSFetchRequest<Event>) -> Bool
    {
        request.predicate = NSPredicate(format: "performers.@count = 0")
        do {
            let events = try context.fetch(request)
            if events.count > 0 {
                print("Events Without Performers Count: [\(events.count)]")
                var rank = 0
                for event in events {
                    rank += 1
                    print("\(rank)) Event Name: \(event.name ?? "No Event Name")")
                    context.delete(event)
                }
            }
        } catch {
            print("[Event] - deleteEventsWithoutPerformers Error")
        }
        return true
    }
    
    
    // Delete events that are isActive = false from the database
    class func deleteNotActiveEvents(in context: NSManagedObjectContext) -> Bool
    {
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        request.predicate = NSPredicate(format: "isActive == NO OR isActive == nil")
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                for match in matches {
                    if let id = match.id {
                        print("DELETING Event with ID: [\(id)]")
                    }
                    context.delete(match)
                }
            }
        } catch {
            print("Error while attempting to delete events with isActive = false")
            
        }
        return true
    }
    
    
    
    // Delete an single Event from database
    class func deleteEvent(matching eventID: String, in context: NSManagedObjectContext) -> Bool
    {
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", eventID)
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                context.delete(match[0])
            }
        } catch {
            print("Error while attempting to delete this event: [\(eventID)]")
        }
        
        return true
    }
    
    
    // retrieve event info from eventID
    class func findEvent(from eventID: String, in context: NSManagedObjectContext) -> Event? {
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", eventID)
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "EventID is not unique in the database")
                return match[0]
            }
        } catch {
            print("Error while attempting to delete this event: [\(eventID)]")
        }
        
        return nil
    }
    
}













