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

    // Areas set in  AutoLayout at the main.Storyboard
    let topAreaHeight: CGFloat = 70
    let phoneSizeWidth = UIScreen.main.bounds.width
    let coverRatio = CGFloat(16) / 9
    let marginWidth: CGFloat = 20 * 2
    let djAreaHeight: CGFloat = 100
    
    var cellHeightDefault: CGFloat = 0
    var cellHeightDeejays: CGFloat = 0

    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    let mainContext = AppDelegate.viewContext
    
    // Lazy controller for the Events. Need one for the Artist
    lazy var fetchResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<Event> in
        
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        let nowTime = NSDate()
        request.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true, selector: nil)]
        request.predicate = NSPredicate(format: "endTime > %@ AND imageURL != nil AND name != nil AND text != nil", nowTime)
        //request.fetchBatchSize = 20
        
        let fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedRC.delegate = self
        return fetchedRC
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellHeightDefault = topAreaHeight + (phoneSizeWidth - marginWidth) / coverRatio
        cellHeightDeejays = cellHeightDefault + djAreaHeight
        print("DEFAULT Cell: [\(cellHeightDefault)] -- DEEJAY Cell: [\(cellHeightDeejays)]")
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
            print("Are you reloading the table")
            self.tableView.reloadData()
            
        } catch {
            print("Error in performFetch - EventVC - updateUI()")

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
