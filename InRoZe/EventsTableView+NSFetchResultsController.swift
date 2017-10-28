//
//  EventsTableView+NSFetchResultsController.swift
//  InRoZe
//
//  Created by Erick Olibo on 22/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData
//import SDWebImage
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = fetchResultsController.object(at: indexPath)
        
        if let count = event.performers?.count, count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: EventDeejayCell.identifier, for: indexPath) as! EventDeejayCell
            cell.tag = indexPath.row
            
            // create subset of ditDJNameView
            let artists = deejays(event: event)
            cell.djsViews = subsetNameViews(artists: artists)
            
            cell.event = event
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: EventDefaultCell.identifier, for: indexPath) as! EventDefaultCell
            cell.tag = indexPath.row
            cell.event = event
            return cell
        }
    }
    
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell pressed at indexPath Row [\(indexPath.row)]")
    }
    
    // SECTION for Height at index path
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let event = fetchResultsController.object(at: indexPath)
        if let performerCount = event.performers?.count, performerCount > 0 {
            return cellHeightForDeejay
        } else {
            return cellHeightForDefault
        }
    }
    
    private func deejays(event: Event) -> [String] {
        var artists = [String]()
        let djsSet = event.performers?.allObjects as! [Artist]
        let sorted = djsSet.sorted(by: {$0.name! < $1.name!})
        for dj in sorted {
            artists.append(dj.name!)
        }
        return artists
    }
    


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
    
    
    
    // displayDJsList reload the data to the collectionView from the visible cells
    func displayDJsList () {
        let visibleCells = tableView.visibleCells
        for cell in visibleCells {
            guard let myCell = cell as? EventDeejayCell else { return }
            print("collection tag : [\(myCell.collectionView.tag)] - cell tag: [\(myCell.tag)]")
            let indexPathArr = myCell.collectionView.indexPathsForVisibleItems
            for path in indexPathArr {
                print("indexPath for DJcell: [\(path)]")
            }
            
            // load this part lazily when scrolling ends
            guard let djsCount = myCell.event?.performers?.count else { return }
            if djsCount > 0 {
                myCell.collectionView.reloadData()
                myCell.collectionView.isHidden = false
                //print("Collection Tag: \(myCell.collectionView.tag)")
                //myCell.collectionView.isHidden = false
            }
        }
    }
   
    
    // UIScrollView functions
    
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//    }
//    
//    
//    
//    
//    
//    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        print("scrollViewWillBeginDragging")
//        
//    }
//    
//    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if (!decelerate) {
//            print("scrollViewDidEndDragging was STOP by USER")
//        } else {
//            print("scrollViewDidEndDragging Naturally")
//        }
//        
//    }
//    
//    
//    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print("scrollViewDidEndDecelerating")
//    }
//    
//    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//        print("scrollViewWillBeginDecelerating")
//    }
//    
//    
//    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        print("scrollViewWillEndDragging: [velocity: \(velocity)] & [target Offset: \(targetContentOffset)]")
//    }
//    
//    
    
    
}













