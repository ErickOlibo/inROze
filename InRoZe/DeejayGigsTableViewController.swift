//
//  DeejayGigsTableViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 27/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit

class DeejayGigsTableViewController: FetchedResultsTableViewController {
    
    // Core Data model container and context
    private let context = AppDelegate.viewContext
    private let container = AppDelegate.persistentContainer
    
    
    // properties
    let followedRightButton = UIBarButtonItem()
    let deejayGigCell = "Deejay Gig Cell"
    var artist: Artist? { didSet { updateUI() } }
    var currentFollowState = false
    
    private var gigsList: [Event]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar
        navigationController?.delegate = self
        self.navigationController?.navigationBar.tintColor = UIColor.changeHexStringToColor(ColorInHexFor.logoRed)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: (UIImage(named: "2_Follows")?.withRenderingMode(.alwaysTemplate))!, style: .plain, target: self, action: #selector(pressedFollowed))
        currentFollowState = artist!.isFollowed

    }

    @objc private func pressedFollowed() {
        print("pressed Followed")
        currentFollowState = !currentFollowState
        updateFollowedButton()
        container.performBackgroundTask { context in
            _ = Artist.setIsFollowed(for: self.artist!.id!, in: context)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // set the status and color of rightButton
        updateFollowedButton()
    }
    
    
    private func updateFollowedButton() {
        print("currentFollowState: \(currentFollowState)")
        if (currentFollowState) {
            navigationItem.rightBarButtonItem?.image = (UIImage(named: "2_FollowsFilled")?.withRenderingMode(.alwaysTemplate))!
            navigationItem.rightBarButtonItem?.tintColor = UIColor.changeHexStringToColor(ColorInHexFor.logoRed)
        } else {
            navigationItem.rightBarButtonItem?.image = (UIImage(named: "2_Follows")?.withRenderingMode(.alwaysTemplate))!
            navigationItem.rightBarButtonItem?.tintColor = .lightGray
        }
    }
    
    private func updateUI() {
        gigsList = Artist.findPerformingEvents(for: artist!, in: context)
        
        
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Deejay Gig Cell", for: indexPath) as! DeejayGigsTableViewCell
        
        // Configure the cell...
        cell.selectionStyle = .none
        
        // place cover image
        cell.eventCover.sd_setImage(with: URL(string: gigsList![indexPath.row].imageURL! )) { (image, error, cacheType, imageURL) in
            if (image != nil) {
                cell.eventCover.image = image
            }
        }
        cell.eventName.text = gigsList![indexPath.row].name!
        cell.eventDateTimeLocation.attributedText = dateTimeLocationFormatter(with: gigsList![indexPath.row])

        return cell
    }
 


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */



}


extension DeejayGigsTableViewController:  UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if ((viewController as? EventsViewController) != nil) {
            print("back to Events")
        }
    }
    
}


