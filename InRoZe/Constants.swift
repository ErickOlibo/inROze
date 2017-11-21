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
    // Inroze 9 + 2 colors (HEX string color)
    struct InrozeHexColor {
        
        // Logo colors
        static let petal = "#FFA700"
        static let sepal = "#D23900"

        // Other Colors
        static let facebook = "#3B5998"
        static let instagram = "#BC2A8D"
        static let twitter = "#00ACED"
        static let logoOrange = "#FFA700"
        static let logoRed = "#D23900"
        static let logoYellow = "#FED377"
        static let logoBrown = "#5A1208"
        static let logoBlack = "#2A2A2A"
        
    }
    
    // Inroze 9 + 2 colors (UIColor)
    struct InrozeColor {
    
        // Logo colors
        static let petal = UIColor.convertToUIColor(fromHexColor: InrozeHexColor.petal)
        static let sepal = UIColor.convertToUIColor(fromHexColor: InrozeHexColor.sepal)
        

        
        
    }
    
}

private struct InrozeHexColor {
    
    // OLD logo color
    static let petal = "#FFA700"
    static let sepal = "#D23900"
    
    // Other Colors
    static let facebook = "#3B5998"
    static let instagram = "#BC2A8D"
    static let twitter = "#00ACED"
    static let logoOrange = "#FFA700"
    static let logoRed = "#D23900"
    static let logoYellow = "#FED377"
    static let logoBrown = "#5A1208"
    static let logoBlack = "#2A2A2A"
    
}

// Colors are convenience Constant UIColors throughout the whole app
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
    
    static let followCoverRatio = CGFloat(1) / 3
    static let followTopSpacing: CGFloat = 45 // 10 + 30 + 5
    static let followBottomSpacing: CGFloat = 10
    
    
}

public var eventCoverHeight: CGFloat = {
    return ((CellSize.phoneSizeWidth - CellSize.marginWidth) / CellSize.coverRatio).rounded(.down)
}()

public var cellHeightForDefault: CGFloat = {
    return CellSize.topAreaHeight + ((CellSize.phoneSizeWidth - CellSize.marginWidth) / CellSize.coverRatio).rounded(.down)
}()

public var cellHeightForDeejay: CGFloat = {
    return CellSize.topAreaHeight + ((CellSize.phoneSizeWidth - CellSize.marginWidth) / CellSize.coverRatio).rounded(.down) + CellSize.djAreaHeight
}()

public var cellHeightForDJList: CGFloat = {
   return CellSize.topAreaHeight + ((CellSize.phoneSizeWidth - CellSize.marginWidth) / CellSize.coverRatio).rounded(.down) + CellSize.deejaysListHeight + CellSize.listTopBottonspacing
}()

public var cellHeightForFollows: CGFloat = {
    return CellSize.followTopSpacing + CellSize.followBottomSpacing + ((CellSize.phoneSizeWidth * CellSize.followCoverRatio) / CellSize.coverRatio).rounded(.down)
}()



// City random background image
public func randomCityBackground () -> UIImage? {
    let numberOfImages: UInt32 = 4 // current number of images for cities
    let imageName = "NewCity\(arc4random_uniform(numberOfImages) + 1)"
    return UIImage(named: imageName)
}


// HELPERS Functions and Extensions
public struct ColorInHexFor {
    static let facebook = "#B5998"
    static let instagram = "#BC2A8D"
    static let twitter = "#00ACED"
    static let logoOrange = "#FFA700"
    static let logoRed = "#D23900"
    static let logoYellow = "#FED377"
    static let logoBrown = "#5A1208"
    static let logoBlack = "#2A2A2A"
    
    
}



// TimeZone identifiers for selected country/cities

public struct AppTimeZone {
    
}



































