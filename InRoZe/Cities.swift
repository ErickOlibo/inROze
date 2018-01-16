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


// ********************************
// Protocol to render enum hasable and allow a allCases to Array
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


// Enumeration of code and name for the City switch from the app
public enum CityCode: String, EnumCollection {
    case HKI, TLN, BRU
}

// This is the function that needs constant Syncing with
// added Cities
public func cityCodeType(fromString code: String) -> CityCode {
    switch code {
    case CityCode.HKI.rawValue:
        return .HKI
    case CityCode.TLN.rawValue:
        return .TLN
    case CityCode.BRU.rawValue:
        return .BRU
    default:
        return .TLN
    }
}

public enum CityName: String, EnumCollection {
    case Helsinki, Tallinn, Brussels
}

public enum CountryName: String, EnumCollection {
    case Finland, Estonia, Belgium
}

public enum CountryCode: String, EnumCollection {
    case FI, EE, BE
}

public enum Nationality: String, EnumCollection {
    case Finnish, Estonian, Belgian
}

public enum LocalTimeZone: String, EnumCollection {
    case Helsinki = "Europe/Helsinki"
    case Tallinn = "Europe/Tallinn"
    case Brussels = "Europe/Brussels"
}


public struct City {
    var name: CityName
    var code: CityCode
    var countryName: CountryName
    var countryCode: CountryCode
    var nationality: Nationality
    var timeZone: LocalTimeZone
}


public var currentCity: City {
    //print("Cities -> CurrentCity: what's in UserDefault at 1st launch: ", UserDefaults().currentCityCode)
    let currentCityCodeType = cityCodeType(fromString: UserDefaults().currentCityCode)
    return cityInfo(forCode: currentCityCodeType)
}


// Convenient Methods
public func cityInfo (forCode: CityCode) -> City {
    switch forCode {
    case .HKI:
        return City(name: .Helsinki, code: .HKI, countryName: .Finland, countryCode: .FI, nationality: .Finnish, timeZone: .Helsinki)
    case .TLN:
        return City(name: .Tallinn, code: .TLN, countryName: .Estonia, countryCode: .EE, nationality: .Estonian, timeZone: .Tallinn)
    case .BRU:
        return City(name: .Brussels, code: .BRU, countryName: .Belgium, countryCode: .BE, nationality: .Belgian, timeZone: .Brussels)
    }
}


public func availableCities() -> [String] {
    let cities = CityName.allValues.map { $0.rawValue.capitalized }
    return cities.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
}

public func availableCitiesCode() -> [String] {
    let cities = CityCode.allValues.map { $0.rawValue }
    return cities.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
}

public func deletelistCitiesAndCurrent() -> [(String, Bool)] {
    let cities = availableCities()
    let currentCityCodeType = cityCodeType(fromString: UserDefaults().currentCityCode)
    let currentCity = cityInfo(forCode: currentCityCodeType)
    var listAndCurrent = [(String, Bool)]()
    
    for city in cities {
        if city != currentCity.name.rawValue {
            listAndCurrent.append((city, false))
        } else {
            listAndCurrent.append((city, true))
        }
    }
    return listAndCurrent
}

public func listCitiesInfo() -> [(name: String, code: String, cityInfo: City, current: Bool)] {
    let citiesCode = availableCitiesCode()
    var cities = [City]()
    for code in citiesCode {
        cities.append(cityInfo(forCode: cityCodeType(fromString: code)))
    }
    var listOfCities = [(name: String, code: String, cityInfo: City, current: Bool)]()
    for city in cities {
        if city.code != currentCity.code {
            listOfCities.append((name: city.name.rawValue, code: city.code.rawValue, cityInfo: city, current: false))
        } else {
            
            listOfCities.append((name: city.name.rawValue, code: city.code.rawValue, cityInfo: city, current: true))
        }
    }
    let newList = listOfCities.sorted(by: { $0.name < $1.name })
    return newList
}



























