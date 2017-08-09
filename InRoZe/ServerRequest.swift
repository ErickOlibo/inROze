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
        print("Size of EventIDS: \(eventIDs.count)")
        container.performBackgroundTask { context in
            // New way of writting
            for (key, value) in eventIDs {
                if (key == "eventPlaceIDs"),
                let events = value as? [Any],
                    let _ = events.first as? [String : String] {
                    print("Am I Here")
                    var rank = 1
                    for event in events {
                        if let eventNr = event as? [String : String] {
                            print("\(rank)) EventID: \(eventNr["event_id"]!)")
                            print("\(rank)) PlaceID: \(eventNr["place_id"]!)")
                        }
                        rank += 1
                    }
                }
            }
        }
    }
    
    // Find or insert an eventID and return true if eventID already
    // in database
    private func findOrInsertEventID(matching eventID: String, in context: NSManagedObjectContext) throws -> Bool {
        
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", eventID)
        
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "findOrInsertEventID -- database inconsistency")
                return true
            }
        } catch {
            throw error
        }
        
        
        return false
    }
    
    
}




















