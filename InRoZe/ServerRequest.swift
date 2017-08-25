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
 *
 */

public class ServerRequest
{
    
    // Core Data model container and context
    private let context = AppDelegate.viewContext
    private let container = AppDelegate.persistentContainer
    
    
    public func setUserLoggedIn(to isLogged: Bool, parameters: String, urlToServer: String) {
        let postParams = "\(parameters)&isLogged=\(isLogged)"
        let _ = taskForURLSession(postParams: postParams, url: urlToServer, isEventFetch: false)
    }
    
    // request to Server for latest updated list of EventIDs
    public func getEventsIDsCurrentList(parameter: String, urlToServer: String) {
        
            let _ = taskForURLSession(postParams: parameter, url: urlToServer, isEventFetch: true)
    }
    
    
    // when call to the server, conditional call must be depending on the Country/ City
    // ADD the city selector 
    private func taskForURLSession(postParams: String, url: String, isEventFetch: Bool) {
        print("[ServerRequest] - taskForURLSession FUNC | conditional call to server")
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.httpBody = postParams.data(using: .utf8)
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] {
                    if (isEventFetch) {
                        // check if there is no error
                        if let errorType = json[DBLabels.errorType] as! Bool?, !errorType {
                            print("[ServerRequest] - There is an error from server response: \(errorType)")
                            
                            if (json[DBLabels.rows]! as! Int > 0) {
                                self.result = json
                                //print(json)
                                UserDefaults().setDateNow(for: RequestDate.toServer)
                            }
                            
                        }
                    } else {
                        print(json)
                    }
                }
            } catch let error {
                print("[ServerRequest] - Error in URL Seesion: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    var result: [String : Any]? {
        didSet {
            updateDatabase(with: result!)
        }
    }
    
    private func updateDatabase(with eventIDs: [String : Any]) {
        //print("[ServerRequest] - Starting updateDatabase from Server")
        container.performBackgroundTask { context in
            for (key, value) in eventIDs {
                if (key == DBLabels.eventEventIDs),
                    let events = value as? [Any],
                    let _ = events.first as? [String : String] {
                    for event in events {
                        if let eventDict = event as? [String : String] {
                            // Print the djs list if not nil
//                            if let artistList = eventDict[DBLabels.artistsList] {
//                                print("EventID: [\(eventDict[DBLabels.eventID]!)] -> List: [\(artistList)]")
//                            }

                            do {
                                _ = try Event.findOrInsertEventID(matching: eventDict, in: context)
                            } catch {
                                print(error)
                            }
                        }
                    }
                    // Save in CoreDatabase
                    do {
                        try context.save()
                        UserDefaults().setDateNow(for: RequestDate.toServer)
                        
                        print("[ServerRequest] -  UpdateDatabase DONE and SAVED")
                        RequestHandler().isDoneUpdatingServeRequest = true
                        
                        
                        //notify whoever is listening
                        //print("[ServerRequest] - Post Notification: serverRequestDoneUpdating")
                        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationFor.serverRequestDoneUpdating), object: nil)
                        
                    } catch {
                        print("[ServerRequest] - Error trying to save in CoreData: \(error)")
                    }
                    self.printDatabaseStatistics()
                }
            }
        }
    }
    
    
    private func printDatabaseStatistics() {
        print("[printDatabaseStatistics] - print data Stats")
        
        let context = container.viewContext
        // THREAD SAFETY
        // context.perform makes sure the block is executed on the right thread for the context
        context.perform {
            // Check if main thread
            if Thread.isMainThread {
                print("[printDatabaseStatistics] - on main thread")
            } else {
                print("[printDatabaseStatistics] - off main thread")
            }
            let request: NSFetchRequest<Event> = Event.fetchRequest()
            if let eventsCount = (try? context.fetch(request))?.count {
                print("[printDatabaseStatistics] - \(eventsCount) events IDs")
            }
            // Better way to count number of element in entity (CoreData)
            if let placesCount = try? context.count(for: Place.fetchRequest()) {
                print("[printDatabaseStatistics] - \(placesCount) Places IDs")
            }
        }
        
        
    }

}




















