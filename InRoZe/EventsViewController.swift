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

    //var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    //var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    var container: NSPersistentContainer!
    var mainContext: NSManagedObjectContext!
    

    
    var deejaysName = Set<String>()
    var followsList = [Artist]()
    var currentCode: String?


    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var tableHeaderView: UIView! // investigate the retain (weak/strong) and other potential memory issues
    @IBOutlet weak var myFollows: UILabel!
    
    
    
    lazy var fetchResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<Event> in
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        let nowTime = NSDate()
        let nameSort = NSSortDescriptor(key: "name", ascending: true, selector: nil)
        let dateSort = NSSortDescriptor(key: "startTime", ascending: true, selector: nil)
        let currentCityCode = currentCity.code.rawValue
        request.sortDescriptors = [dateSort, nameSort]
        request.predicate = NSPredicate(format: "endTime > %@ AND cityCode = %@ AND imageURL != nil AND name != nil AND performers.@count > 0", nowTime, currentCityCode)
        request.fetchBatchSize = 20
        let fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedRC.delegate = self
        return fetchedRC
    }()
    
    // Set up Navigation Bar UI style
    private func setupNavBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.view.backgroundColor = .white
    }
    
    
    // View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        currentCode = currentCity.code.rawValue
        setupNavBar()
        container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        mainContext = AppDelegate.viewContext
        
        let headerBorderColor = UIColor.lightGray.cgColor
        collectionView.delegate = self
        collectionView.dataSource = self
        tableHeaderView.addBorder(toSide: .Bottom, withColor: headerBorderColor, andThickness: 0.333)
        updateUI()
        tableView.rowHeight = cellHeightForDJList
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(doneFetchingFromServer), name: NSNotification.Name(rawValue: NotificationFor.serverRequestDoneUpdating), object: nil)
        updateUI()
        if (!UserDefaults().isLoggedIn) {
            RequestHandler().fetchEventIDsFromServer()
        } else {
            UserDefaults().isLoggedIn = false
        }
        collectionView.reloadData()
        // set the labels with the correct Country name and City name
        setOriginLabel()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // remove Notification Observer
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationFor.serverRequestDoneUpdating), object: nil)
    }
    
    
    
    // Convenience Functions
    @objc private func doneFetchingFromServer() {
        //print("SERVER REQUESt DONE UPDATING in EventsViewController")
        DispatchQueue.main.async { [unowned self] in
            self.updateUI()
        }        
    }
    
    
    private func setOriginLabel() {
        let eventsInCity = "Events in \(currentCity.name.rawValue)"
        let myNationalityFollows = "Your \(currentCity.nationality.rawValue) Follows"
        navigationItem.title = eventsInCity
        myFollows.text = myNationalityFollows
    }
    
    
    
    private func orderArtists() {
        let followListArr = Array(followsList)
        
        let sorted = followListArr.sorted(by: { lhs, rhs in
            if lhs.gigs!.count == rhs.gigs!.count {
                return lhs.name! < rhs.name!
            }
            return lhs.gigs!.count > rhs.gigs!.count
        })
        followsList = sorted
        printArr()
    }

    
    private func printArr() {
        var longString = ""
        for artist in followsList {
            longString += artist.name!
            longString += " (\(artist.gigs!.count)) | "
        }
        //print("** SORTED: \(longString)")
    
    }
    
    private func cleanStoreFromOldData() {
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        // Delete old events from database
        _ = Event.deleteEventsEndedBeforeNow(in: mainContext, with: request)
        
        // delete events without performers
        _ = Event.deleteEventsWithoutPerformers(in: mainContext, with: request)
    }
    
    
    private func updatePredicate() {
        let nowTime = NSDate()
        let currentCityCode = currentCity.code.rawValue
        fetchResultsController.fetchRequest.predicate = NSPredicate(format: "endTime > %@ AND cityCode = %@ AND imageURL != nil AND name != nil AND performers.@count > 0", nowTime, currentCityCode)
    }
    
    private func updateUI() {
        // clear data of old events and events without performers
        cleanStoreFromOldData()
        
        // number of events in the database
        // Better way to count number of element in entity (CoreData)
//        if let eventCount = try? mainContext.count(for: Event.fetchRequest()) {
//            print("[printDatabaseStatistics] in EventsVC - \(eventCount) Events ")
//        }
        
        // update predicate in case of cityCode change
        updatePredicate()
        
        // get number of Follows
        followsList = Artist.listOfFollows(in: mainContext, for: currentCity.countryCode.rawValue)
        orderArtists()
        
        do {
            try self.fetchResultsController.performFetch()
//            if let count = fetchResultsController.fetchedObjects?.count {
//                print("Total Event Fetched: \(count)")
//            }
            
            self.tableView.reloadData()
            // go to top
            let newCode = currentCity.code.rawValue
            if (newCode != currentCode) {
                self.tableView.setContentOffset(.zero, animated: true)
                self.collectionView.setContentOffset(.zero, animated: true)
                currentCode = newCode
            }
            
            
            guard let allEvent = fetchResultsController.fetchedObjects else { return }
            for event in allEvent {
                let artists = event.performers?.allObjects as! [Artist]
                for artist in artists {
                    guard let name = artist.name else { return }
                    deejaysName.insert(name)
                }
            }
            //print("Size of unique DJS : \(deejaysName.count)")
            
        } catch {
            print("Error in performFetch - EventVC - updateUI()")

        }
        self.tableViewIsHidden(forFollowsCount: followsList.count)
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
        //print("list of Follows: [\(followsList.count)]")
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
        //print("row: \(indexPath.row)")
    }
}












