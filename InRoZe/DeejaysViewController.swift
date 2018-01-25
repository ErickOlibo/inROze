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
    let searchController = UISearchController(searchResultsController: nil)
    var searchText: String?
    var currentCode: String?


    lazy var fetchResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<Artist> in
        let request: NSFetchRequest<Artist> = Artist.fetchRequest()
        let isFollowSort = NSSortDescriptor(key: "isFollowed", ascending: false, selector: nil)
        let nameSort = NSSortDescriptor(key: "name", ascending: true, selector: nil)
        let nameSort2 = NSSortDescriptor(key: "name", ascending: true,
                                         selector: #selector(NSString.localizedStandardCompare(_:)))
        
        //request.sortDescriptors = [NSSortDescriptor(key: "isFollowed", ascending: false, selector: nil)]
        request.sortDescriptors = [isFollowSort, nameSort]
        let currentCountryCode = currentCity.countryCode.rawValue
        request.predicate = NSPredicate(format: "name != nil AND countryCode = %@", currentCountryCode)
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
        
        // Stuff for search bar
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true

        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search Deejays"
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.tintColor = Colors.logoRed
        searchController.searchBar.returnKeyType = .done
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    
    // ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        currentCode = currentCity.code.rawValue
        setupNavBar()
        updateUI()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let newCode = currentCity.code.rawValue
        if (newCode != currentCode) {
            updatePredicate()
            print("CityCode was Channged")
            currentCode = newCode
        }
        updateUI()
        navigationItem.title = "DJs in \(currentCity.countryName.rawValue)"
    }
    
    
    // Convenience Functions
    private func updateUI() {
        do {
            try self.fetchResultsController.performFetch()
        } catch {
            print("UpdateUI in DeejaysViewController -> Error while fetching: \(error)")
        }
        tableView.reloadData()
    }
    
    private func updatePredicate() {
        let currentCountryCode = currentCity.countryCode.rawValue
        fetchResultsController.fetchRequest.predicate = NSPredicate(format: "name != nil AND countryCode = %@", currentCountryCode)
    }

}



extension DeejaysViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //print("Here IN: updateSearchResults - ")
        let currentCountryCode = currentCity.countryCode.rawValue
        guard searchController.searchBar.text!.count > 0 else {
            searchText = searchController.searchBar.text
            //print("is search bar text nil: [\(searchController.searchBar.text ?? "NIL")]")
//            let descript = fetchResultsController.fetchRequest.sortDescriptors
//            let predic = fetchResultsController.fetchRequest.predicate
//            print("Description: \(String(describing: descript)) - Predicate: \(String(describing: predic))")
            
            fetchResultsController.fetchRequest.predicate = NSPredicate(format: "name != nil AND countryCode = %@", currentCountryCode)
            updateUI()
            return
        }
        
        print("Passed the Guard: updateSearchResults")
        searchText = searchController.searchBar.text!
        fetchResultsController.fetchRequest.predicate = NSPredicate(format: "name != nil AND name contains[c] %@ AND countryCode = %@",  searchText!, currentCountryCode)
        updateUI()
    }
    
    

}

extension DeejaysViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked ")
    }
}








