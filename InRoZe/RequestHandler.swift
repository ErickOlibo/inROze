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
        
        // Conditions of execution
        if (true) {
            if let userID = AccessToken.current?.userId {
                let params = "id=\(userID)&cityCode="
                let request = ServerRequest()
                request.getEventsIDsCurrentList(parameter: params, urlToServer: UrlFor.currentEventsID)
                print(params)
                
            }
        }
    }
    
    
    
    
    
    
}
