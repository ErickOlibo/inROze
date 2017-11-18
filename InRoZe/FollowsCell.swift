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
    var lastCell: Bool = false
    var colors: UIImageColors? { didSet { configureCellForColors() } }

    // for last Cell vertical separator
    let thick: CGFloat = 4.0
    let color = Colors.logoRed.cgColor
    let lengthFromTop: CGFloat = 25.0
    
    // context & container
    //var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    
    
    // OUtlets
    @IBOutlet weak var verticalSeparator: UIView!
    @IBOutlet weak var dashedSeparator: UIView!
    @IBOutlet weak var dateCircle: UIView!
    @IBOutlet weak var deejaysTitleBar: UIView!
    @IBOutlet weak var eventCover: UIImageView!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var deejaysList: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    
    

    private func configureCellForColors() {
        
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
        cellSeparator(isLast: false)
        //guard let event = event else { return }
        setTimeDate()
        
        guard let locationName = event?.location?.name else { return }
        eventCover.layoutIfNeeded()
        selectionStyle = .none
        eventLocation.text = locationName
        
        //guard let imageURL = event.imageURL else { return }
        //eventCover.kf.setImage(with: URL(string: imageURL), options: [.backgroundDecode])
    }
    
    private func circleDashBandColor(withColor color: UIColor) {
        dateCircle.layer.borderColor = color.cgColor
        dashedSeparator.backgroundColor = color
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
        
        let monthAttributed = coloredString(splitStart.month.uppercased(), color: .black)
        let dayAttributed = coloredString(splitStart.day.uppercased(), color: .black)
        
        let attributeOne =  [ NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Bold", size: 18.0)!, NSAttributedStringKey.foregroundColor: Colors.logoRed ]
        
        let number = "\n\(splitStart.num)\n"
        let attrNumber = NSAttributedString(string: number, attributes: attributeOne)
        
        let dateAttributed = NSMutableAttributedString()
        dateAttributed.append(dayAttributed)
        dateAttributed.append(attrNumber)
        dateAttributed.append(monthAttributed)
        eventDate.attributedText = dateAttributed
    
    }
    
    

    // Vertical separator constructor
    private func cellSeparator(isLast last: Bool) {
        if (last) {
            verticalSeparator.backgroundColor = .white
            verticalSeparator.addBorder(lengthFromStart:lengthFromTop, toSide: .Left, withColor: color, andThickness: thick)
        } else {
            verticalSeparator.backgroundColor = Colors.logoRed
        }
    }

    
}











