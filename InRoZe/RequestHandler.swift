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


/* Handles all the request calls to the Facebook Graph API
 * and the InRoZe server API. The frequency of a call to a API
 * is control here via the userDefaultsExtension file
 */


public class RequestHandler
{
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
                print(params)
                
            }
        }
    }
    
    // request fetch EventIDs from CityCode server
    public func fetchEventIDsFromServerTest() {
        let userDefault = UserDefaults()
        if let userID = AccessToken.current?.userId {
            let params = "id=\(userID)&cityCode=\(userDefault.currentCityCode)"
            let request = ServerRequest()
            request.getEventsIDsCurrentList(parameter: params, urlToServer: UrlFor.currentEventsID)
            print(params)
            
        }
       
    }
    
    
    
    
}
