//
//  DeejayGigsTableViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 27/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData

class DeejayGigsTableViewController: FetchedResultsTableViewController {
    
    // Core Data model container and context
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    
    
    // properties
    let followedRightButton = UIBarButtonItem()
    var artist: Artist? { didSet { updateUI() } }

    //private var currentFollowState = false
    private var gigsList: [Event]?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("DeejayGigsTableViewController")
        // navigation bar see Extension below
        navigationController?.delegate = self
        self.navigationController?.navigationBar.tintColor = UIColor.changeHexStringToColor(ColorInHexFor.logoRed)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: (UIImage(named: "2_Follows")?.withRenderingMode(.alwaysTemplate))!, style: .plain, target: self, action: #selector(pressedFollowed))
        //currentFollowState = artist!.isFollowed
    }

    @objc private func pressedFollowed() {
        if let context = container?.viewContext {
            context.perform {
                if let artistState = Artist.currentIsFollowedState(for: self.artist!.id!, in: context) {
                    self.artist!.isFollowed = !artistState
                    self.updateFollowedButton()
                    self.changeState()
                }
            }
        } 
    }
    
    private func changeState() {
        // change state of isFollowed
        container?.performBackgroundTask{ context in
            let success = Artist.changeIsFollowed(for: self.artist!.id!, in: context)
            if (success) {
                print("[DeejayGigsTableViewController in pressedFollowed] - isFollowed CHANGED")
            } else {
                print("[pressedFollowed] - FAILED")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set the status and color of rightButton
        updateFollowedButton()
    }
    
    
    private func updateFollowedButton() {
        if (artist!.isFollowed) {
            navigationItem.rightBarButtonItem?.image = (UIImage(named: "2_FollowsFilled")?.withRenderingMode(.alwaysTemplate))!
            navigationItem.rightBarButtonItem?.tintColor = UIColor.changeHexStringToColor(ColorInHexFor.logoRed)
        } else {
            navigationItem.rightBarButtonItem?.image = (UIImage(named: "2_Follows")?.withRenderingMode(.alwaysTemplate))!
            navigationItem.rightBarButtonItem?.tintColor = .lightGray
        }
    }
    
    private func updateUI() {
        print("Artist was set")
        if let context = container?.viewContext {
            context.perform {
                self.gigsList = Artist.findPerformingEvents(for: self.artist!, in: context)
                if let currentState = Artist.currentIsFollowedState(for: self.artist!.id!, in: context) {
                    self.artist!.isFollowed = currentState
                }
            }
        }
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigsList?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let djCell = cell as? DeejayGigsCell else { return }
        // Configure the cell...
        djCell.selectionStyle = .none
        
        // place cover image
        djCell.eventCover.sd_setImage(with: URL(string: gigsList![indexPath.row].imageURL! )) { (image, error, cacheType, imageURL) in
            if (image != nil) {
                djCell.eventCover.image = image
            }
        }
        djCell.eventName.text = gigsList![indexPath.row].name!
        djCell.eventDateTimeLocation.attributedText = dateTimeLocationFormatter(with: gigsList![indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DeejayGigsCell.identifier, for: indexPath) as! DeejayGigsCell
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Event in Deejay list nr: [\(indexPath.row)]")
    }


}


extension DeejayGigsTableViewController:  UINavigationControllerDelegate {
//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        if ((viewController as? EventsViewController) != nil) {
//            print("back to Events")
//        }
//    }
    
}


