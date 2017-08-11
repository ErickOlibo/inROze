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
    let context = AppDelegate.viewContext
    let container = AppDelegate.persistentContainer
    
    // Sample places to ue
    let sampleEvents = ["100531250667584", "102851610417423", "1036341596468620", "104974153527931", "106338836720028"]
    let tmpParam = [FBEvent.id, FBEvent.name, FBEvent.startTime, FBEvent.endTime, FBEvent.updatedTime]
    
    let param = [FBEvent.id, FBEvent.name, FBEvent.startTime, FBEvent.endTime, FBEvent.updatedTime,
                 FBEvent.cover, FBEvent.place, FBEvent.descript]
    
    // Call Facebook Graph API
    func requestCurrentEventsInfo(from city: String) {
        
        let eventIDsString = sampleEvents.joined(separator: ",")
        //let params = param.joined(separator: ", ")
        let params2 = tmpParam.joined(separator: ", ")

        
        // Background with Completion check for MEMORY CYCLE with [weak self]
        FBSDKGraphRequest(graphPath: "/?ids=\(eventIDsString)", parameters: ["fields" : params2])
            .start(completionHandler:  { (connection, result, error) in
                
                if error != nil,  let result = result as? NSDictionary{
                    print(result)
                    //self.saveEventIDs(result)
                } else {
                    print("there an error: \(String(describing: error))")
                }
            })
        
    }
    
    func printEventIDsFromCoreData() {
        let context = container.viewContext
        context.perform {
            let request: NSFetchRequest<Event> = Event.fetchRequest()
            if let events = try? context.fetch(request) {
                var eventCount = 1
                for event in events as [Event] {
                    
                    if let eventStr = event.id {
                        print("\(eventCount)) \(eventStr)")
                    }
                    eventCount += 1
                    
                }
            }
        }
    }
    
    
    // saves EventIDs reponse to Core data
    private func saveEventIDs(_ result: NSDictionary) {
        
        
    }
    
    
    // Clear core data of events end_time older than NOW
    
    private func deleteOldEvents() {
        
    }
    
}
