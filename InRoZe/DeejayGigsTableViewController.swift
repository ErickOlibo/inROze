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
    
    // outlets
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var upcomingGigsView: UIView!
    @IBOutlet weak var upcomingGigsLabel: UILabel!
    @IBOutlet weak var deejayPicture: UIImageView!
    @IBOutlet weak var deejayName: UILabel!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    @IBAction func touchedFollow(_ sender: UIButton) {
        pressedFollowed()
    }
    
    
    
    // properties
    let followedRightButton = UIBarButtonItem()
    var artist: Artist? { didSet { updateUI() } }

    private var gigsList: [Event]?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("DeejayGigsTableViewController")
        self.title = "DeeJay Info"
        // navigation bar see Extension below
        navigationController?.delegate = self
        self.navigationController?.navigationBar.tintColor = Colors.logoRed
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: (UIImage(named: "2_Follows")?.withRenderingMode(.alwaysTemplate))!, style: .plain, target: self, action: #selector(pressedFollowed))
        upcomingGigsView.backgroundColor = Colors.logoRed
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
        updateDJInfo()
    }
    
    private func updateDJInfo() {
        guard let artistName = artist?.name else { return }
        guard let artistCountry = artist?.country else { return }
        deejayName.text = artistName
        countryName.text = artistCountry
    }
    
    
    private func updateFollowedButton() {
        // Update profile
        deejayPicture.image = UIImage(named: profileImageForDJ(with: artist!.id!, when: artist!.isFollowed))
        if (artist!.isFollowed) {
            navigationItem.rightBarButtonItem?.image = (UIImage(named: "2_FollowsFilled")?.withRenderingMode(.alwaysTemplate))!
            navigationItem.rightBarButtonItem?.tintColor = Colors.logoRed
            followButton.setTitle("Followed", for: .normal)
            followButton.backgroundColor = Colors.logoRed
            followButton.setTitleColor(.white, for: .normal)
            followButton.layer.borderColor = Colors.logoRed.cgColor
            
            
        } else {
            navigationItem.rightBarButtonItem?.image = (UIImage(named: "2_Follows")?.withRenderingMode(.alwaysTemplate))!
            navigationItem.rightBarButtonItem?.tintColor = .lightGray
            followButton.setTitle("Follow", for: .normal)
            followButton.backgroundColor = .clear
            followButton.setTitleColor(.gray, for: .normal)
            followButton.layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    private func updateUI() {
        print("Artist was set ID: [\(artist!.id!)]")
        if let context = container?.viewContext {
            context.perform {
                self.gigsList = Artist.findPerformingEvents(for: self.artist!, in: context)
                if let currentState = Artist.currentIsFollowedState(for: self.artist!.id!, in: context) {
                    self.artist!.isFollowed = currentState
                }
                print("Number of Events GigList: \(self.gigsList?.count ?? 0)")
                self.tableView.reloadData()
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
        djCell.selectionStyle = .none
        print("Will display cell at: \(indexPath.row)")

        djCell.eventName.text = gigsList![indexPath.row].name!
        djCell.eventDateTimeLocation.attributedText = dateTimeLocationFormatter(with: gigsList![indexPath.row])
        guard let thisEvent = gigsList?[indexPath.row] else { return }
        guard let thisURL = thisEvent.imageURL else { return }
        
        guard let eventURL = URL(string: thisURL) else { return }
        djCell.eventCover.kf.setImage(with: eventURL, options: [.backgroundDecode])
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DeejayGigsCell.identifier, for: indexPath) as! DeejayGigsCell
        print("cell for row at: \(indexPath.row)")
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


