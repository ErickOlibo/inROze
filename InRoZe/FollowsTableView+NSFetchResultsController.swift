//
//  FollowsTableView+NSFetchResultsController.swift
//  InRoZe
//
//  Created by Erick Olibo on 17/11/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher


extension FollowsViewController
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
        let cell = tableView.dequeueReusableCell(withIdentifier: FollowsCell.identifier, for: indexPath) as! FollowsCell
        cell.tag = indexPath.row
        cell.lastCell = (numberEvents - indexPath.row - 1) == 0
        let thisEvent = fetchResultsController.object(at: indexPath)
        cell.event = thisEvent
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Follow Cell pressed at indexPath Row [\(indexPath.row)]")
    }
    
    
    
    // Mark - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Preparing for segue in Follows")
    }
}
