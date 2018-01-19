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
        request.predicate = NSPredicate(format: "ANY performers.isFollowed == YES AND endTime > %@ AND imageURL != nil AND name != nil AND performers.@count > 0", nowTime)
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
        view.backgroundColor = .white
        tableView.separatorColor = .clear
        navigationController?.navigationBar.isTranslucent = false
        tableView.rowHeight = cellHeightForFollows
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        //tableView.separatorInset = UIEdgeInsetsMake(0, 70, 0, 30)
        tableView.reloadData()
        tableView.backgroundColor = .white

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
        navigationItem.title = "Follows in \(currentCity.name.rawValue)"
        print("Follows")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // remove all view from footerView
        if let subviewsArray = tableView.tableFooterView?.subviews {
            for view in subviewsArray {
                view.removeFromSuperview()
            }
        }

        
        // Save the dictionary colorsOfEventCovers to core data
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
    private func setupFooterView() -> UIView {
        let missingFollowsView = UIView(frame: CGRect(x: 0, y: 0, width: CellSize.phoneSizeWidth, height: 280))
        guard let image = UIImage(named: "MissingFollows") else { return missingFollowsView }
        let locationX: CGFloat = (CellSize.phoneSizeWidth / 2) - 100
        let imageView = UIImageView(frame: CGRect(x: locationX, y: 20, width: 200, height: 200))
        imageView.image = image
        missingFollowsView.addSubview(imageView)
        return missingFollowsView
    }
    
    
    private func setupMissingFollowsLabel() -> UIView {
        let numberOfFollows = Artist.listOfFollows(in: mainContext).count
        let messageLabel = UILabel(frame: CGRect(x: 40.0, y: 230.0, width: CellSize.phoneSizeWidth - 80.0, height: 40.0))
        let fontName = "HelveticaNeue-Bold"
        let textFont = UIFont(name: fontName, size: 17)
        messageLabel.font = textFont
        messageLabel.textColor = .black
        messageLabel.lineBreakMode = .byTruncatingTail
        messageLabel.numberOfLines = 2
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.minimumScaleFactor = 0.8
        if numberOfFollows > 0 {
            messageLabel.text = "No Upcoming Gigs From Your Follows"
        } else {
            messageLabel.text = "You Do Not Follow Any Deejay!"
        }
        messageLabel.textAlignment = .center
        return messageLabel
    }
    
    private func followsFooterViewIsHidden(forFollowsCount count: Int) {
        if count > 0 {
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        } else {
            let messageView = setupMissingFollowsLabel()
            let thisFooterView = setupFooterView()
            thisFooterView.addSubview(messageView)
            tableView.tableFooterView = thisFooterView
        }
    }
    
    private func updateUI() {
        do {
            try self.fetchResultsController.performFetch()
            if let count = fetchResultsController.fetchedObjects?.count {
                print("Total Event from IsFollowed Deejays: \(count)")
                self.followsFooterViewIsHidden(forFollowsCount: count)
            }
        } catch {
            print("UpdateUI in FolowVC -> Error while fetching: \(error)")
        }
        tableView.reloadData()
    }

    
}









