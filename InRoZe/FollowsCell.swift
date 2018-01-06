//
//  FollowsCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 17/11/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class FollowsCell: UITableViewCell
{

    // properties
    static var identifier: String { return String(describing: self) }
    var event: Event?
    var colors: UIImageColors? { didSet { configureCellForColors() } }
    var cleanCell: Bool = false { didSet { cleanCellBeforeUse()}}
    var coverImage: UIImage?
    private let defaultColor = UIColor.white

    // context & container
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    
    
    // OUtlets
    @IBOutlet weak var deejaysTitleBar: UIView!
    @IBOutlet weak var eventCover: UIImageView!
    @IBOutlet weak var deejaysList: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    
    // Methods
    private func cleanCellBeforeUse() {
        if (cleanCell) {
            deejaysTitleBar.backgroundColor = defaultColor
            eventCover.backgroundColor = defaultColor
            deejaysList.backgroundColor = defaultColor
            eventLocation.backgroundColor = defaultColor
            eventTime.backgroundColor = defaultColor
            
            deejaysList.textColor = defaultColor
            eventLocation.textColor = defaultColor
            eventTime.textColor = defaultColor
            eventCover.layer.borderColor = defaultColor.cgColor
            //eventCover.image = nil
        }
    }
    
    private func removeDefaultColor() {
        deejaysTitleBar.backgroundColor = .clear
        eventCover.backgroundColor = .clear
        deejaysList.backgroundColor = .clear
        eventLocation.backgroundColor = .clear
        eventTime.backgroundColor = .clear
        eventCover.layer.borderColor = UIColor.clear.cgColor
        
    }
    
    // no COLORS needed
    private func setLocation() {
        guard let locationName = event?.location?.name else { return }
        eventLocation.textColor = .black
        eventLocation.text = locationName
        //eventCover.layoutIfNeeded()
    }
    
    private func setStartEndTime() {
        guard let event = event else { return }
        guard let startDate = event.startTime else { return }
        guard let endDate = event.endTime else { return }
        let splitStart = Date().split(this: startDate)
        let splitEnd = Date().split(this: endDate)
        eventTime.textColor = .black
        eventTime.text = splitStart.hour + " - " + splitEnd.hour
    }
    
    
    // Set the image frame
    private func setCoverFrame() {
        eventCover.layer.borderColor = UIColor.black.cgColor
    }
    
    // COLORS Needed
    private func configureCellForColors() {
        removeDefaultColor()
        setLocation()
        setCoverFrame()
        setStartEndTime()
        eventCover.image = coverImage
        
        guard let background = colors?.background else { return }
        guard let primary = colors?.primary else { return }
        guard let secondary = colors?.secondary else { return }
        
        // here for the cell design color
        if (background.isWhiteColor) {
            setDeejaysText(withColor: background)
            deejaysTitleBar.backgroundColor = secondary
        } else {
            setDeejaysText(withColor: primary)
            deejaysTitleBar.backgroundColor = background
        }
    }

    
    private func setDeejaysText(withColor color: UIColor) {
        guard let deejays = event?.performers?.allObjects as? [Artist] else { return }
        let sorted = deejays.sorted(by: {$0.name! < $1.name!})
        var list = ""
        var times = 0
        for dj in sorted {
            if (dj.isFollowed) {
                if (times != 0) {
                    list += ", "
                }
                guard let name = dj.name else { return }
                list += name
                times += 1
            }
        }
        deejaysList.attributedText = coloredString(list, color: color)
    }
    
    
    
 
    
}











