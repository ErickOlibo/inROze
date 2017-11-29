//
//  Cities.swift
//  InRoZe
//
//  Created by Erick Olibo on 29/11/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation

/* Handles the string enum for the change of Location within the app
 * Methods for convertion from one format (code) to literal city and country name
 *
 */


//********************************
// Protocal to render enum hasable and allow a allCases to Array
// Sample code written by Tibor Bödecs.
// Extract from the site link https://theswiftdev.com/2017/10/12/swift-enum-all-values/
// *******************************
public protocol EnumCollection: Hashable {
    static func cases() -> AnySequence<Self>
    static var allValues: [Self] { get }
}

public extension EnumCollection {
    public static func cases() -> AnySequence<Self> {
        return AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            return AnyIterator {
                let current: Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else {
                    return nil
                }
                raw += 1
                return current
            }
        }
    }
    public static var allValues: [Self] {
        return Array(self.cases())
    }
}
// ************************




