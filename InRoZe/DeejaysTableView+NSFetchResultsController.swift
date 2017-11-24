//
//  DJsTableView+NSFetchResultsController.swift
//  InRoZe
//
//  Created by Erick Olibo on 22/11/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher

extension DeejaysViewController
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
        let cell = tableView.dequeueReusableCell(withIdentifier: DJsSearchCell.identifier, for: indexPath) as! DJsSearchCell
        cell.tag = indexPath.row
        
        cell.deejay = fetchResultsController.object(at: indexPath)
        return cell
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "DJs to Deejay Gigs List") {
            guard let djCell = sender as? DJsSearchCell else { return }
            guard let destination = segue.destination as? DeejayGigsTableViewController else { return }
            let thisDJ = djCell.deejay!
            destination.artist = thisDJ
            destination.navigationItem.title = thisDJ.name ?? ""
        }
        
    }
    
    
}
