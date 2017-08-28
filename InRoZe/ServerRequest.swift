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
            //updateArtistsDatabase(with: result!)
        }
    }
    
    // print artist list
    private func updateArtistsDatabase(with jsonDict: [String : Any], in context: NSManagedObjectContext) {
        for (key, value) in jsonDict {
            if (key == DBLabels.upToDateArtistsList),
                let  artistsArray = value as? [Any] {
                for artistInfoArray in artistsArray {
                    if let artistInfo = artistInfoArray as? [String : String]{
                        do {
                            _ = try Artist.findOrCreateArtist(with: artistInfo, in: context)
                        } catch {
                            print("[ServerRequest] - Error trying to FindOrCreateArtist: \(error)")
                        }
                    }
                }
            }
        }
    }
    
    private func updateDatabase(with eventIDs: [String : Any]) {
        //print("[ServerRequest] - Starting updateDatabase from Server")
        container.performBackgroundTask { context in
            for (key, value) in eventIDs {
                if (key == DBLabels.eventsToPlaces),
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
                    // insert artists to database
                    self.updateArtistsDatabase(with: eventIDs, in: context)
                    
                    // insert performers for events
                    self.insertOrUpdateArtistsOfEvents(with: eventIDs, in: context)
                    
                    // Save in CoreDatabase
                    do {
                        try context.save()
                        UserDefaults().setDateNow(for: RequestDate.toServer)
                        
                        print("[ServerRequest] -  UpdateDatabase DONE and SAVED")
                        RequestHandler().isDoneUpdatingServeRequest = true
                        
                    } catch {
                        print("[ServerRequest] - Error trying to save in CoreData: \(error)")
                    }
                    self.printDatabaseStatistics()
                }
            }
        }
    }
    
    private func insertOrUpdateArtistsOfEvents(with eventDict: [String : Any], in context: NSManagedObjectContext) {
        
        //print("[insertOrUpdateArtistsOfEvents] - \(eventDict[DBLabels.artistsOfEvents] as! [String : String])")
        
        if let artsOfEventsArr = eventDict[DBLabels.artistsOfEvents] as? [Any],
            let _ = artsOfEventsArr.first as? [String : String] {
            for event in artsOfEventsArr {
                if let artistsOfEv = event as? [String : String] {
                    print("[\(artistsOfEv[DBLabels.eventID]!)] - ArtistsList: [\(artistsOfEv[DBLabels.artistsList]!)]")
                    // add artists to Event
                    
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
            
            // Better way to count number of element in entity (CoreData)
            if let artistsCount = try? context.count(for: Artist.fetchRequest()) {
                print("[printDatabaseStatistics] - \(artistsCount) Artists")
            }
        }
        
        
    }
    


}




















