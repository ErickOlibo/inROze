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
        
        guard let tableViewCell = cell as? EventDeejayCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(tableViewCell.self, forRow: indexPath.row)
        let event = fetchResultsController.object(at: indexPath)
        tableViewCell.event = event
        //print("[\(indexPath.row)] [\(event.location!.name!)] - EndTime: [\(event.endTime ?? NSDate())] time now: [\(NSDate())]")
        tableViewCell.selectionStyle = .none
        tableViewCell.eventCover.sd_setImage(with: URL(string: event.imageURL! )) { (image, error, cacheType, imageURL) in
            if (image != nil) { tableViewCell.eventCover.image = image } }
        tableViewCell.locationCover.sd_setImage(with: URL(string: event.location!.profileURL! )) { (image, error, cacheType, imageURL) in
            if (image != nil) { tableViewCell.locationCover.image = image } }
        tableViewCell.eventTimeLocation.attributedText = dateTimeLocationFormatter(with: event)
        tableViewCell.eventTitle.text = event.name
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventDeejayCell.identifier, for: indexPath) as! EventDeejayCell
        return cell
    }
    
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell pressed at indexPath Row [\(indexPath.row)]")
    }
    
    // SECTION for Height at index path
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let event = fetchResultsController.object(at: indexPath)
        if let performerCount = event.performers?.count, performerCount > 0 {
            return cellHeightDeejays
        } else {
            return cellHeightDefault
        }
    }


    // - Mark - Navigation
    
    // list of segue to be done here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Deejay Gigs List" {
            if let deejayNameCell = sender as? EventDJNameCell {
                if let _ = deejayNameCell.superview as? UICollectionView {
                    if let destination = segue.destination as? DeejayGigsTableViewController {
                        let thisDJ = deejayNameCell.thisDJ!
                        destination.artist = thisDJ
                        destination.navigationItem.title = thisDJ.name!
                    }
                }
            }
        }
    }

   
}

