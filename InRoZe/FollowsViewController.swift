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
        
        let startDaySort = NSSortDescriptor(key: "startDay", ascending: true, selector: nil)
        let startTimeSort = NSSortDescriptor(key: "startTime", ascending: true, selector: nil)
        request.sortDescriptors = [startDaySort, startTimeSort]
        request.predicate = NSPredicate(format: "ANY performers.isFollowed == YES AND endTime > %@ AND imageURL != nil AND name != nil AND text != nil AND performers.@count > 0", nowTime)
        request.fetchBatchSize = 20
        let fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.mainContext, sectionNameKeyPath: "startDay", cacheName: nil)
        fetchedRC.delegate = self
        return fetchedRC
    }()
    
    // Set up Navigation Bar UI style
    private func setupNavBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.view.backgroundColor = .white
        
    }
    
    // ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        navigationController?.navigationBar.isTranslucent = false
        tableView.rowHeight = cellHeightForFollows
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorInset = UIEdgeInsetsMake(0, 70, 0, 30)
        tableView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
        navigationItem.title = "Next in \(UserDefaults().currentCityName)"
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
            //tableView.reloadData()
            
        } catch {
            print("UpdateUI in FolowVC -> Error while fetching: \(error)")
        }
        
        tableView.reloadData()
    }

    
}









