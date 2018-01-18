//
//  SearchCatalogueTableView+NSFethResultsController.swift
//  InRoZe
//
//  Created by Erick Olibo on 06/01/2018.
//  Copyright © 2018 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData
import LNPopupController

extension SearchCatalogueViewController
{
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchResultsController.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCatalogueCell.identifier, for: indexPath) as! SearchCatalogueCell
        
        cell.tag = indexPath.row
        cell.selectionStyle = .none
        cell.mixtape = fetchResultsController.object(at: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(isForCatalogue) {
            print("SearchFOR Catalogue")
        } else {
            print("Search For List")
        }
        let popupContentController = storyboard?.instantiateViewController(withIdentifier: "MixtapePlayerViewController") as! MixtapePlayerViewController
        let mixtape = fetchResultsController.object(at: indexPath)
        let tabBarVC = tabBarController as! TabBarViewController
        //print("TAB BAR PLAYER: \(tabBarVC.sharedPlayer.description)")
        popupContentController.player = tabBarVC.sharedPlayer
        popupContentController.mixtape = mixtape
        popupContentController.tabBarVC = tabBarVC
        tabBarController?.presentPopupBar(withContentViewController: popupContentController, animated: true, completion: nil)
        tabBarController?.popupBar.imageView.layer.cornerRadius = 5
        tabBarController?.popupBar.imageView.layer.borderWidth = 0.333
        tabBarController?.popupBar.imageView.layer.borderColor = UIColor.black.cgColor
        //tabBarController?.popupBar.progressViewStyle = .top
        //tabBarController?.popupBar.tintColor = Colors.logoRed
        
        
        
    }
    
    
    
}
