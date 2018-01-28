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
        let params = [FBEvent.description, FBEvent.name].joined(separator: ",")
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
    
    // send the description text with the notification center
    private func sendDescriptionThroughNotificationCenter( text: String, id: String) {
        let textDataDict:[String: String] = ["text" : text, "id" : id]
        //textDataDict["id"] = id
        let notice = NotificationFor.eventDescriptionRecieved + id
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notice), object: nil, userInfo: textDataDict)
    }
    
   
}




















