//
//  UserDefaultsExtensions.swift
//  InRoZe
//
//  Created by Erick Olibo on 15/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation


public struct RequestDate {
    static let toFacebook = "RequestDateToFacebook\(UserDefaults().currentCityCode)"
    static let toServer = "RequestDateToServer\(UserDefaults().currentCityCode)"
    
}


public struct IntervalBetweenRequest {
    static let toFacebook = TimeInterval(1 * 60 * 60) // 1 hour before new update from Facebook Graph API
    static let toServer = TimeInterval(3 * 60 * 60) // 3 hours before collecting new eventIDS from server
}

private struct UserKeys {
    static let cityCode = "cityCode"
}




extension UserDefaults {
    

    
    
    public func hasEnoughTimeElapsed(since lastRequest: String) -> Bool {
        var interval = TimeInterval()
        var fromWhere: String
        let currentTime = NSDate()
        if (lastRequest == RequestDate.toFacebook) {
            fromWhere = "FACEBOOK"
            interval = IntervalBetweenRequest.toFacebook
        } else {
            fromWhere = "SERVER"
            interval = IntervalBetweenRequest.toServer
        }
        
        let lastSavedTime = object(forKey: lastRequest)
        let elapsedTime = currentTime.timeIntervalSince(lastSavedTime as? Date ?? currentTime as Date)
        print("[UserDefaultsExtension] - From: \(fromWhere) | ElapsedTime: \(elapsedTime) | Interval: \(interval)")
        if (elapsedTime <= interval) { return false }
        
        return true
    }
    
    
    
    public func setDateNow(for requestDate: String) {
        let dateNow = NSDate()
        set(dateNow, forKey: requestDate)
        synchronize()
    }
    
    public func isDateSet(for requestDate: String) -> Bool {
        return (object(forKey: requestDate) != nil)
      
    }
    
    public var currentCityCode: String {
        get {
            print("[UserDefaultsExtension] - Get Current CityCode")
            return string(forKey: UserKeys.cityCode ) ?? "TLN" //always Tallinn as default cityCode
        }
        set {
            print("[UserDefaultsExtension] - New CityCode: \(newValue)")
            set(newValue, forKey: UserKeys.cityCode)
            synchronize()
        }
    }
}
