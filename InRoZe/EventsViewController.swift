//
//  EventsViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 22/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData

class EventsViewController: FetchedResultsTableViewController {

    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    let mainContext = AppDelegate.viewContext
    var deejaysName = Set<String>()

    lazy var fetchResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<Event> in
        
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        let nowTime = NSDate()
        request.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true, selector: nil)]
        request.predicate = NSPredicate(format: "endTime > %@ AND imageURL != nil AND name != nil AND text != nil AND performers.@count > 0", nowTime)
        request.fetchBatchSize = 20
        let fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedRC.delegate = self
        print("FETCH RESULTS CONTROLLER IS SET")
        return fetchedRC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        updateUI()
        tableView.rowHeight = cellHeightForDJList
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.tintColor = UIColor.changeHexStringToColor(ColorInHexFor.logoRed)
        print("EventsViewController - Cell Height: [\(cellHeightForDJList)]")
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
            guard let allEvent = fetchResultsController.fetchedObjects else { return }
            for event in allEvent {
                let artists = event.performers?.allObjects as! [Artist]
                for artist in artists {
                    guard let name = artist.name else { return }
                    deejaysName.insert(name)
                }
            }
            print("Size of unique DJS : \(deejaysName.count)")
            
        } catch {
            print("Error in performFetch - EventVC - updateUI()")

        }
    }


}















