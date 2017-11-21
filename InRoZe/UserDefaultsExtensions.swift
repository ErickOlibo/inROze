//
//  UserDefaultsExtensions.swift
//  InRoZe
//
//  Created by Erick Olibo on 15/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation



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
        if (object(forKey: requestDate) != nil) {
            return true
        } else {
            print("[UserDefaultsExtension] - isDateSet: FALSE")
            return false
        }
      
    }
    
    public var currentCityCode: String {
        get {
            return string(forKey: UserKeys.cityCode ) ?? "NONE" // none should only occur at the 1st launch
        }
        set {
            print("[UserDefaultsExtension] - New CityCode: \(newValue)")
            set(newValue, forKey: UserKeys.cityCode)
            
            // set the currentCountryCode accordingly 
            let countryCode = countryCodeFrom(cityCode: newValue)
            set(countryCode, forKey: UserKeys.countryCode)
            synchronize()
        }
    }
    
    public var currentCountryCode: String {
        get {
            return string(forKey: UserKeys.countryCode ) ?? "EE" //always Tallinn as default cityCode
        }
        
    }
    
    public var wasLaunchedOnce: Bool {
        get {
            print("UserDefaultExtensions isFirstLaunch is GET")
            return bool(forKey: User.launchedAlready)
        }
        set {
            set(newValue, forKey: User.launchedAlready)
        }
        
    }
    
    enum Keys: String {
        case isLoggedIn
    }
    
    func setIsLoggedIn(value: Bool) {
        set(value, forKey: Keys.isLoggedIn.rawValue)
        synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: Keys.isLoggedIn.rawValue)
    }
    
    
}

// private struct for userdefaults only
private struct User {
    static let launchedAlready = "launchedAlready"
}















