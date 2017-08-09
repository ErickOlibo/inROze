//
//  ServerRequest.swift
//  InRoZe
//
//  Created by Erick Olibo on 08/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation
import CoreData


// GLOBAL var are a bad idea I think (to verify)
// should just let this for the moment
var resultServer = [String : Any]()

public class ServerRequest
{
    
    // Core Data model container and context
    let context = AppDelegate.viewContext
    let container = AppDelegate.persistentContainer
    
    
    public func setUserLoggedIn(to isLogged: Bool, parameters: String, urlToServer: String) {
        let postParams = "\(parameters)&isLogged=\(isLogged)"
        let _ = taskForURLSession(postParams: postParams, url: urlToServer, isEventFetch: false)
    }
    
    public func getEventsIDsCurrentList(parameter: String, urlToServer: String) {
        let _ = taskForURLSession(postParams: parameter, url: urlToServer, isEventFetch: true)
    }
    
    private func taskForURLSession(postParams: String, url: String, isEventFetch: Bool) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.httpBody = postParams.data(using: .utf8)
        //let result = [String: Any]()
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    
                    if (isEventFetch) {
                        print("EventID Fetch JSON Result")
                        self.result = json
                    } else {
                        print("Log IN OUT JSON Result")
                        print(json)
                    }
                }
            } catch let error {
                print("Error in URL Session: ")
                print(error.localizedDescription)
            }
        }
        task.resume()
        //return result
    }
    
    var result: [String : Any]? {
        didSet {
            updateDatabase(with: result!)
            resultServer = result!
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationFor.eventIDsDidUpdate), object: nil)
            
            // Insert and Update CoreData with result
        }
        
    }
    
    private func updateDatabase(with eventIDs: [String : Any]) {
        container.performBackgroundTask { context in
            print("updateDatabase")
            for (key, value) in eventIDs {
                if (key == DBLabels.responseKey),
                    let events = value as? [Any],
                    let _ = events.first as? [String : String] {
                    for event in events {
                        if let eventDict = event as? [String : String] {
                            print("eventDict")
                            
                            
                            // find or insert eventID
                            do {
                                print("try find or insert")
                                _ = try self.findOrInsertEventID(matching: eventDict, in: context)
                            } catch {
                                print(error)
                            }
                            
                            // Save in CoreDatabase
                            do {
                                try context.save()
                            } catch {
                                print("Error trying to save in CareData: \(error)")
                            }
                        }
                    }
                   self.printDatabaseStatistics()
                }
            }
        }
        
    }
    
    
    private func printDatabaseStatistics() {
        print("printdata Stats")
        // Check if main thread
        if Thread.isMainThread {
            print("on main thread")
        } else {
            print("off main thread")
        }
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        if let eventsCount = (try? context.fetch(request))?.count {
            print("\(eventsCount) events IDs")
        }
        // Better wat to count number of element in entity
        if let placesCount = try? context.count(for: Place.fetchRequest()) {
            print("\(placesCount) Places IDs")
        }
        
    }
    
    
    // Find or insert an eventID and return true if eventID already
    // in database
    private func findOrInsertEventID(matching eventDict: [String : String], in context: NSManagedObjectContext) throws -> Bool {
        print("find or insert")
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", eventDict[DBLabels.eventID]!)
        let event = Event(context: context)
        
        do {
            
            let match = try context.fetch(request)
            if match.count > 0 {
                // Event already in Database then update location ID
                print("ALREADY IN DATABASE")
                assert(match.count == 1, "findOrInsertEventID -- database inconsistency")
                event.location!.id = eventDict[DBLabels.placeID]
                return true
            }
        } catch {
            throw error
        }
        
        // New event then insert Event ID and Location ID
        print("NOT IN DATABASE")
        event.id = eventDict[DBLabels.eventID]
        event.location?.id = eventDict[DBLabels.placeID]
        return false
    }
    
    // Find insert
    
    
    
    
    // Fields name from the Server Database Columns
    private struct DBLabels {
        static let eventID = "event_id"
        static let placeID = "place_id"
        static let responseKey = "eventPlaceIDs"
    }
}




















