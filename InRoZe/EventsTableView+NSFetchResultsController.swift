//
//  EventsTableView+NSFetchResultsController.swift
//  InRoZe
//
//  Created by Erick Olibo on 22/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher

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
        let cell = tableView.dequeueReusableCell(withIdentifier: EventDeejayCell.identifier, for: indexPath) as! EventDeejayCell
        cell.tag = indexPath.row
        
        let event = fetchResultsController.object(at: indexPath)
        cell.event = event
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell pressed at indexPath Row [\(indexPath.row)]")
    }
    
    // SECTION for Height at index path
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let event = fetchResultsController.object(at: indexPath)
//        if let performerCount = event.performers?.count, performerCount > 0 {
//            return cellHeightForDeejay
//        } else {
//            return cellHeightForDefault
//        }
//    }

    // - Mark - Navigation
    
    // list of segue to be done here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "Deejay Gigs List" else { return }
        guard let deejayNameCell = sender as? EventDJNameCell else { return }
        guard let _ = deejayNameCell.superview as? UICollectionView else { return }
        guard let destination = segue.destination as? DeejayGigsTableViewController else { return }
        
        let thisDJ = deejayNameCell.thisDJ!
        destination.artist = thisDJ
        destination.navigationItem.title = thisDJ.name!

    }
    
}













