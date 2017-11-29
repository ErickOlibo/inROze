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



public class RequestHandler
{
    var isDoneUpdatingServerRequest = false { didSet { fetchEventsInfoFromFacebook() } }
    
    // Boolean to know if I'm just login. it can be a recursive login
    //var isInitialLogin = false { didSet { print("isInitialLogin was set: [\(isInitialLogin)]") } }
    
    
    // MARK: - Handler to SERVER
    
    // request fetch EventIDs ArtistsForEvents and ArtitsList from server
    // with userID, cityCode and countryCode parameters
    public func fetchEventIDsFromServer() {
        let userDefault = UserDefaults()
        // Conditions of execution
        if (!userDefault.isDateSet(for: RequestDate.toServer)) ||
            userDefault.hasEnoughTimeElapsed(since: RequestDate.toServer) || userDefault.isLoggedIn {
            if let userID = AccessToken.current?.userId {
                let params = "id=\(userID)&cityCode=\(currentCity.code.rawValue)&countryCode=\(currentCity.countryCode.rawValue)"
                let request = ServerRequest()
                request.getEventsIDsCurrentList(parameter: params, urlToServer: UrlFor.currentEventsID)
            }
        } else {
            fetchEventsInfoFromFacebook()
        }
    }

    // Request events Info from Facebook Graph API
    private func fetchEventsInfoFromFacebook () {
        
        let userDefault = UserDefaults()
        // Conditions of execution
        if (!userDefault.isDateSet(for: RequestDate.toFacebook)) ||
            userDefault.hasEnoughTimeElapsed(since: RequestDate.toFacebook) || userDefault.isLoggedIn {
            //print("Fetch Events Info From Facebook")
            FacebookRequest().collectEventIDsFromCoreData()
            
        } else {
            // create notification center
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationFor.coreDataDidUpdate), object: nil)
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
            }
        }
    }
    
    // MARK: - Handler to FACEBOOK
    // Call FB Graph API and fetch user info
    public func requestUserInfo() {
        let params = [FBUser.email, FBUser.name, FBUser.id, FBUser.gender, FBUser.cover].joined(separator: ", ")
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : params])
            .start(completionHandler:  { (connection, result, error) in
                if let result = result as? NSDictionary{
                    self.saveCurrentUserProfile(result)
                }
            })
    }
    
    
    

}



















