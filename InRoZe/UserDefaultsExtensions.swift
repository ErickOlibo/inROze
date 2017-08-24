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
    static let toServerArtist = "RequestDateToServer\(UserDefaults().currentCountryCode)"
    
}


public struct IntervalBetweenRequest {
    static let toFacebook = TimeInterval(1 * 60 * 60) // 1 hour before new update from Facebook Graph API
    static let toServer = TimeInterval(3 * 60 * 60) // 3 hours before collecting new eventIDS from server
    static let toServerArtist = TimeInterval(24 * 60 * 60) // 24 hours
}

private struct UserKeys {
    static let cityCode = "cityCode"
    static let countryCode = "countryCode"
}


private func cityToCountryCode(cityCode: String) -> String {
    switch cityCode.uppercased() {
        case "TLN":
        return "EE"
        case "HEL":
        return "FI"
        case "STO":
        return "SE"
        
    default:
        return "EE"
    }
}




extension UserDefaults {
    

    
    
    public func hasEnoughTimeElapsed(since lastRequest: String) -> Bool {
        var interval = TimeInterval()
        var fromWhere: String
        let currentTime = NSDate()
        if (lastRequest == RequestDate.toFacebook) {
            fromWhere = "FACEBOOK"
            interval = IntervalBetweenRequest.toFacebook
        } else if (lastRequest == RequestDate.toServer) {
            fromWhere = "SERVER"
            interval = IntervalBetweenRequest.toServer
        } else {
            fromWhere = "SERVER_ARTISTS"
            interval = IntervalBetweenRequest.toServerArtist
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
        print("[UserDefaultsExtension] - SetDateNow for: \(requestDate)")
        synchronize()
    }
    
    public func isDateSet(for requestDate: String) -> Bool {
        if (object(forKey: requestDate) != nil) {
            print("[UserDefaultsExtension] - isDateSet: TRUE - date: \(object(forKey: requestDate) as! Date)")
            return true
        } else {
            print("[UserDefaultsExtension] - isDateSet: FALSE")
            return false
        }
      
    }
    
    public var currentCityCode: String {
        get {
            //print("[UserDefaultsExtension] - Get Current CityCode")
            return string(forKey: UserKeys.cityCode ) ?? "TLN" //always Tallinn as default cityCode
        }
        set {
            print("[UserDefaultsExtension] - New CityCode: \(newValue)")
            set(newValue, forKey: UserKeys.cityCode)
            
            // set the currentCountryCode accordingly 
            let countryCode = cityToCountryCode(cityCode: newValue)
            set(countryCode, forKey: UserKeys.countryCode)
            synchronize()
        }
    }
    
    public var currentCountryCode: String {
        get {
            //print("[UserDefaultsExtension] - Get Current CityCode")
            return string(forKey: UserKeys.countryCode ) ?? "EE" //always Tallinn as default cityCode
        }
        
    }
    
    
    
    
    
}















