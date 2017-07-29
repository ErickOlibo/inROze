//
//  FacebookEvents.swift
//  InRoZe
//
//  Created by Erick Olibo on 26/07/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation


public struct FacebookEvents {
    
    // these are temporary data source for offline testing and 
    // UI & UX testing

    static let eventNameArray = ["Monatik in Tallinn",
                                 "OU SNAP! YouTüübid ft. Martins Lapins & Kapabeibe",
                                 "Studio Boat Party 26.07",
                                 "SUME suvefestival: Youngr [UK] / NOËP",
                                 "Studio Base 29.07",
                                 "Sunset Live pres. 2Quick Start - Speedest Afterparty!",
                                 "Good Vibes I 28.07 I Privé",
                                 "Saturday I 29.07 I KRIIM goes Live: PK albumi esitlus!",
                                 "30+ vol 5 ehk suve-eri Pärnus!",
                                 "NELLY / 26.10.2017 / Cathouse Kontserthall (Tallinn)"]
    
    
    static let eventCoverArray = ["fb1", "fb2", "fb3", "fb4", "fb5", "fb6", "fb7", "fb8", "fb9", "fb10"]
    static let eventLocationArray = ["CatHouse", "Club Hollywood", "Studio", "Pada", "Studio",
                                     "Sunset", "Privé", "Privé", "Sunset", "CatHouse"]
    
    static let eventFeeArray = ["FREE to 20€", "0€/17€/100€", "Free for All", "123€", "12€/18€/29€",
                         "FREE to 20€", "0€/17€/100€", "Free for All", "123€", "12€/18€/29€"]
    
    
    // Simulate dates Data Source
    
    static func getEventDate () -> (day: String, num: Int, month: String) {
        let dayArray = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        let monthArray = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let rdDay = dayArray[Int(arc4random_uniform(UInt32(dayArray.count)))]
        let rdMonth = monthArray[Int(arc4random_uniform(UInt32(monthArray.count)))]
        let rdNum = Int(arc4random_uniform(28)) + 1 // from 1 to 28 included
        
        return (rdDay, rdNum, rdMonth)
    }
    
    
    
    
    
}

// Make array of event dates

func makeArray<Item>(repeating item: Item, numberOfTimes: Int) -> [Item] {
    var result = [Item]()
    for _ in 0..<numberOfTimes {
        result.append(item)
    }
    return result
}
