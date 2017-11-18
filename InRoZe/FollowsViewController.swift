//
//  FollowsViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 22/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData

class FollowsViewController: FetchedResultsTableViewController {
    
    //var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    let mainContext = AppDelegate.viewContext

    // Initialize a dictionary of Colors to save in the Core Data
    var colorsOfEventCovers = [String : UIImageColors]()

    
    lazy var fetchResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<Event> in
        
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        let nowTime = NSDate()
        request.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true, selector: nil)]
        request.predicate = NSPredicate(format: "ANY performers.isFollowed == YES AND endTime > %@ AND imageURL != nil AND name != nil AND text != nil AND performers.@count > 0", nowTime)
        request.fetchBatchSize = 20
        let fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedRC.delegate = self
        return fetchedRC
    }()
    
    
    // ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        updateUI()
        tableView.rowHeight = cellHeightForFollows
        //tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsetsMake(0, 70, 0, 30)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
        print("Follows")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Save the dictionary colorsOfEventCovers to care data
        print("Save Colors Covers on WillDisappear")
        container?.performBackgroundTask { context in
            for event in self.colorsOfEventCovers {
                let eventID = event.key
                let colors = event.value
                let colorsInHex = colorsToHexString(with: colors)
                _ = Event.updateEventImageColors(with: eventID, and: colorsInHex, in: context)
            }
            // Save Context
            do {
                try context.save()
            } catch {
                print("CELL -> Error trying to save colors to database: \(error)")
            }
        }
    }
    
    
    // Convenience Functions
    private func updateUI() {
        
        do {
            try self.fetchResultsController.performFetch()
            if let count = fetchResultsController.fetchedObjects?.count {
                print("Total Event from IsFollowed Deejays: \(count)")
            }
            tableView.reloadData()
            
        } catch {
            print("UpdateUI in FolowVC -> Error while fetching: \(error)")
        }
        
        
    }

    
}









