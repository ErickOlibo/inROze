//
//  DeejayGigsTableViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 27/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

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
    var artist: Artist? { didSet { updateEventsMixtapes() } }
    let sepaColor = UIColor.lightGray.cgColor
    let sepaThick: CGFloat = 0.333
    var eventsOfDJ: [Event]?
    var mixtapesOfDJ: [Mixtape]?
    var isShowingMiniPlayer: Bool = false




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
        updateEventsMixtapes()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //let guide = view.safeAreaLayoutGuide
        //let insets = UIEdgeInsetsMake(topLayoutGuide.length, 0, bottomLayoutGuide.length, 0)
        //print("[DemoAlbumTableViewController] -> viewDidLayoutSubviews \(insets)")
        print("inset SafeArea: \(view.safeAreaInsets)")
        print("Inset AdditionalSafeAreaInsets: \(additionalSafeAreaInsets)")

        additionalSafeAreaInsets.bottom = isShowingMiniPlayer ? 17.0 : 0.0
        //let viewInsets = view.safeAreaInsets
        //let insets = UIEdgeInsetsMake(viewInsets.top, viewInsets.left, additionalSafeAreaInsets.bottom, viewInsets.right)
        tableView.contentInset = view.safeAreaInsets
        tableView.scrollIndicatorInsets = view.safeAreaInsets

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFollowedButton()
        updateDJInfo()
        updateSocialPageIcon()
        updateEventsMixtapes()
        tableHeaderView.addBorder(toSide: .Bottom, withColor: sepaColor, andThickness: sepaThick)
        setCoverProfileImage()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //print("[DeejayGigsTableViewController] ->  viewWillDisappear")
    }
    
    
    // ** Methods
    
    private func updateEventsMixtapes() {
        // set or updates data source for Table
        guard let deejay = artist else { return }
        
        if let context = container?.viewContext {
            context.perform {
                self.mixtapesOfDJ = Artist.findPerformingMixtapes(for: deejay, in: context)
                self.eventsOfDJ = Artist.findPerformingEvents(for: deejay, in: context)
                if self.gigsMixes != nil {
                    self.updateGigsMixesCount()
                }
                if let currentState = Artist.currentIsFollowedState(for: self.artist!.id!, in: context) {
                    self.artist!.isFollowed = currentState
                }
                self.tableView.reloadData()
            }
        }
    }
    
    
    private func setCoverProfileImage() {
        guard let dj = artist else { return }
        guard let coverURL = preferedProfileCoverURL(for: dj) else { return }
        profileCoverImage.kf.setImage(with: URL(string: coverURL), options: [.backgroundDecode, .transition(.fade(0.2))])
    }
    
    
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
        let gigsCount = eventsOfDJ?.count  ?? 0
        let mixtapesCount = mixtapesOfDJ?.count ?? 0
        gigsMixes.text = "\(gigsCount)Gs / \(mixtapesCount)Ms"
    }
    
    
    private func setDeejayImage() {
        guard let dj = artist else { return }
        guard let picURL = preferedProfilePictureURL(for: dj) else { return }
        djProfileImage.kf.setImage(with: URL(string: picURL), options: [.backgroundDecode, .transition(.fade(0.2))])
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
        container?.performBackgroundTask{ context in
            _ = Artist.changeIsFollowed(for: self.artist!.id!, in: context)
        }
    }
    

    private func updateDJInfo() {
        guard let artistName = artist?.name else { return }
        deejayName.text = artistName
    }
    
    
    private func updateFollowedButton() {
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
    

    
}


extension DeejayGigsTableViewController:  UINavigationControllerDelegate {
//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        if ((viewController as? EventsViewController) != nil) {
//            print("back to Events")
//        }
//    }
    
}


