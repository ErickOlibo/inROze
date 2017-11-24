//
//  FacebookRequest.swift
//  InRoZe
//
//  Created by Erick Olibo on 10/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation
import CoreData
import FacebookCore
import FBSDKCoreKit

/* This class queries Facebook Graph API
 * by taking events IDs from the Database and fetching 
 * the information. Inserting or updating if necessary
 *
 */

public class FacebookRequest
{

    // Core Data model container and context
    //var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer

    // Array of EventIDs from the database with
    // batchsize eventIds limit per request (facebook Max IDs = 50)
    private let batchSize = 40

    // Dictionary to merge results from FacebookRequest
    private var mergedResults = [String : Any]()
    
    // is true when the Facebook recursiveGraphRequest has fetch all events
    // and update of the core data is done
    private var isDoneUpdatingData = false
    
    // Should be private
    private var eventIDsArray = [String]() {
        didSet {
            //print("******* EVENT IDs ARRAY ***********")
            //print(eventIDsArray)
            recursiveGraphRequest(array: eventIDsArray, parameters: param, batchSize: batchSize)
        }
    }
    
    

    // Facebook Query fields parameters
    let param: [String] = [FBEvent.id, FBEvent.name, FBEvent.startTime, FBEvent.endTime, FBEvent.updatedTime,
                 FBEvent.cover, FBEvent.place, FBEvent.description]
    
    // Recursive Fabeook GraphRequest using batchSize
    private func recursiveGraphRequest(array: [String], parameters: [String], batchSize: Int) {
        print("[FacebookRequest] - recursiveGraphRequest | conditional graph api")
        var arrayVar = array // array to send in the recursion
        var subArray: [String]
        var batch = batchSize
        if (array.count < batchSize) {
            batch = array.count
        }
        
        subArray = Array(array[0 ..< batch]) // copying a new array of batchSize
        let idsString = subArray.joined(separator: ",")
        let params = parameters.joined(separator: ",")
        arrayVar = Array(Set(arrayVar).subtracting(Set(subArray)))

        FBSDKGraphRequest(graphPath: "/?ids=\(idsString)", parameters: ["fields" : params])
            .start(completionHandler:  { (connection, result, error) in
                if error == nil,  let result = result as? [String : Any]{
                    
                    // Merge dictionarry together
                    self.mergedResults.merge(dict: result)

                    self.isDoneUpdatingData = true // assume this is the last recursion
                    if (arrayVar.count > 0) {
                        self.isDoneUpdatingData = false
                        self.recursiveGraphRequest(array: arrayVar, parameters: parameters, batchSize: batchSize)
                    }
                    // if isDone with batching of FB request
                    if (self.isDoneUpdatingData) {
                        self.updateEventDatabase(with: self.mergedResults)
                    }
                    
                } else {
                    print("[recursiveGraphRequest] - there an error -> FACEBOOK Request: \(String(describing: error))")
                }
            })
    }
    
    // insert response from FaceBook events into CoreData
    private func updateEventDatabase(with result: [String : Any]) {
        container?.performBackgroundTask { context in 
            let request: NSFetchRequest<Event> = Event.fetchRequest()
            //print("[updateEventDatabase] - Which Thread is Context at: \(Thread.current)")
            for resID in result {
                do {
                    _ = try Event.updateInfoForEvent(matching: resID, in: context, with: request)
                } catch {
                    print("[updateEventDatabase] - Error with Event.UpdateInfoForEvent")
                }
            }
            // Save the context
            if (self.isDoneUpdatingData) {
                
                // Delete old events from database
                _ = Event.deleteEventsEndedBeforeNow(in: context, with: request)


                // delete events without performers
                _ = Event.deleteEventsWithoutPerformers(in: context, with: request)
                
                do {
                    //print("[updateEventDatabase] -  BEFORE try to save context")
                    //print("[FB request - updateEventDatabase] - Which Thread is Context at: \(Thread.current)")
                    try context.save()
                    //print("[updateEventDatabase] -  AFTER SAVED in Context!")
                    
                    
                    // update the date to FacebbokRequest
                    UserDefaults().setDateNow(for: RequestDate.toFacebook)
                    //UserDefaults().isLoginNow = false
                    // create notification center
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationFor.initialLoginRequestIsDone), object: nil)
                    
                } catch {
                    print("[updateEventDatabase] - Error during saving: \(error)")
                }
            }
        }
    }
    
    public func collectEventIDsFromCoreData() {
        if let context = container?.viewContext {
            context.perform {
                let request: NSFetchRequest<Event> = Event.fetchRequest()
                if let events = try? context.fetch(request) {
                    var eventIDsArr = [String]()
                    for event in events as [Event] {
                        if let eventStr = event.id {
                            eventIDsArr.append(eventStr)
                        }
                    }
                    //print(eventIDsArr)
                    self.eventIDsArray = eventIDsArr
                }
            }
        }
    }


}
