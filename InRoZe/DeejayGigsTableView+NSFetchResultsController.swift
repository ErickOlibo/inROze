//
//  DeejayGigsTableView+NSFetchResultsController.swift
//  InRoZe
//
//  Created by Erick Olibo on 26/12/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher


extension DeejayGigsTableViewController {
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            eventsCount = eventsFRC.fetchedObjects?.count ?? 0
            return eventsCount
        } else {
            mixtapesCount = mixtapesFRC.fetchedObjects?.count ?? 0
            return  mixtapesCount
        }
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let thisIndexPath = IndexPath(row: indexPath.row, section: 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: DeejayGigsCell.identifier, for: indexPath) as! DeejayGigsCell
            cell.tag = indexPath.row
            cell.selectionStyle = .none
//            if (thisIndexPath.row == eventsCount - 1) {
//                cell.addBorder(toSide: .Bottom, withColor: sepaColor, andThickness: sepaThick)
//                print("LAST EVENT cell indexPathRow: [\(thisIndexPath.row)] - eventsCount: [\(eventsCount)]")
//            }
            
            cell.event = eventsFRC.object(at: thisIndexPath)
            return cell
            
        } else {
            let thisIndexPath = IndexPath(row: indexPath.row, section: 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: DeejayMixesCell.identifier, for: indexPath) as! DeejayMixesCell
            cell.tag = indexPath.row
            cell.selectionStyle = .none
//            if (thisIndexPath.row == mixtapesCount - 1) {
//                cell.addBorder(toSide: .Bottom, withColor: sepaColor, andThickness: sepaThick)
//                print("LAST MIXTAPE cell indexPathRow: [\(thisIndexPath.row)] - MixtapesCount: [\(mixtapesCount)]")
//            }
            
            cell.mixtape = mixtapesFRC.object(at: thisIndexPath)
            return cell
        }
        
    }
    
    // Views for section
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        //view.backgroundColor = .white
        //view.addBorder(toSide: .Top, withColor: sepaColor, andThickness: sepaThick)
        //view.addBorder(toSide: .Bottom, withColor: sepaColor, andThickness: sepaThick)
        var text = ""
        let textLabel = UILabel()
        let attributeOne =  [ NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Bold", size: 18.0)!, NSAttributedStringKey.foregroundColor: UIColor.black ]
        
        if (section == 0) {
            text = "GIGS"
        } else {
            text = "MIXTAPES"
        }
        let attrText = NSAttributedString(string: text, attributes: attributeOne)
        textLabel.attributedText = attrText
        textLabel.frame = CGRect(x: 20, y: 30, width: CellSize.phoneSizeWidth, height: 20)
        textLabel.textAlignment = .left
        view.addSubview(textLabel)
        
        if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
            return view
        } else {
            textLabel.text = nil
            //view.backgroundColor = .lightGray
            return view
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
            return 50.0
        } else {
            return 0.333
        }
    }
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightGray

        if (section == 0 && eventsCount == 0) {
            view.backgroundColor = .white
        }
        if (section == 1 && mixtapesCount == 0) {
            view.backgroundColor = .white
        }
        
        return view
    }
    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.section == 0) ?  60.0 :  120.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("Event in Deejay list nr: [\(indexPath.row)]")
    }
    
    // List of segue to be done here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let deejay = artist else { return }
        if (segue.identifier == "Gig Cell To Info") {
            guard let gigCell = sender as? DeejayGigsCell else { return }
            guard let destination = segue.destination as? EventInfoViewController else { return }
            destination.event = gigCell.event
            destination.navigationItem.title = gigCell.event?.location?.name ?? ""
        }
        //Mixtape Cell to PlayerView
        if (segue.identifier == "Mixtape Cell To Player") {
            guard let mixCell = sender as? DeejayMixesCell else { return }
            guard let destination = segue.destination as? MixtapePlayerViewController else { return }
            destination.mixtape = mixCell.mixtape
        }
        
        // DJ Profile to Mixcloud DeeJay page
        if (segue.identifier == "DJ Profile To Mixcloud") {
            guard let destination = segue.destination as? AboutViewController else { return }
            guard let mcURL = deejay.mcPageURL else { return }
            destination.aboutURL = URL(string: mcURL)
            destination.navigationItem.title = "Mixcloud Page"
        }
        
        // DJ Profile to Facebook DeeJay page
        if (segue.identifier == "DJ Profile To Facebook") {
            guard let destination = segue.destination as? AboutViewController else { return }
            guard let fbURL = deejay.fbPageURL else { return }
            destination.aboutURL = URL(string: fbURL)
            destination.navigationItem.title = "Facebook Page"
        }
        
        
    }
    
}






