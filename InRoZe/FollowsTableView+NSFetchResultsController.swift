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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberEvents
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FollowsCell.identifier, for: indexPath) as! FollowsCell
        cell.tag = indexPath.row
        //print("Diff: [\(numberEvents - indexPath.row - 1)]")
        cell.lastCell = (numberEvents - indexPath.row - 1) == 0
        cell.event = event 
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Follow Cell pressed at indexPath Row [\(indexPath.row)]")
    }
    
}
