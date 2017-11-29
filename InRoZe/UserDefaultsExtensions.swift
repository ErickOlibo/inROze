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
    
    public var isLoggedIn: Bool {
        get {
            return bool(forKey: UserKeys.isLoggedIn)
        }
        set {
            set(newValue, forKey: UserKeys.isLoggedIn)
        }
    }
    
    // This is a 3 letters City code, connected to Airport naming standard => Tallinn = TLN
    public var currentCityCode: String {
        get {
            return string(forKey: UserKeys.cityCode ) ?? "NONE" // none should only occur at the 1st launch
        }
        set {
            print("[UserDefaultsExtension] - New CityCode: \(newValue)")
            set(newValue, forKey: UserKeys.cityCode)
            synchronize()
        }
    }
    
    
//    
//    
//    
//    //************************************************* DELETE
//    // BELOW are a list of VAR that should be erased
//    // This is the 2 letter Country code, connected to the internet Standard => Estonia = EE
//    public var currentCountryCode: String {
//        get {
//            return string(forKey: UserKeys.countryCode ) ?? "EE" //always Tallinn as default cityCode
//        }
//        
//    }
//    
//    // This get the current city name the user has selected
//    public var currentCityName: String {
//        get {
//            return cityNameFrom(cityCode: UserDefaults().currentCityCode)
//        }
//    }
//    
//    // This gets the current country name the user has the city selected
//    public var currentCountryName: String {
//        get {
//            return countryNameFrom(cityCode: UserDefaults().currentCityCode)
//        }
//    }
//    
//    // This gets the Nationality from the current CityCode
//    public var currentNationality: String {
//        get {
//            return nationalityFrom(countryCode: UserDefaults().currentCountryCode)
//        }
//    }
//    //*************************************************
//    
//    
//    

    
}



// private struct for UserDefaults only
public struct UserKeys {
    static let cityCode = "cityCode"
    static let countryCode = "countryCode"
    static let isLoginNow = "isLoginNow"
    static let isLoggedIn = "isLoggedIn"
    
}














