//
//  Constants.swift
//  InRoZe
//
//  Created by Erick Olibo on 26/07/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation
import UIKit

public struct Constants {
    
    
    // Possible slogan for InRoZe
    struct Slogan {
        static let one = "La Nuit En Roze!"
        static let two = "La Vie En Roze!"
        static let three = "Follow The Music"
        static let four = "Follow Your Music"
        static let five = "La Nuit En Roze, Follow Your Music!"
        static let six = "La Nuit En Roze, Follow The Music!"
    }
    
    // Inroze 9 + 2 colors (HEX string color)
    struct InrozeHexColor {
        
        // Logo colors
        static let petal = "#FFA700"
        static let sepal = "#D23900"
        
        // 9 senses (inroze v1.0) colors
        static let one = "#4D4F83"
        static let two = "#640F6C"
        static let three = "#BE3C26"
        static let four = "#484848"
        static let five = "#BB4E82"
        static let six = "#855146"
        static let seven = "#F67F00"
        static let eight = "#E43539"
        static let nine = "#028C01"
    }
    
    // Inroze 9 + 2 colors (UIColor)
    struct InrozeColor {
    
        // Logo colors
        static let petal = UIColor.changeHexStringToColor(InrozeHexColor.petal)
        static let sepal = UIColor.changeHexStringToColor(InrozeHexColor.sepal)
        
        // 9 senses (inroze v1.0) colors
        static let one = UIColor.changeHexStringToColor(InrozeHexColor.one)
        static let two = UIColor.changeHexStringToColor(InrozeHexColor.two)
        static let three = UIColor.changeHexStringToColor(InrozeHexColor.three)
        static let four = UIColor.changeHexStringToColor(InrozeHexColor.four)
        static let five = UIColor.changeHexStringToColor(InrozeHexColor.five)
        static let six = UIColor.changeHexStringToColor(InrozeHexColor.six)
        static let seven = UIColor.changeHexStringToColor(InrozeHexColor.seven)
        static let eight = UIColor.changeHexStringToColor(InrozeHexColor.eight)
        static let nine = UIColor.changeHexStringToColor(InrozeHexColor.nine)
        
        
    }
    
    static func colorOf(day: String) -> UIColor {
        switch day.uppercased() {
            
        case "MON":
            return InrozeColor.one
        case "TUE":
            return InrozeColor.two
        case "WED":
            return InrozeColor.six
        case "THU":
            return InrozeColor.three
        case "FRI":
            return InrozeColor.five
        case "SAT":
            return InrozeColor.eight
        case "SUN":
            return InrozeColor.nine
        case "FOLLOW":
            return InrozeColor.sepal
            
            
        default:
            return UIColor.black
        }
    }
    
}

// Colors as UIColor as constant
public struct Colors {
    static let isFollowed: UIColor = Constants.InrozeColor.sepal
    static let isNotFollowed: UIColor = .lightGray
    static let logoRed: UIColor = Constants.InrozeColor.sepal
}


// height of the cell depending on the device size and resolution

public struct CellSize {
    static let topAreaHeight: CGFloat = 63 // from 70
    static let phoneSizeWidth = UIScreen.main.bounds.width
    static let coverRatio = CGFloat(16) / 9
    static let marginWidth: CGFloat = 20 * 2
    static let djAreaHeight: CGFloat = 100
    static let deejaysListHeight: CGFloat = 48 // from 50
    static let listTopBottonspacing: CGFloat = 2 * 10
}

var eventCoverHeight: CGFloat = {
    return ((CellSize.phoneSizeWidth - CellSize.marginWidth) / CellSize.coverRatio).rounded(.down)
}()

var cellHeightForDefault: CGFloat = {
    return CellSize.topAreaHeight + ((CellSize.phoneSizeWidth - CellSize.marginWidth) / CellSize.coverRatio).rounded(.down)
}()

var cellHeightForDeejay: CGFloat = {
    return CellSize.topAreaHeight + ((CellSize.phoneSizeWidth - CellSize.marginWidth) / CellSize.coverRatio).rounded(.down) + CellSize.djAreaHeight
}()

var cellHeightForDJList: CGFloat = {
   return CellSize.topAreaHeight + ((CellSize.phoneSizeWidth - CellSize.marginWidth) / CellSize.coverRatio).rounded(.down) + CellSize.deejaysListHeight + CellSize.listTopBottonspacing
}()



// City random background image
public func randomCityBackground () -> UIImage? {
    let numberOfImages: UInt32 = 4 // current number of images for cities
    let imageName = "NewCity\(arc4random_uniform(numberOfImages) + 1)"
    return UIImage(named: imageName)
}


// HELPERS Functions and Extensions
public struct ColorInHexFor {
    static let facebook = "3B5998"
    static let instagram = "BC2A8D"
    static let twitter = "00ACED"
    static let logoOrange = "FFA700"
    static let logoRed = "D23900"
    static let logoYellow = "FED377"
    static let logoBrown = "5A1208"
    static let logoBlack = "2A2A2A"
    
    
}




// User Default simple database
extension UserDefaults {
    
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


// manage the colors and image for Deejay's profile pic
public func profileImageForDJ(with id: String, when isFollowed: Bool) -> String {
    let lastTwo = id.suffix(2)
    // for animals -> ("LetterColor_" : "LetterGrey_")
    // for people -> ("Color_P_Letter_" : "Grey_P_Letter_")
    // for images -> ("Color_P_Letter_" : "Grey_P_Letter_")
    // for 100 pics -> with String from the DJ CoverName("Color_" : "Grey_")
    let colorOrGrey = (isFollowed) ? "img_Color_DJcover_" : "img_Grey_DJcover_"
    return colorOrGrey + lastTwo
}



// TimeZone identifiers for selected country/cities

public struct AppTimeZone {
    
}



































