//
//  EventDeejayCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 02/10/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData


class EventDeejayCell: UITableViewCell
{
    static var identifier: String { return String(describing: self) }
    var event: Event? { didSet { configureCell() } }
    
    // context & container
    //var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    
    // outlets to the UI components in the custom UITableViewCell
    @IBOutlet weak var eventCover: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventTimeLocation: UILabel!
    @IBOutlet weak var deejaysList: UILabel!

    private func configureCell() {
        guard let event = event else { return }
        guard let name = event.name else { return }
        eventCover.layoutIfNeeded()
        selectionStyle = .none
        eventTimeLocation.attributedText = dateTimeLocationFormatter(with: event)
        eventTitle.text = name
        deejaysList.attributedText = deejaysListAttributed(for: event)
        
        //guard let imageURL = event.imageURL else { return }
        //eventCover.kf.setImage(with: URL(string: imageURL), options: [.backgroundDecode])
    }

    
}


