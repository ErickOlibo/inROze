//
//  RequestHandler.swift
//  InRoZe
//
//  Created by Erick Olibo on 16/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation
import FacebookCore
import FBSDKCoreKit
import CoreData


/* Handles all the request calls to the Facebook Graph API
 * and the InRoZe server API. The frequency of a call to a API
 * is control here via the userDefaultsExtension file
 */


public class RequestHandler
{
    
    // Core Data model container and context
    private let context = AppDelegate.viewContext
    private let container = AppDelegate.persistentContainer
    
    // Properties listeners
    var isDoneUpdatingServeRequest = false {
        didSet {
            print("[RequestHandler] - isDoneUpdatingServeRequest: \(isDoneUpdatingServeRequest)")
            fetchEventsInfoFromFacebook()
        }
    }
    
    
    // MARK: - Handler to SERVER
    
    // request fetch EventIDs from CityCode server
    public func fetchEventIDsFromServer() {
        let userDefault = UserDefaults()
        // Conditions of execution
        if (!userDefault.isDateSet(for: RequestDate.toServer)) ||
            userDefault.hasEnoughTimeElapsed(since: RequestDate.toServer) {
            if let userID = AccessToken.current?.userId {
                let params = "id=\(userID)&cityCode=\(userDefault.currentCityCode)"
                let request = ServerRequest()
                request.getEventsIDsCurrentList(parameter: params, urlToServer: UrlFor.currentEventsID)
                print("[RequestHandler] - fetchEventsIDFromServer: \(params)")
                
            }
        } else {
            // Go straight to Facebook Request
            print("[RequestHandler] - No need Server Request - Go To Facebook Request")
            fetchEventsInfoFromFacebook()
        }
        
    }

    
    // Saves user info into the Server
    private func saveCurrentUserProfile(_ result: NSDictionary) {
        if let id = result[FBUser.id]  as? String,
            let name = result[FBUser.name] as? String {
            
            if let _ = AccessToken.current {
                // Get some info about User
                let email = result[FBUser.email] as? String? ?? ""
                let gender = result[FBUser.gender] as? String? ?? "Neutral"
                
                // Going to the network -> MOVE FROM MAIN QUEUE
                let parameters = "id=\(id)&name=\(name)&email=\(email!)&gender=\(gender!)"
                let serverRequest = ServerRequest()
                serverRequest.setUserLoggedIn(to: true, parameters: parameters, urlToServer: UrlFor.logInOut)
                
                
                if let currentUser = UserProfile.current {
                    print("[RequestHandler] - current user got: \(currentUser)")
                } else {
                    print("[RequestHandler] - Current user is NIL")
                    UserProfile.loadCurrent{ profile in
                        print("[currentUser] - \(profile)")
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    
    // MARK: - Handler to FACEBOOK
    
    // Call FB Graph API and fetch user info
    public func requestUserInfo() {
        print("Inside request User")
        let params = [FBUser.email, FBUser.name, FBUser.id, FBUser.gender, FBUser.cover].joined(separator: ", ")
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : params])
            .start(completionHandler:  { (connection, result, error) in
                if let result = result as? NSDictionary{
                    self.saveCurrentUserProfile(result)
                }
            })
    }
    
    
    // Request events Info from Facebook Graph API
    private func fetchEventsInfoFromFacebook () {
        
        let userDefault = UserDefaults()
        // Conditions of execution
        if (!userDefault.isDateSet(for: RequestDate.toFacebook)) ||
            userDefault.hasEnoughTimeElapsed(since: RequestDate.toFacebook) {
            FacebookRequest().collectEventIDsFromCoreData()
            
        } else {
            print("[RequestHandler] - No need Fetch Facebook Request")
            // create notification center
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationFor.coreDataDidUpdate), object: nil)
        }
        
        
    }
  
    
    
    // Request Events info from the Core Database depending on city
    public func getEventsFromCoreDatabase (in context: NSManagedObjectContext) -> [Event] {
        var result = [Event]()
        context.perform {
            let events = Event.eventsStartingAfterNow(in: context)
            if events.count > 0 {
                result = events
                print("[RequestHandler] - Events count: \(events.count)")
                for event in events {
                    if event.name != nil {print("Event Name: \(event.name!)")}
                }
                
                
            } else {
                print("[RequestHandler] - There is no events Starting after now")
            }
        }
        return result
    }
    
    
    
    
    
}



















