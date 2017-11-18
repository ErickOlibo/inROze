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
    //let event = Event()
    let numberEvents = 10

    
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
    
    private func updateUI() {
        
        do {
            try self.fetchResultsController.performFetch()
            if let count = fetchResultsController.fetchedObjects?.count {
                print("Total Event from IsFollowed Deejays: \(count)")
            }
            tableView.reloadData()
//            guard let allEvent = fetchResultsController.fetchedObjects else { return }
//            var rank = 0
//            for event in allEvent {
//                rank += 1
//                guard let name = event.name else { return }
//                guard let time = event.startTime else { return }
//                print("\(rank)) - \(name) | \(time)")
//            }
            
        } catch {
            
        }
        
        
    }

    
}









