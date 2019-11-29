//
//  RequestHandler.swift
//  InRoZe
//
//  Created by Erick Olibo on 16/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation
//import FacebookCore
import FBSDKCoreKit



public class RequestHandler
{
    
    // MARK: - Handler to SERVER
    public func fetchEventIDsFromServer() {
        if let userID = FBSDKAccessToken.current().userID {
            let params = "id=\(userID)&cityCode=\(currentCity.code.rawValue)&countryCode=\(currentCity.countryCode.rawValue)"
            let request = ServerRequest()
            request.getEventsIDsCurrentList(parameter: params, urlToServer: UrlFor.currentEventsID)
        }
    }
    

    public func requestUserInfo() {
        let params = [FBUser.email, FBUser.name, FBUser.id].joined(separator: ", ")
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : params])
            .start(completionHandler:  { (connection, result, error) in
                if let result = result as? NSDictionary{
                    self.saveCurrentUserProfile(result)
                }
            })
    }
    
    private func saveCurrentUserProfile(_ result: NSDictionary) {
        if let id = result[FBUser.id]  as? String,
            let name = result[FBUser.name] as? String {
            
            if let _ = FBSDKAccessToken.current() {
                // Get some info about User
                let email = result[FBUser.email] as? String ?? "NO EMAIL"
                let parameters = "id=\(id)&name=\(name)&email=\(email)"
                print("PARAMETER USER: ", parameters)
                let serverRequest = ServerRequest()
                serverRequest.setUserLoggedIn(to: true, parameters: parameters, urlToServer: UrlFor.logInOut)
            }
        }
    }
}



















