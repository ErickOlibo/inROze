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

    // Array of EventIDs from the database
    var eventIDsArray = [String]() {
        didSet {
            printSlicedArray(with: eventIDsArray, firstIndex: 0, batchSize: 10)
        }
    }
    
    // Sample ids Array to use
    let sampleEvents = ["100531250667584", "102851610417423", "1036341596468620", "104974153527931", "106338836720028"]
    
    // Facebook Query fields parameters
    let tmpParam = [FBEvent.id, FBEvent.name, FBEvent.startTime, FBEvent.endTime, FBEvent.updatedTime]
    let param = [FBEvent.id, FBEvent.name, FBEvent.startTime, FBEvent.endTime, FBEvent.updatedTime,
                 FBEvent.cover, FBEvent.place, FBEvent.descript]
    
    
    // Call Facebook Graph API
    func requestCurrentEventsInfo(with idsArray: [String], parameters: [String]) {
        let eventIDsString = idsArray.joined(separator: ",")
        let params = parameters.joined(separator: ", ")
        print(eventIDsString)
        print(params)
        
        // Background with Completion check for MEMORY CYCLE with [weak self]
        FBSDKGraphRequest(graphPath: "/?ids=\(eventIDsString)", parameters: ["fields" : params])
            .start(completionHandler:  { (connection, result, error) in
                if error == nil,  let result = result as? NSDictionary{
                    //print(result)
                    self.updateEventDatabase(with: result)
                } else {
                    print("there an error: \(String(describing: error))")
                }
            })
    }
    
    
    // insert response from FaceBook events to CoreData 
    private func updateEventDatabase(with result: NSDictionary) {
        print("updating Event Database")
        print(result)
    }
    
    
    
    func collectEventIDsFromCoreData() {
        let context = container.viewContext
        context.perform {
            let request: NSFetchRequest<Event> = Event.fetchRequest()
            if let events = try? context.fetch(request) {
                var eventCount = 1
                var eventIDsArr = [String]()
                for event in events as [Event] {
                    
                    if let eventStr = event.id {
                        print("\(eventCount)) \(eventStr)")
                        eventIDsArr.append(eventStr)
                        
                    }
                    eventCount += 1
                    
                }
                self.eventIDsArray = eventIDsArr
            }
        }
    }
    
    
    // print sliced Array
    private func printSlicedArray(with array: [String], firstIndex: Int, batchSize: Int) {
        var currentIndex = firstIndex
        while currentIndex < array.count {
            var bSize = batchSize
            if (array.count - currentIndex < batchSize) {
                bSize = array.count - currentIndex
            }
            let currentSlice = Array(array[currentIndex ..< currentIndex + bSize])
            print(currentSlice)
            currentIndex += bSize
        }
        
    }
    
    
    
    // saves EventIDs reponse to Core data
    private func saveEventIDs(_ result: NSDictionary) {
        
        
    }
    
    
    // Clear core data of events end_time older than NOW
    
    private func deleteOldEvents() {
        
    }
    
}
