//
//  ServerRequest.swift
//  InRoZe
//
//  Created by Erick Olibo on 08/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/* This class sync the log in status (true/false) of the user
 * and fetch the latest list of (EventIDs - PlaceIds)
 * from the Server. 
 *
 */

public class ServerRequest
{
    
    // Core Data model container and context
    //var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    
    var result: [String : Any]? { didSet { updateDatabase(with: result!) } }
    
    
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
            // count data size
            let byteCount = data.count
            let bcf = ByteCountFormatter()
            bcf.allowedUnits = [.useMB]
            bcf.countStyle = .file
            let sizeString = bcf.string(fromByteCount: Int64(byteCount))
            print("********** DATA SIZE Recieved from SERVER is: \(sizeString)")

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] {
                    if (isEventFetch) {
                        // check if there is no error
                        if let errorType = json[DBLabels.errorType] as! Bool?, !errorType {
                            print("[ServerRequest] - Server Response ErrorType: \(errorType)")
                            if (json[DBLabels.rows]! as! Int > 0) {
                                self.result = json
                                UserDefaults().setDateNow(for: RequestDate.toServer)
                            }
                        }
                    } else {
                        //print(json)
                    }
                }
            } catch {
                print("[ServerRequest] - Error in URL Seesion")
            }
        }
        task.resume()
    }
    

    
    // print artist list
    private func updateArtistsDatabase(with jsonDict: [String : Any], in context: NSManagedObjectContext) {
        for (key, value) in jsonDict {
            if (key == DBLabels.upToDateArtistsList),
                let  artistsArray = value as? [Any] {
                //print("[FROM SERVER]the size of DJ array: ", artistsArray.count)
                for artistInfoArray in artistsArray {
                    if let artistInfo = artistInfoArray as? [String : Any]{
                        do {
                            _ = try Artist.createOrUpdateArtist(with: artistInfo, in: context)
                        } catch {
                            print("[ServerRequest] - Error trying to createOrUpdateArtist")
                        }
                    }
                }
            }
        }
    }
    
    private func updateMixtapesDatabase(with jsonDict: [String : Any], in context: NSManagedObjectContext) {
        for (key, value) in jsonDict {
            if (key == DBLabels.mixtapesList),
                let  mixtapesArray = value as? [Any] {
                //print("[FROM SERVER] the size of MIXTAPES array: ", mixtapesArray.count)
                for mixtapeInfoArray in mixtapesArray {
                    if let mixtapeInfo = mixtapeInfoArray as? [String : Any]{
                        
                        do {
                            _ = try Mixtape.createOrUpdateMixtape(with: mixtapeInfo, in: context)
                        } catch {
                            print("[ServerRequest] - Error trying to createOrUpdateMixtape")
                        }
                    }
                }
            }
        }
    }
    
    
    private func updateDatabase(with eventIDs: [String : Any]) {
        container?.performBackgroundTask { context in
            
            for (key, value) in eventIDs {
                if (key == DBLabels.eventsToPlaces),
                    let events = value as? [Any],
                    let _ = events.first as? [String : String] {
                    for event in events {
                        if let eventDict = event as? [String : String] {
                            do {
                                _ = try Event.insertOrUpdateServerInfoForEvent(with: eventDict, in: context)
                            } catch {
                                print(error)
                            }
                        }
                    }
                    // Core Data updates for Artist, Mixtapes, Artists of Events
                    self.updateArtistsDatabase(with: eventIDs, in: context)
                    self.updateMixtapesDatabase(with: eventIDs, in: context)
                    self.insertOrUpdateArtistsOfEvents(with: eventIDs, in: context)
                    
                    _ = Event.deleteNotActiveEvents(in: context)
                    _ = Mixtape.deleteNotActiveMixtapes(in: context)
                    
                    do {
                        try context.save()
                        UserDefaults().setDateNow(for: RequestDate.toServer)
                    } catch {
                        print("[ServerRequest] - Error trying to save in CoreData")
                    }
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationFor.coreDataDidUpdate), object: nil)
                    if (UserDefaults().isFromLoginView) {
                        print("NotificationFor.initialLoginRequestIsDone")
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationFor.initialLoginRequestIsDone), object: nil)
                        UserDefaults().isFromLoginView = false
                    } else {
                        print("NotificationFor.serverRequestDoneUpdating")
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationFor.serverRequestDoneUpdating), object: nil)
                    }
                    
                    //self.printDatabaseStatistics()
                }
            }
        }
    }
    
    
    private func insertOrUpdateArtistsOfEvents(with eventDict: [String : Any], in context: NSManagedObjectContext) {
        if let artsOfEventsArr = eventDict[DBLabels.artistsOfEvents] as? [Any],
            let _ = artsOfEventsArr.first as? [String : String] {
            for event in artsOfEventsArr {
                if let artistsOfEv = event as? [String : String] {
                    //print("[\(artistsOfEv[DBLabels.eventID]!)] - ArtistsList: [\(artistsOfEv[DBLabels.artistsList]!)]")
                    // add artists to Event
                    do {
                        let _ = try Event.updateArtistsListForEvent(with: artistsOfEv, in: context)
                    } catch {
                        print("[ServerRequest] - insertOrUpdateArtistsOfEvents Error trying to update")
                    }
                }
            }
        }
    }
    
    
    
    private func printDatabaseStatistics() {
        if let context = container?.viewContext {
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
                
                // Better way to count number of element in entity (CoreData)
                if let mixtapesCount = try? context.count(for: Mixtape.fetchRequest()) {
                    print("[printDatabaseStatistics] - \(mixtapesCount) Mixtapes")
                }
                
                // list events with artists > 0
                request.predicate = NSPredicate(format: "performers.@count > 0")
                do {
                    let matches = try context.fetch(request)
                    if matches.count > 0 {
                        print("Number of Events with Djs: \(matches.count)")
                        
                    }
                } catch {
                    print("[printDatabaseStatistics] there was an error")
                }
                
                // list of artist that have gigs
                let req: NSFetchRequest<Artist> = Artist.fetchRequest()
                req.predicate = NSPredicate(format: "gigs.@count > 0")
                do {
                    let matches = try context.fetch(req)
                    if matches.count > 0 {
                        print("Number of Artists with gigs: \(matches.count)")
                    }
                } catch {
                    print("[printDatabaseStatistics] there was an error")
                }
                
                
                // list artist that have Mixtapes
                let reqMix: NSFetchRequest<Artist> = Artist.fetchRequest()
                reqMix.predicate = NSPredicate(format: "mixes.@count > 0")
                do {
                    let matches = try context.fetch(reqMix)
                    if matches.count > 0 {
                        print("Number of Artists with Mixtapes: \(matches.count)")
                    }
                } catch {
                    print("[printDatabaseStatistics] there was an error")
                }
            }
        }
    }
    
}




















