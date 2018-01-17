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
import LNPopupController


extension DeejayGigsTableViewController {
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return eventsOfDJ?.count ?? 0
        } else {
            return  mixtapesOfDJ?.count ?? 0
        }
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: DeejayGigsCell.identifier, for: indexPath) as! DeejayGigsCell
            cell.tag = indexPath.row
            cell.selectionStyle = .none
            guard let event = eventsOfDJ?[indexPath.row] else { return cell }
            cell.event = event
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: DeejayMixesCell.identifier, for: indexPath) as! DeejayMixesCell
            cell.tag = indexPath.row
            cell.selectionStyle = .none
            guard let mixtape = mixtapesOfDJ?[indexPath.row] else { return cell }
            cell.mixtape = mixtape
            return cell
        }
    }
    
    
    // Views for section
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        guard self.tableView(tableView, numberOfRowsInSection: section) > 0 else { return view }
        
        let redLine = UIView(frame: CGRect(x: 16, y: 41, width: 10, height: 25))
        redLine.backgroundColor = Colors.logoRed
        view.addSubview(redLine)

        var text = ""
        let textLabel = UILabel()
        let attributeOne =  [ NSAttributedStringKey.font: UIFont(name: "AvenirNext-Bold", size: 35.0)!, NSAttributedStringKey.foregroundColor: UIColor.black ]
        
        if (section == 0) {
            text = "Gigs"
        } else {
            text = "Mixtapes"
        }
        let attrText = NSAttributedString(string: text, attributes: attributeOne)
        textLabel.attributedText = attrText
        textLabel.frame = CGRect(x: 36, y: 30, width: CellSize.phoneSizeWidth, height: 50)
        textLabel.textAlignment = .left
        view.addSubview(textLabel)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
            return 80.0
        } else {
            return 0.333
        }
    }
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightGray
        

        if (section == 0 && (eventsOfDJ?.count ?? 0) == 0) {
            view.backgroundColor = .white
        }
        if (section == 1 && (mixtapesOfDJ?.count ?? 0) == 0) {
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
        guard indexPath.section == 1 else { return }

        
        let popupContentController = storyboard?.instantiateViewController(withIdentifier: "MixtapePlayerViewController") as! MixtapePlayerViewController
        guard let mixtape = mixtapesOfDJ?[indexPath.row] else { return }
        
        let tabBarVC = tabBarController as! TabBarViewController
        //print("TAB BAR PLAYER: \(tabBarVC.sharedPlayer.description)")
        popupContentController.player = tabBarVC.sharedPlayer
        popupContentController.mixtape = mixtape
        popupContentController.tabBarVC = tabBarVC
        tabBarController?.presentPopupBar(withContentViewController: popupContentController, animated: true, completion: nil)
        tabBarController?.popupBar.imageView.layer.cornerRadius = 5
        tabBarController?.popupBar.imageView.layer.borderWidth = 0.333
        tabBarController?.popupBar.imageView.layer.borderColor = UIColor.black.cgColor
        tabBarController?.popupBar.progressViewStyle = .top
        tabBarController?.popupBar.tintColor = Colors.logoRed
        //print("PpoupBar Frame: \(String(describing: tabBarController?.popupBar.frame))")
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






