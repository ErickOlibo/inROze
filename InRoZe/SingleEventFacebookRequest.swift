//
//  SingleEventFacebookRequest.swift
//  InRoZe
//
//  Created by Erick Olibo on 19/01/2018.
//  Copyright © 2018 Erick Olibo. All rights reserved.
//

import Foundation
import CoreData
import FacebookCore
import FBSDKCoreKit

/* This class queries Facebook Graph API
 * by taking a SINGLE Event ID query information from Facebook
 * Then Inserting or updating  core data if necessary
 *
 */

public class SingleEventFacebookRequest
{
    
    // Core Data model container and context
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    
    
    public func queryFacebookGraphAPI(for eventID: String) {
        
        // Facebook Query fields parameters
        let param: [String] = [FBEvent.id, FBEvent.name, FBEvent.startTime, FBEvent.endTime, FBEvent.updatedTime,
                               FBEvent.cover, FBEvent.place]
        
        FBSDKGraphRequest(graphPath: "/?ids=\(eventID)", parameters: ["fields" : param])
            .start(completionHandler:  { (connection, result, error) in
                if error == nil,  let result = result as? [String : Any]{
                    self.updateEventDatabase(with: result)
                    
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
            print(result)
            for resID in result {
                do {
                    _ = try Event.updateInfoFromFacebookForEvent(matching: resID, in: context, with: request)
                } catch {
                    print("[updateEventDatabase] - Error with Event.UpdateInfoForEvent")
                }
            }
            
            // Save the context
            do {
                //print("[FB request - updateEventDatabase] - Which Thread is Context at: \(Thread.current)")
                try context.save()
                
            } catch {
                print("[updateEventDatabase] - Error during saving: \(error)")
            }
        }
    }
    
    
    
    
    
    
}




















