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
    var event: Event? { didSet { configureCell() } }
    var colors: UIImageColors? { didSet { configureCellForColors() } }
    var cleanCell: Bool = false

    // context & container
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    
    
    // OUtlets
    @IBOutlet weak var deejaysTitleBar: UIView!
    @IBOutlet weak var eventCover: UIImageView!
    @IBOutlet weak var deejaysList: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    
    // Methods
    private func configureCellForColors() {
        print("COLORS ARE SET - configureCellForColors")
        guard let background = colors?.background else { return }
        guard let primary = colors?.primary else { return }
        guard let secondary = colors?.secondary else { return }
        
        // here for the cell design color
        if (background.isWhiteColor) {
            setDeejaysText(withColor: background)
            circleDashBandColor(withColor: secondary)
        } else {
            setDeejaysText(withColor: primary)
            circleDashBandColor(withColor: background)
        }
    }
    
    private func configureCell() {
        print("EVENT IS SET - configureCell")
        setTimeDate()
        guard let locationName = event?.location?.name else { return }
        eventCover.layoutIfNeeded()
        selectionStyle = .none
        eventLocation.text = locationName
    }
    
    
    private func circleDashBandColor(withColor color: UIColor) {
        deejaysTitleBar.backgroundColor = color
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
    
    private func setTimeDate() {
        guard let event = event else { return }
        guard let startDate = event.startTime else { return }
        guard let endDate = event.endTime else { return }
        let splitStart = Date().split(this: startDate)
        let splitEnd = Date().split(this: endDate)
        let startTimeAttributed = coloredString(splitStart.hour, color: .black)
        let endTimeAttributed = coloredString(splitEnd.hour, color: .black)
        let spacingTimeAttributed = coloredString(" - ", color: .black)
        let timeAttributed = NSMutableAttributedString()
        timeAttributed.append(startTimeAttributed)
        timeAttributed.append(spacingTimeAttributed)
        timeAttributed.append(endTimeAttributed)
        eventTime.attributedText = timeAttributed
        
    }
    
 
    
}











