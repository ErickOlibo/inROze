//
//  EventsViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 22/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class EventsViewController: FetchedResultsTableViewController {

    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    let mainContext = AppDelegate.viewContext


    lazy var fetchResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<Event> in
        
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        let nowTime = NSDate()
        request.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true, selector: nil)]
        request.predicate = NSPredicate(format: "endTime > %@ AND imageURL != nil AND name != nil AND text != nil", nowTime)
        request.fetchBatchSize = 20
        let fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedRC.delegate = self
        print("FETCH RESULTS CONTROLLER IS SET")
        return fetchedRC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("FROM CONSTANT --> Default: [\(cellHeightForDefault)] -- Deejay: [\(cellHeightForDeejay)]")
        self.navigationController?.navigationBar.isTranslucent = false
        self.tableView.decelerationRate = UIScrollViewDecelerationRateFast
        updateUI()

        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.tintColor = UIColor.changeHexStringToColor(ColorInHexFor.logoRed)
        print("EventsViewController")
        updateUI()
        RequestHandler().fetchEventIDsFromServer()
        
    }
    
    
    private func updateUI() {
        do {
            try self.fetchResultsController.performFetch()
            if let count = fetchResultsController.fetchedObjects?.count {
                print("Total Event Fetched: \(count)")
            }
            
            self.tableView.reloadData()
        } catch {
            print("Error in performFetch - EventVC - updateUI()")

        }
    }
    



}















