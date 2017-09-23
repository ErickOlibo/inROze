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
    
    // properties
    let eventCell = "Event Cell"
    
    
    // All this are from AutoLayout in the main.Storyboard
    let spacingFromNavBar: CGFloat = 10
    let locationCoverSize: CGFloat = 40
    let spacingFromCover: CGFloat = 10
    let spacingUnderCover: CGFloat = 18
    let eventCoverTrailing: CGFloat = 18
    let performersCollectionCellHeight: CGFloat = 70
    let coverRatio = CGFloat(16) / 9
    let phoneSizeWidth = UIScreen.main.bounds.width
    var cellHeightDefault: CGFloat = 0
    

    // Core dat Model container and context
    let context = AppDelegate.viewContext
    let container = AppDelegate.persistentContainer
    
    lazy var fetchResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<Event> in
        let context = AppDelegate.viewContext
        // Initilaze Fetch Request
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        let nowTime = NSDate()
        
        // Add sor Descriptors and Predicate
        request.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true, selector: nil)]
        request.predicate = NSPredicate(format: "endTime > %@ AND imageURL != nil AND name != nil AND text != nil", nowTime)
        //request.predicate = NSPredicate(format: "startTime < %@", nowTime)
        
        // Initialze Fetched Results Controller
        let fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetch Results Controller
        fetchedRC.delegate = self
        
        return fetchedRC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Estimated rowHeight
        let viewSizeWidthFromPhone: CGFloat = self.view.bounds.width
        let coverHeight = (viewSizeWidthFromPhone - 2 * eventCoverTrailing) / coverRatio
        cellHeightDefault = spacingFromNavBar + locationCoverSize + spacingFromCover + coverHeight + spacingUnderCover
        
        // Request handler for eventIds from server
        RequestHandler().fetchEventIDsFromServer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.tintColor = UIColor.changeHexStringToColor(ColorInHexFor.logoRed)

        updateUI()
        print("Events")
    }
    
    private func updateUI() {
        // Execute the FetchRequest
        do {
            try self.fetchResultsController.performFetch()
        } catch {
            print("Error in performFetch - EventVC - updateUI()")
            //let fetchError = error as NSError
            //print("fethcError: \(fetchError) | fetchError.userInfo: \(fetchError.userInfo)")
        }
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
