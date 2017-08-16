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
    let context = AppDelegate.viewContext
    let container = AppDelegate.persistentContainer
    
    
    public func setUserLoggedIn(to isLogged: Bool, parameters: String, urlToServer: String) {
        let postParams = "\(parameters)&isLogged=\(isLogged)"
        let _ = taskForURLSession(postParams: postParams, url: urlToServer, isEventFetch: false)
    }
    
    // request to Server for latest updated list of EventIDs
    public func getEventsIDsCurrentList(parameter: String, urlToServer: String) {
        
            let _ = taskForURLSession(postParams: parameter, url: urlToServer, isEventFetch: true)
            
            // update the date to server
            //userDefault.setDateNow(for: RequestDate.toServer)
        
    }
    
    // when call to the server, conditional call must be depending on the Country/ City
    // ADD the city selector 
    private func taskForURLSession(postParams: String, url: String, isEventFetch: Bool) {
        print("taskForURLSession FUNC | conditional call to server")
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
                if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] {
                    if (isEventFetch) {
                        // check if there is no error
                        if let errorType = json[DBLabels.errorType] as! Bool?, !errorType {
                            print("There is an error from server response: \(errorType)")
                            
                            // only when number of rows in response is > 0
                            if (json[DBLabels.rows]! as! Int > 0) {
                                print("There are Rows eventIDs from Server Response")
                                //self.result = json
                            }
                            
                        }
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
            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationFor.eventIDsDidUpdate), object: nil)
        }
    }
    
    private func updateDatabase(with eventIDs: [String : Any]) {
        print("Starting update Core Database from Server")
        container.performBackgroundTask { context in
            for (key, value) in eventIDs {
                if (key == DBLabels.eventEventIDs),
                    let events = value as? [Any],
                    let _ = events.first as? [String : String] {
                    for event in events {
                        if let eventDict = event as? [String : String] {

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
                        let userDefault = UserDefaults()
                        userDefault.setDateNow(for: RequestDate.toServer)
                        
                        print("ServerRequest: UpdateDatabase DONE and SAVED")
                    } catch {
                        print("Error trying to save in CoreData: \(error)")
                    }
                    self.printDatabaseStatistics()
                }
            }
        }
    }
    
    
    private func printDatabaseStatistics() {
        print("print data Stats")
        
        let context = container.viewContext
        // THREAD SAFETY
        // context.perform makes sure the block is executed on the right thread for the context
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




















