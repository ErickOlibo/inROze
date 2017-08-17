//
//  EventViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 25/07/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData


class EventViewController: UIViewController
{
    
    // Core Data model container and context
    let context = AppDelegate.viewContext
    let container = AppDelegate.persistentContainer
    
    lazy var fetchResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<Event> in
        let context = AppDelegate.viewContext
        // Initilaze Fetch Request
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        let nowTime = NSDate()
        
        // Add sor Descriptors and Predicate
        request.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true, selector: nil)]
        request.predicate = NSPredicate(format: "startTime > %@", nowTime)
        
        // Initialze Fetched Results Controller
        let fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetch Results Controller
        fetchedRC.delegate = self
        
        print("\(fetchedRC)")
        return fetchedRC
    }()
    
    
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let eventCell = "Event Cell"
    
    // Collectionview cell properties behaviour
    let cellHeightOffset: CGFloat = 140.0 // distance between bottom picture and bottom cell
    let zoomOutFirstItemTransform: CGFloat = 0.1 // zoom out rate when moving out of scope
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .black
        let stickyLayout = collectionView.collectionViewLayout as! StickyCollectionViewFlowLayout
        stickyLayout.firstItemTransform = zoomOutFirstItemTransform
        
        // Request handler for eventIds from server
        RequestHandler().fetchEventIDsFromServer()
        
        // Execute the FetchRequest
        do {
            try self.fetchResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("fethcError: \(fetchError) | fetchError.userInfo: \(fetchError.userInfo)")
        }
        
    }
    
    
    @objc private func updateData() {

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Notification add Observer
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: NSNotification.Name(rawValue: NotificationFor.coreDataDidUpdate), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Notification remove Observer
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationFor.coreDataDidUpdate), object: nil)
    }
}








