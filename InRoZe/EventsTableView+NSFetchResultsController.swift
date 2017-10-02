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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? EventTableViewDeejayCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(tableViewCell.self, forRow: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var thisCellIdentifier = eventCellDefault
        // conditional cell
        
        let event = fetchResultsController.object(at: indexPath)
        
        if let performerCount = event.performers?.count, performerCount > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: eventCellDeejay, for: indexPath) as! EventTableViewDeejayCell
            // configure cell
            cell.event = event
            cell.selectionStyle = .none
//            cell.eventCover.sd_setImage(with: URL(string: event.imageURL! )) { (image, error, cacheType, imageURL) in
//                if (image != nil) {
//                    cell.eventCover.image = image
//                }
//            }
//            cell.locationCover.sd_setImage(with: URL(string: event.location!.profileURL! )) { (image, error, cacheType, imageURL) in
//                if (image != nil) {
//                    cell.locationCover.image = image
//                }
//            }
            cell.eventTimeLocation.attributedText = dateTimeLocationFormatter(with: event)
            cell.eventTitle.text = event.name
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: eventCellDefault, for: indexPath) as! EventTableViewDefaultCell
            // configure cell
            cell.event = event
            cell.selectionStyle = .none
//            cell.eventCover.sd_setImage(with: URL(string: event.imageURL! )) { (image, error, cacheType, imageURL) in
//                if (image != nil) {
//                    cell.eventCover.image = image
//                }
//            }
//            cell.locationCover.sd_setImage(with: URL(string: event.location!.profileURL! )) { (image, error, cacheType, imageURL) in
//                if (image != nil) {
//                    cell.locationCover.image = image
//                }
//            }
            cell.eventTimeLocation.attributedText = dateTimeLocationFormatter(with: event)
            cell.eventTitle.text = event.name
            return cell
        }
 
    }
    
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell pressed at indexPath Row [\(indexPath.row)]")
    }
    
    // SECTION for Height at index path
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let event = fetchResultsController.object(at: indexPath)
//        if let performerCount = event.performers?.count, performerCount > 0 {
//            return cellHeightDeejays
//        } else {
//            return cellHeightDefault
//        }
//    }
    
//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        let event = fetchResultsController.object(at: indexPath)
//        if let performerCount = event.performers?.count, performerCount > 0 {
//            return cellHeightDeejays
//        } else {
//            return cellHeightDefault
//        }
//    }


    // - Mark - Navigation
    
    // list of segue to be done here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Deejay Gigs List" {
            if let djsCollectionCell = sender as? EventDJsCollectionViewCell {
                if let _ = djsCollectionCell.superview as? UICollectionView {
                    if let destination = segue.destination as? DeejayGigsTableViewController {
                        let thisDJ = djsCollectionCell.thisDJ!
                        destination.artist = thisDJ
                        destination.navigationItem.title = thisDJ.name!
                    }
                }
            }
        }
    }

   
}

