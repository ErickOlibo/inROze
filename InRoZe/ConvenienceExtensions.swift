//
//  ConvenienceExtensions.swift
//  InRoZe
//
//  Created by Erick Olibo on 18/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation


// extension for type Dictionary
extension Dictionary {
    mutating func merge<K, V>(dict: [K: V]){
        for (k, v) in dict {
            self.updateValue(v as! Value, forKey: k as! Key)
        }
    }
}


// extension for the Date

extension Date {
    func split(this date: Date) -> (day: String, num: String, month: String)
    {
        let newFormatter = DateFormatter()
        newFormatter.locale = NSLocale.current
        newFormatter.dateFormat = "d"
        let splitNum = newFormatter.string(from: date)
        newFormatter.dateFormat = "MMM"
        let splitMonth = newFormatter.string(from: date)
        newFormatter.dateFormat = "E"
        let splitDay = newFormatter.string(from: date)
        
        return (splitDay, splitNum, splitMonth)
    }
}
