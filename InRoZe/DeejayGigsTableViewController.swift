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
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    let mainContext = AppDelegate.viewContext
    
    // outlets
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var djProfileImage: UIImageView! { didSet { updateProfileImage() } }
    @IBOutlet weak var djProfileView: UIView! { didSet { updateProfileView() } }
    
    @IBOutlet weak var deejayName: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var gigsMixes: UILabel!
    @IBOutlet weak var mixcloudButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var profileCoverImage: UIImageView!
    

    // Actions
    @IBAction func touchedFollow(_ sender: UIButton) {
        pressedFollowed()
    }
    
    
    // properties
    let followedRightButton = UIBarButtonItem()
    var artist: Artist? { didSet { updateUI() } }
    let sepaColor = UIColor.lightGray.cgColor
    let sepaThick: CGFloat = 0.333
    var eventsCount = 0
    var mixtapesCount = 0
    
    // LAZY FetchResultsControllers
    lazy var eventsFRC: NSFetchedResultsController = { () -> NSFetchedResultsController<Event> in
        let id = artist!.id!
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        let nowTime = NSDate()
        request.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true, selector: nil)]
        request.predicate = NSPredicate(format: "ANY performers.id == %@ AND endTime > %@ AND imageURL != nil AND name != nil AND text != nil", id, nowTime)
        request.fetchBatchSize = 20
        let fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedRC.delegate = self
        return fetchedRC
    }()
    
    lazy var mixtapesFRC: NSFetchedResultsController = { () -> NSFetchedResultsController<Mixtape> in
        let id = artist!.id!
        let request: NSFetchRequest<Mixtape> = Mixtape.fetchRequest()
        let nowTime = NSDate()
        request.sortDescriptors = [NSSortDescriptor(key: "createdTime", ascending: false, selector: nil)]
        request.predicate = NSPredicate(format: "ANY deejay.id == %@", id)
        request.fetchBatchSize = 20
        let fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedRC.delegate = self
        return fetchedRC
    }()
    


    // ** View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.separatorColor = .clear

        // navigation bar see Extension below
        navigationController?.delegate = self
        self.navigationController?.navigationBar.tintColor = Colors.logoRed
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: (UIImage(named: "2_Follows")?.withRenderingMode(.alwaysTemplate))!, style: .plain, target: self, action: #selector(pressedFollowed))
        setDeejayImage()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // set the status and color of rightButton
        updateFollowedButton()
        updateDJInfo()
        updateGigsMixesCount()
        updateSocialPageIcon()
        updateUI()
        print("HeaderView size: \(tableHeaderView.frame)")
        tableHeaderView.addBorder(toSide: .Bottom, withColor: sepaColor, andThickness: sepaThick)
    }
    
    // ** Methods
    private func updateSocialPageIcon() {
        // set Social icons to right colors
        guard let dj = artist else { return }
        let fontSize = CGFloat(35.0)
        var mcColor = UIColor.black
        var fbColor = UIColor.black
        guard let iconMixcloud = FAType.FAMixcloud.text else { return }
        guard let iconFacebook = FAType.FAFacebookSquare.text else { return }
        let mixcloudPageURL = dj.mcPageURL
        let facebookPageURL = dj.fbPageURL
        if (mixcloudPageURL != nil) {
            mixcloudButton.isEnabled = true
            mcColor = Colors.mixcloud
        } else {
            mixcloudButton.isEnabled = false
            mcColor = Colors.hasNoSocialPage
        }
        if (facebookPageURL != nil) {
            facebookButton.isEnabled = true
            fbColor = Colors.facebook
        } else {
            facebookButton.isEnabled = false
            fbColor = Colors.hasNoSocialPage
        }
        
        let attrMixIcon = fontAwesomeAttributedString(forString: iconMixcloud, withColor: mcColor, andFontSize: fontSize)
        mixcloudButton.setAttributedTitle(attrMixIcon, for: .normal)
        let attrFaceIcon = fontAwesomeAttributedString(forString: iconFacebook, withColor: fbColor, andFontSize: fontSize)
        facebookButton.setAttributedTitle(attrFaceIcon, for: .normal)
        
        
        
    }
    
    private func updateGigsMixesCount() {
        let gigsCount = eventsFRC.fetchedObjects?.count ?? 0
        let mixtapesCount = mixtapesFRC.fetchedObjects?.count ?? 0
        gigsMixes.text = "\(gigsCount)Gs / \(mixtapesCount)Ms"
    }
    
    
    private func setDeejayImage() {
        guard let dj = artist else { return }
        guard let picURL = preferedProfilePictureURL(for: dj) else { return }
        djProfileImage.kf.setImage(with: URL(string: picURL), options: [.backgroundDecode])
    }
    
    private func updateProfileImage () {
        djProfileImage.layer.masksToBounds = true
        djProfileImage.layer.cornerRadius = 35.0
        djProfileImage.layer.borderColor = UIColor.gray.cgColor
        djProfileImage.layer.borderWidth = 0.333
    }
    
    private func updateProfileView () {
        djProfileView.backgroundColor = .white
        djProfileView.layer.masksToBounds = true
        djProfileView.layer.cornerRadius = 40.0
        djProfileView.layer.borderColor = Colors.logoRed.cgColor
        djProfileView.layer.borderWidth = 2.0
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
                //print("[DeejayGigsTableViewController in pressedFollowed] - isFollowed CHANGED")
            } else {
                print("[pressedFollowed] - FAILED")
            }
        }
    }
    

    
    private func updateDJInfo() {
        guard let artistName = artist?.name else { return }
        //guard let artistCountry = artist?.country else { return }
        deejayName.text = artistName
        //countryName.text = artistCountry
    }
    
    
    private func updateFollowedButton() {
        // Update profile
        if (artist!.isFollowed) {
            navigationItem.rightBarButtonItem?.image = (UIImage(named: "2_FollowsFilled")?.withRenderingMode(.alwaysTemplate))!
            navigationItem.rightBarButtonItem?.tintColor = Colors.logoRed
            followButton.setTitle("  Followed  ", for: .normal)
            followButton.backgroundColor = Colors.logoRed
            followButton.setTitleColor(.white, for: .normal)
            followButton.layer.borderColor = Colors.logoRed.cgColor
        } else {
            navigationItem.rightBarButtonItem?.image = (UIImage(named: "2_Follows")?.withRenderingMode(.alwaysTemplate))!
            navigationItem.rightBarButtonItem?.tintColor = .lightGray
            followButton.setTitle("   Follow   ", for: .normal)
            followButton.backgroundColor = .clear
            followButton.setTitleColor(.gray, for: .normal)
            followButton.layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    private func updateUI() {
        //print("ARTIST SET: updating the UI and specially the count for event and mixtapes")
        do {
            try self.eventsFRC.performFetch()
        } catch {
            print("updateUI performFetch on EventFRC failed: \(error)")
        }
        do {
            try self.mixtapesFRC.performFetch()
        } catch {
            print("updateUI performFetch on mixtapesFRC failed: \(error)")
        }

        if let context = container?.viewContext {
            context.perform {

                if let currentState = Artist.currentIsFollowedState(for: self.artist!.id!, in: context) {
                    self.artist!.isFollowed = currentState
                }
                self.tableView.reloadData()
            }
        }
    }

    
}


extension DeejayGigsTableViewController:  UINavigationControllerDelegate {
//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        if ((viewController as? EventsViewController) != nil) {
//            print("back to Events")
//        }
//    }
    
}


