//
//  ServerRequest.swift
//  InRoZe
//
//  Created by Erick Olibo on 08/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation
import CoreData

/* This class sync the log in status (true/false) of the user
 * and fetch the latest list of (EventIDs - PlaceIds)
 * from the Server. 
 * The contry specific fecth STILL TO IMPLEMENT
 *
 */

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
                        self.result = json
                    } else {
                        print(json)
                    }
                }
            } catch let error {
                print("Error in URL Seesion: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    var result: [String : Any]? {
        didSet {
            updateDatabase(with: result!)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationFor.eventIDsDidUpdate), object: nil)
        }
    }
    
    private func updateDatabase(with eventIDs: [String : Any]) {
        print("Starting update Database")
        container.performBackgroundTask { context in
            for (key, value) in eventIDs {
                if (key == DBLabels.responseKey),
                    let events = value as? [Any],
                    let _ = events.first as? [String : String] {
                    for event in events {
                        if let eventDict = event as? [String : String] {
                            print("eventDict EXIST")
                            do {
                                _ = try Event.findOrInsertEventID(matching: eventDict, in: context)
                            } catch {
                                print(error)
                            }
                        }
                    }
                    // Save in CoreDatabase
                    do {
                        print("TRYING to SAVE")
                        try context.save()
                    } catch {
                        print("Error trying to save in CoreData: \(error)")
                    }
                    print("ABOVE STATS")
                    self.printDatabaseStatistics()
                }
            }
        }
    }
    
    
    private func printDatabaseStatistics() {
        print("printdata Stats")
        
        let context = container.viewContext
        // THREAD SAFETY
        // makes sure the block is executed on the right thread for the context
        context.perform {
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
            // Better way to count number of element in entity (CoreData)
            if let placesCount = try? context.count(for: Place.fetchRequest()) {
                print("\(placesCount) Places IDs")
            }
        }
        
        
    }

}




















