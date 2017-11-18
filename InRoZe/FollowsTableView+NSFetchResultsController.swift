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
        //cell.lastCell = (fetchResultsController.fetchedObjects?.count ?? 0 - indexPath.row - 1) == 0
        let event = fetchResultsController.object(at: indexPath)
        cell.event = event
        
        // EventCover and Colors Setting
        // EventCover and Colors setting
        guard let imageURL = event.imageURL else { return cell }
        cell.eventCover.kf.setImage(with: URL(string: imageURL), options: [.backgroundDecode]) {
            (image, error, cachetype, imageUrl) in
            
            if (image != nil) {
                // Conditional Settings for Colors (3 options)
                if (event.primary != nil && event.secondary != nil && event.detail != nil && event.background != nil) {
                    // *** Option 1 - Colors ALREADY IN DATABASE ==> NOTHING TO DO
                    //print("[row: \(indexPath.row)] | Option 1) - COLORS already in database Nothing to do")
                    let colorsInHex = ColorsInHexString(background: event.background!, primary: event.primary!, secondary: event.secondary!, detail: event.detail!)
                    let colors = colorsFromHexString(with: colorsInHex)
                    cell.colors = colors
                    
                } else if let colors = self.colorsOfEventCovers[event.id!]{
                    //print("[row: \(indexPath.row)] | Option 2) - COLORS in the EventCovers Dictionary")
                    cell.colors = colors
                } else {
                    //print("[row: \(indexPath.row)] | Option 3) - COLORS don't exist, so Create them")
                    image?.getColors(scaleDownSize: CGSize(width: 100, height: 100)){ [weak self] colors in
                        cell.colors = colors
                        // append to Event Dictionarry
                        self?.colorsOfEventCovers[event.id!] = colors
                    }
                }
            }
        }
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
