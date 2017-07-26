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
    static let eventNameArray = ["Create a Hight Quality, High Ranking Search Ad",
                                     "Evolve Your Ad Campaigns with Programmatic Buying",
                                     "How Remarketing Keeps Customers Coming Back",
                                     "Surviving and Thriving on Social Media",
                                     "Keep Mobile Users Engaged In and Out of Your App",
                                     "Appeal to Searchers and Search Engines with Seo",
                                     "Build Your Business Fast with Growth Hacking",
                                     "Track Your Acquisitions with Digital Metricks",
                                     "This is fuckaries and I'm not sure I'm liking it",
                                     "I'm supposed to really write 2 or 3 of them just for fun"]
    
    static let eventCoverArray = ["fb1", "fb2", "fb3", "fb4", "fb5", "fb6", "fb7", "fb8", "fb9", "fb10"]
    
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
