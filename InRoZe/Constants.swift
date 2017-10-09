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
            
        default:
            return UIColor.black
            
            
        }
    }
    
    
}


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
    let lastTwo = id.substring(from:id.index(id.endIndex, offsetBy: -2))
    // for animals -> ("LetterColor_" : "LetterGrey_")
    // for people -> ("Color_P_Letter_" : "Grey_P_Letter_")
    // for images -> ("Color_P_Letter_" : "Grey_P_Letter_")
    // for 100 pics -> with String from the DJ CoverName("Color_" : "Grey_")
    let colorOrGrey = (isFollowed) ? "img_Color_DJcover_" : "img_Grey_DJcover_"
    return colorOrGrey + lastTwo
}

// background image for DJ profile
public func profileImageBackgroundForDJ(when isFollowed: Bool) -> String {
    return (isFollowed) ? "BackGround_Image_Followed" : "Background_Image_Notfollowed"
}


public func profileImageBackgroundColor(for deejay: String) -> UIColor {
    let firstLetter = String(deejay.uppercased().characters.first!)
    switch firstLetter {
    case "0":
        return UIColor.changeHexStringToColor(djColor.letter_0)
    case "1":
        return UIColor.changeHexStringToColor(djColor.letter_1)
    case "2":
        return UIColor.changeHexStringToColor(djColor.letter_2)
    case "3":
        return UIColor.changeHexStringToColor(djColor.letter_3)
    case "4":
        return UIColor.changeHexStringToColor(djColor.letter_4)
    case "5":
        return UIColor.changeHexStringToColor(djColor.letter_5)
    case "6":
        return UIColor.changeHexStringToColor(djColor.letter_6)
    case "7":
        return UIColor.changeHexStringToColor(djColor.letter_7)
    case "8":
        return UIColor.changeHexStringToColor(djColor.letter_8)
    case "9":
        return UIColor.changeHexStringToColor(djColor.letter_9)
        
    case "A":
        return UIColor.changeHexStringToColor(djColor.letter_A)
    case "B":
        return UIColor.changeHexStringToColor(djColor.letter_B)
    case "C":
        return UIColor.changeHexStringToColor(djColor.letter_C)
    case "D":
        return UIColor.changeHexStringToColor(djColor.letter_D)
    case "E":
        return UIColor.changeHexStringToColor(djColor.letter_E)
    case "F":
        return UIColor.changeHexStringToColor(djColor.letter_F)
    case "G":
        return UIColor.changeHexStringToColor(djColor.letter_G)
    case "H":
        return UIColor.changeHexStringToColor(djColor.letter_H)
    case "I":
        return UIColor.changeHexStringToColor(djColor.letter_I)
    case "J":
        return UIColor.changeHexStringToColor(djColor.letter_J)
    case "K":
        return UIColor.changeHexStringToColor(djColor.letter_K)
    case "L":
        return UIColor.changeHexStringToColor(djColor.letter_L)
    case "M":
        return UIColor.changeHexStringToColor(djColor.letter_M)
    case "N":
        return UIColor.changeHexStringToColor(djColor.letter_N)
    case "O":
        return UIColor.changeHexStringToColor(djColor.letter_O)
    case "P":
        return UIColor.changeHexStringToColor(djColor.letter_P)
    case "Q":
        return UIColor.changeHexStringToColor(djColor.letter_Q)
    case "R":
        return UIColor.changeHexStringToColor(djColor.letter_R)
    case "S":
        return UIColor.changeHexStringToColor(djColor.letter_S)
    case "T":
        return UIColor.changeHexStringToColor(djColor.letter_T)
    case "U":
        return UIColor.changeHexStringToColor(djColor.letter_U)
    case "V":
        return UIColor.changeHexStringToColor(djColor.letter_V)
    case "W":
        return UIColor.changeHexStringToColor(djColor.letter_W)
    case "X":
        return UIColor.changeHexStringToColor(djColor.letter_X)
    case "Y":
        return UIColor.changeHexStringToColor(djColor.letter_Y)
    case "Z":
        return UIColor.changeHexStringToColor(djColor.letter_Z)
    default:
        return .white
    }

}

// Colors for deejay profile
public struct djColor {
    static let letter_0 = "483C32"
    static let letter_1 = "A9203E"
    static let letter_2 = "004B49"
    static let letter_3 = "F0DC82"
    static let letter_4 = "3D2B1F"
    static let letter_5 = "FBCEB1"
    static let letter_6 = "007AA5"
    static let letter_7 = "5F9EA0"
    static let letter_8 = "E9D66B"
    static let letter_9 = "EFDECD"
    static let letter_A = "87A96B"
    static let letter_B = "A67B5B"
    static let letter_C = "FF9933"
    static let letter_D = "480607"
    static let letter_E = "FE6F5E"
    static let letter_F = "FFCBA4"
    static let letter_G = "B94E48"
    static let letter_H = "CC5500"
    static let letter_I = "CD9575"
    static let letter_J = "A2A2D0"
    static let letter_K = "FFBF00"
    static let letter_L = "FAD6A5"
    static let letter_M = "F4C2C2"
    static let letter_N = "4B3621"
    static let letter_O = "91A3B0"
    static let letter_P = "5D8AA8"
    static let letter_Q = "4B5320"
    static let letter_R = "B2BEB5"
    static let letter_S = "DEB887"
    static let letter_T = "8DB600"
    static let letter_U = "E9692C"
    static let letter_V = "98777B"
    static let letter_W = "536872"
    static let letter_X = "FFE4C4"
    static let letter_Y = "9F8170"
    static let letter_Z = "F2F3F4"
}






































