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
    var followsList = [Artist]()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var tableHeaderView: UIView! // investigate the retain (weak/strong) and other potential memory issues
    
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
        let headerBorderColor = UIColor.lightGray.cgColor
        collectionView.delegate = self
        collectionView.dataSource = self
        tableHeaderView.addBorder(toSide: .Bottom, withColor: headerBorderColor, andThickness: 0.333)
        tableHeaderView.addBorder(toSide: .Top, withColor: headerBorderColor, andThickness: 0.333)
        updateUI()
        tableView.rowHeight = cellHeightForDJList
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //print("EventsViewController - Cell Height: [\(cellHeightForDJList)]")
        updateUI()
        RequestHandler().fetchEventIDsFromServer()
    }
    
    private func updateUI() {
        
        // get number of Follows
        followsList = Artist.listOfFollows(in: mainContext)
        
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
        // FOR NORMAL WAY..
        //self.tableViewIsHidden(forFollowsCount: followsList.count)
        let rdmInt = Int(arc4random_uniform(2))
        print("RandDom INT: \(rdmInt)")
        self.tableViewIsHidden(forFollowsCount: rdmInt)
    }
    
    private func tableViewIsHidden(forFollowsCount: Int) {
        if forFollowsCount > 0 {
            tableView.tableHeaderView = tableHeaderView
            collectionView.reloadData()
        } else {
            tableView.tableHeaderView = nil

        }
    }


}


extension EventsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        print("list of Follows: [\(followsList.count)]")
        return followsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventDJNameCell.identifier, for: indexPath) as! EventDJNameCell
        let thisDJ = followsList[indexPath.row]
        cell.thisDJ = thisDJ
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("row: \(indexPath.row)")
    }
}












