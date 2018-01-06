//
//  SearchCatalogueTableView+NSFethResultsController.swift
//  InRoZe
//
//  Created by Erick Olibo on 06/01/2018.
//  Copyright © 2018 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData

extension SearchCatalogueViewController
{
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCatalogueCell.identifier, for: indexPath) as! SearchCatalogueCell
        
        return cell
    }
    
    
}
