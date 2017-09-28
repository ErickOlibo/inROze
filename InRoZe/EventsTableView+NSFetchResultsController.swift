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
        guard let tableViewCell = cell as? EventTableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(tableViewCell.self, forRow: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: eventCell, for: indexPath) as! EventTableViewCell
        
        // Configure the cell...
        let event = fetchResultsController.object(at: indexPath)
        
        // sent the whole event result to the cell
        cell.event = event
        
        cell.selectionStyle = .none
        
        
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
        
        cell.eventTimeLocation.attributedText = dateTimeLocationFormatter(with: event)
        cell.eventTitle.text = event.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // measure the cell height
        let event = fetchResultsController.object(at: indexPath)
        let performersCount = event.performers?.count ?? 0
        if (performersCount > 0) {
            let cellHeight = cellHeightDefault + performersCollectionCellHeight
            return cellHeight
        } else {
            return cellHeightDefault
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell pressed at indexPath Row [\(indexPath.row)]")
    }


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

