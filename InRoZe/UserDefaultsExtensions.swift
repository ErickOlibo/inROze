//
//  UserDefaultsExtensions.swift
//  InRoZe
//
//  Created by Erick Olibo on 15/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation


public struct RequestDate {
    static let toFacebook = "RequestDateToFacebook"
    static let toServer = "RequestDateToServer"
    
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
        let currentTime = NSDate()
        if (lastRequest == RequestDate.toFacebook) {
            interval = IntervalBetweenRequest.toFacebook
        } else {
            interval = IntervalBetweenRequest.toServer
        }
        
        let lastSavedTime = object(forKey: lastRequest)
        let elapsedTime = currentTime.timeIntervalSince(lastSavedTime as? Date ?? currentTime as Date)
        print("ElapsedTime: \(elapsedTime) | Interval: \(interval)")
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
            print("Get Current CityCode")
            return string(forKey: UserKeys.cityCode ) ?? ""
        }
        set {
            print("New CityCode: \(newValue)")
            set(newValue, forKey: UserKeys.cityCode)
            synchronize()
        }
    }
}
