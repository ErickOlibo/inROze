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

    lazy var fetchResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<Artist> in
        let request: NSFetchRequest<Artist> = Artist.fetchRequest()
        //let isFollowSort = NSSortDescriptor(key: "isFollowed", ascending: false, selector: nil)
        let nameSort = NSSortDescriptor(key: "name", ascending: true, selector: nil)
        //request.sortDescriptors = [NSSortDescriptor(key: "isFollowed", ascending: false, selector: nil)]
        request.sortDescriptors = [nameSort]

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
        setupNavBar()
        updateUI()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    
    // Convenience Functions
    private func updateUI() {
        do {
            try self.fetchResultsController.performFetch()
        } catch {
            print("UpdateUI in FolowVC -> Error while fetching: \(error)")
        }
        tableView.reloadData()
    }

}


extension DeejaysViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("Here IN: updateSearchResults - ")
        guard searchController.searchBar.text!.count > 0 else {
            searchText = searchController.searchBar.text
            print("is search bar text nil: [\(searchController.searchBar.text ?? "NIL")]")
            let descript = fetchResultsController.fetchRequest.sortDescriptors
            let predic = fetchResultsController.fetchRequest.predicate
            print("Description: \(String(describing: descript)) - Predicate: \(String(describing: predic))")
            fetchResultsController.fetchRequest.predicate = NSPredicate(format: "name != nil ")
            updateUI()
            return
        }
        
        print("Passed the Guard: updateSearchResults")
        searchText = searchController.searchBar.text!
        fetchResultsController.fetchRequest.predicate = NSPredicate(format: "name != nil AND name contains[c] %@",  searchText!)
        updateUI()
    }
    
    

}

extension DeejaysViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked ")
    }
}








