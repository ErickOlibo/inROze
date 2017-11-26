//
//  SettingsViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 25/07/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import CoreData

class SettingsViewController: UITableViewController {
    
    // Core Data model container and context
    //var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    
    // Properties
    var profile: UserProfile?
    
    // Actions
    @IBAction func signOutButton(_ sender: UIButton) { handleSignOut() }
    @IBAction func mixtapesButton(_ sender: UIButton) { handleMixtapes() }
    @IBAction func followsButton(_ sender: UIButton) { handleFollows() }
    
    // Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var numberMixtapesButton: UIButton!
    @IBOutlet weak var numberFollowsButton: UIButton!
    @IBOutlet weak var profileHolder: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var currentCity: UILabel!
    
    
    
    
    // View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerBorderColor = UIColor.lightGray.cgColor
        headerView.addBorder(toSide: .Bottom, withColor: headerBorderColor, andThickness: 0.333)
        
        profileHolder.backgroundColor = .white
        profileHolder.layer.borderColor = Colors.logoRed.cgColor
        profileHolder.layer.borderWidth = 2.0
        profileImage.layer.borderColor = UIColor.gray.cgColor
        profileImage.layer.borderWidth = 0.333
        setSignOutButton()
        assignProfile()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.view.backgroundColor = .white
        navigationItem.title = profile?.fullName ?? "Settings"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Settings")
        setFollowsMix()
        setCurrentCity()

    }
    
    
    // Covenience Methods
    private func setCurrentCity() {
        currentCity.text = UserDefaults().currentCityName
    }
    
    
    private func setFollowsMix() {
        // From Core data later
        let numFollows = String(numbersFollowsAndMixtapes().0)
        let numMix = "999+"
        
        let followStr = (numFollows, "follows")
        let mixtapesStr = (numMix, "mixtapes")
        let fonts: (CGFloat, CGFloat) = (18.0, 13.0)
        let names: (String, String) = ("HelveticaNeue-Bold", "HelveticaNeue")
        let colors = (UIColor.black, UIColor.gray)
        let attrFollow = twoLinesFormatter(withTwoString: (followStr), fontNames: names, fontSizes: fonts, fontColors: colors)
        let attrMix = twoLinesFormatter(withTwoString: (mixtapesStr), fontNames: names, fontSizes: fonts, fontColors: colors)
        numberMixtapesButton.titleLabel?.textAlignment = .center
        numberFollowsButton.titleLabel?.textAlignment = .center
        numberFollowsButton.titleLabel?.numberOfLines = 2
        numberMixtapesButton.titleLabel?.numberOfLines = 2
        numberFollowsButton.setAttributedTitle(attrFollow, for: .normal)
        numberMixtapesButton.setAttributedTitle(attrMix, for: .normal)
        
    }
    
    
    // get Follows and Mixtapes
    private func numbersFollowsAndMixtapes() -> (Int, Int) {
        // From Core data IsFollowed
        let followsNumb = Artist.listOfFollows(in: container!.viewContext).count

        // from Core Data numberOfFollowedMixtapes
        // let numberOfMixtapesFollowed = ?????
        
        return (followsNumb, 24)
    }
    
    
    
    
    // Update UI
    private func updateUI() {
        
    }
    
    private func setSignOutButton() {
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.backgroundColor = .clear
        signOutButton.setTitleColor(Colors.logoRed, for: .normal)
        signOutButton.layer.borderColor = Colors.logoRed.cgColor
    }
    
    private func assignProfile() {
        guard let user = UserProfile.current else { return }
        profile = user
        let screenScale = UIScreen.main.scale
        let pictureDimension = 80.0 * screenScale
        guard let userImageURL = profile?.imageURLWith(.square, size: CGSize(width: pictureDimension, height: pictureDimension)) else { return }
        profileImage.kf.setImage(with: userImageURL, options: [.backgroundDecode])
        profileName.text = user.fullName
    }
    
    
    // Button touch inside handler
    private func handleSignOut() {
        if (profile != nil) {
            let id = profile?.userId
            let parameter = "id=\(id!)"
            let requestServer = ServerRequest()
            requestServer.setUserLoggedIn(to: false, parameters: parameter, urlToServer: UrlFor.logInOut)
        }
        let loginManager = LoginManager()
        loginManager.logOut()
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func handleMixtapes() {
        print("PRESSED -> handleMixtapes")
    }

    private func handleFollows() {
        print("PRESSED -> handleFollows")
    }

}















