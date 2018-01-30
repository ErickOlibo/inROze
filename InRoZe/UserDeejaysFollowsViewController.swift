//
//  UserDeejaysFollowsViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 30/01/2018.
//  Copyright © 2018 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData

class UserDeejaysFollowsViewController: FetchedResultsTableViewController {
    
    
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    let mainContext = AppDelegate.viewContext
    let searchController = UISearchController(searchResultsController: nil)
    var searchText: String?
    
    
    lazy var fetchResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<Artist> in
        let request: NSFetchRequest<Artist> = Artist.fetchRequest()
        let sortCountry = NSSortDescriptor(key: "country", ascending: true, selector: nil)
        let sortName = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        request.sortDescriptors = [sortName, sortCountry]
        request.predicate = NSPredicate(format: "name != nil AND isFollowed == YES")
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
        navigationController?.navigationBar.tintColor = Colors.logoRed
        
        // Stuff for search bar
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search Your Follows"
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.tintColor = Colors.logoRed
        searchController.searchBar.returnKeyType = .done
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    
    // ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        updateUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
        navigationItem.title = "Your Follows List"
    }
    
    
    // Convenience Functions
    private func updateUI() {
        do {
            try self.fetchResultsController.performFetch()
        } catch {
            print("UpdateUI in UserDeejaysFollowsViewController -> Error while fetching: \(error)")
        }
        tableView.reloadData()
    }
    
}


extension UserDeejaysFollowsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.searchBar.text!.count > 0 else {
            searchText = searchController.searchBar.text
            fetchResultsController.fetchRequest.predicate = NSPredicate(format: "name != nil AND isFollowed == YES")
            updateUI()
            return
        }
        
        print("Passed the Guard: updateSearchResults")
        searchText = searchController.searchBar.text!
        fetchResultsController.fetchRequest.predicate = NSPredicate(format: "name != nil AND (name contains[c] %@ OR country contains[c] %@) AND isFollowed == YES ",  searchText!, searchText! )
        updateUI()
    }
    
}


extension UserDeejaysFollowsViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked ")
    }
}








