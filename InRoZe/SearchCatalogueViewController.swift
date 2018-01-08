//
//  SearchCatalogueViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 06/01/2018.
//  Copyright © 2018 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData

class SearchCatalogueViewController: FetchedResultsTableViewController {
    
    //var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    let mainContext = AppDelegate.viewContext
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchText: String?
    var isForCatalogue: Bool = true

    lazy var fetchResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<Mixtape> in
        let request: NSFetchRequest<Mixtape> = Mixtape.fetchRequest()
        let isFollowSort = NSSortDescriptor(key: "isFollowed", ascending: false, selector: nil)
        let nameSort = NSSortDescriptor(key: "name", ascending: true, selector: nil)
        let status = isForCatalogue
        request.sortDescriptors = [isFollowSort, nameSort]
        
        // conditional predicate
        let cataloguePredicate = NSPredicate(format: "name != nil AND isActive == YES")
        let yourListPredicate = NSPredicate(format: "name != nil AND isActive == YES AND isFollowed == YES")
        request.predicate = isForCatalogue ? cataloguePredicate : yourListPredicate
        
        //request.predicate = NSPredicate(format: "name != nil AND isActive == YES")
        request.fetchBatchSize = 20
        let fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedRC.delegate = self
        return fetchedRC
    }()
    
    
    // Set Up Navigation Bar UI Style
    private func setupNavBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.view.backgroundColor = .white
        
        // Stuff for search bar
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search Mixtapes"
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.tintColor = Colors.logoRed
        searchController.searchBar.returnKeyType = .done
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    
    
    
    // ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = Colors.logoRed
//        tableView.delegate = self
//        tableView.dataSource = self
        setupNavBar()
        updateUI()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
        //navigationItem.title = isForCatalogue ? "Catalogue" : "Your List"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Methods
    private func updateUI() {
        do {
            try self.fetchResultsController.performFetch()
        } catch {
            print("UpdateUI in SearchCatalogueVC -> Error while Lazy fetching: \(error)")
        }
        print("ALL mixtapes", self.fetchResultsController.fetchedObjects?.count ?? 0)
        tableView.reloadData()
    }


}

extension SearchCatalogueViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        //print("Updating search")
        guard let tempSearchText = searchController.searchBar.text, tempSearchText.count > 0 else {
            searchText = searchController.searchBar.text
            //print("search text is nil")
            let cataloguePredicate = NSPredicate(format: "name != nil AND isActive == YES")
            let yourListPredicate = NSPredicate(format: "name != nil AND isActive == YES AND isFollowed == YES")
            fetchResultsController.fetchRequest.predicate = isForCatalogue ? cataloguePredicate : yourListPredicate
            //fetchResultsController.fetchRequest.predicate = NSPredicate(format: "name != nil AND isActive == YES")
            updateUI()
            return
        }
        //print("passed the Guard")
        searchText = tempSearchText
        let cataloguePredicate = NSPredicate(format: "name != nil AND isActive == YES AND haystack contains[c] %@", tempSearchText)
        let yourListPredicate = NSPredicate(format: "name != nil AND isActive == YES AND isFollowed == YES AND haystack contains[c] %@", tempSearchText)
        fetchResultsController.fetchRequest.predicate = isForCatalogue ? cataloguePredicate : yourListPredicate
        //fetchResultsController.fetchRequest.predicate = NSPredicate(format: "name != nil AND isActive == YES AND haystack contains[c] %@", tempSearchText)
        updateUI()
    }
    
    
}


extension SearchCatalogueViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancelButton clicked")
    }
}






