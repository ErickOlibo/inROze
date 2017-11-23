//
//  DJsViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 22/11/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData

class DeejaysViewController: FetchedResultsTableViewController {
    
    //var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    let mainContext = AppDelegate.viewContext

    
    lazy var fetchResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<Artist> in
        
        let request: NSFetchRequest<Artist> = Artist.fetchRequest()
        
        
        let isFollowSort = NSSortDescriptor(key: "isFollowed", ascending: false, selector: nil)
        let nameSort = NSSortDescriptor(key: "name", ascending: true, selector: nil)
        request.sortDescriptors = [isFollowSort, nameSort]
        
        request.predicate = NSPredicate(format: "name != nil")
        request.fetchBatchSize = 20
        let fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedRC.delegate = self
        return fetchedRC
    }()
    
    // Set up Navigation Bar UI style
    private func setupNavBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        navigationController?.navigationBar.isTranslucent = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
        print("DJs Search")
    }
    
    
    // Convenience Functions
    private func updateUI() {
        do {
            try self.fetchResultsController.performFetch()
            guard let deejays = fetchResultsController.fetchedObjects else { return }
            print("Total Deejays in core Data (dj search): \(deejays.count)")
        } catch {
            print("UpdateUI in FolowVC -> Error while fetching: \(error)")
        }
        tableView.reloadData()
    }



 

}
