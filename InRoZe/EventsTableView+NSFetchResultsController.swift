//
//  EventsTableView+NSFetchResultsController.swift
//  InRoZe
//
//  Created by Erick Olibo on 22/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

extension EventsViewController
{
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchResultsController.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: eventCell, for: indexPath) as! EventTableViewCell
        
        
        // Configure the cell...
        let event = fetchResultsController.object(at: indexPath)
        cell.event = event
        cell.eventTitle.text = event.name
        
        // Event cover image
        cell.eventCover.sd_setImage(with: URL(string: event.imageURL! )) { (image, error, cacheType, imageURL) in
            if (image != nil) {
                cell.eventCover.image = image
            }
        }
        
        // place cover image
        cell.locationCover.sd_setImage(with: URL(string: event.location!.profileURL! )) { (image, error, cacheType, imageURL) in
            if (image != nil) {
                cell.locationCover.image = image
            }
        }
        
        // starting time
        let splitDate = Date().split(this: event.startTime! as Date)
        let dateTimeText = "\(splitDate.day), \(splitDate.num) \(splitDate.month) - \(splitDate.hour) @ "
        let locationNameAttributedText = coloredString(event.location!.name!, color: .black)
        let dateTimeAttributedText = coloredString(dateTimeText, color: .gray)
        let combinedAttributedText = NSMutableAttributedString()
        
        combinedAttributedText.append(dateTimeAttributedText)
        combinedAttributedText.append(locationNameAttributedText)
        cell.eventTimeLocation.attributedText = combinedAttributedText
        //cell.eventTimeLocation.text = "\(splitDate.day), \(splitDate.num) \(splitDate.month) - \(splitDate.hour) @ \(event.location!.name!)"

        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
   
}

