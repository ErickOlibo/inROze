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
    
    
    public func queryFacebookGraphAPI(for eventID: String) -> Bool{
        
        // Facebook Query fields parameters
        let param: [String] = [FBEvent.description, FBEvent.name]
        let params = param.joined(separator: ",")
        FBSDKGraphRequest(graphPath: "\(eventID)", parameters: ["fields" : params])
            .start(completionHandler:  { (connection, result, error) in
                if error == nil,  let result = result as? [String : String]{
                    print("IS QUERY FOR FACEBOOK DONE WITH SUCCESS")
                    if let descr = result[FBEvent.description] {
                        self.sendDescriptionThroughNotificationCenter(text: descr, id: eventID)
                    }
                } else {
                    print("[queryFacebookGraphAPI] - there an error -> FACEBOOK Request: \(String(describing: error))")
                }
            })
        return true
    }
    
    
    // send the description with the noification center
    private func sendDescriptionThroughNotificationCenter( text: String, id: String) {
        let textDataDict:[String: String] = ["text" : text]
        let notice = NotificationFor.eventDescriptionRecieved + id
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notice), object: nil, userInfo: textDataDict)
    }
    
    
    // insert response from FaceBook events into CoreData Simplify
    private func updateEventInfoToDatabase(with result: [String : String], id: String) {
        container?.performBackgroundTask { context in
            do {
                _ = try Event.updateDescriptionFromFacebookForEvent(with: result, in: context)
            } catch {
                print("[updateEventInfoToDatabase] - Error with Updating Description for event")
            }
            do {
                try context.save()
            } catch {
                print("[updateEventInfoToDatabase] - Error during saving: \(error)")
            }
            let notice = NotificationFor.eventDescriptionRecieved + id
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: notice), object: nil)
        }
    }
    
    // insert response from FaceBook events into CoreData
    private func updateEDatabase(with result: [String : Any]) {
        container?.performBackgroundTask { context in
            let request: NSFetchRequest<Event> = Event.fetchRequest()
            //print("[updateEventDatabase] - Which Thread is Context at: \(Thread.current)")
            //print(result)
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




















