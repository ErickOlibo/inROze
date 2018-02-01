//
//  SettingsViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 25/07/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
//import FacebookLogin
//import FacebookCore
import FBSDKLoginKit
import FBSDKCoreKit
import CoreData

class SettingsViewController: UITableViewController {
    
    // Core Data model container and context
    //var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    
    // Properties
    var profile: FBSDKProfile?
    
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
    @IBOutlet weak var currentSettingsCity: UILabel!
    
    
    
    
    // View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
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
        navigationItem.title = profile?.name ?? "Settings"
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //print("Settings")
        setFollowsMix()
        setCurrentCity()

    }
    
    
    // Covenience Methods
    private func setCurrentCity() {
        currentSettingsCity.text = currentCity.name.rawValue
    }
    
    
    private func setFollowsMix() {
        // From Core data later
        let numFollowsInt = numbersFollowsAndMixtapes().0
        let numMixInt = numbersFollowsAndMixtapes().1
        
        let numFollows = String(numFollowsInt)
        let numMix = String(numMixInt)
        
        let followStr = (numFollows, "follows")
        let mixtapesStr = (numMix, "mixtapes")
        let fonts: (CGFloat, CGFloat) = (18.0, 13.0)
        let names: (String, String) = ("HelveticaNeue-Bold", "HelveticaNeue")
        var colorsFollow = (UIColor.black, UIColor.gray)
        var colorsMix = (UIColor.black, UIColor.gray)
        if (numFollowsInt == 0) { colorsFollow = (UIColor.gray, UIColor.gray) }
        if (numMixInt == 0) { colorsMix = (UIColor.gray, UIColor.gray) }
        let attrFollow = twoLinesFormatter(withTwoString: (followStr), fontNames: names, fontSizes: fonts, fontColors: colorsFollow)
        let attrMix = twoLinesFormatter(withTwoString: (mixtapesStr), fontNames: names, fontSizes: fonts, fontColors: colorsMix)
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
        let mixtapesNumb = Mixtape.listOfFollows(in: container!.viewContext).count
        //print("Mixtapes followed: \(mixtapesNumb)")
        return (followsNumb, mixtapesNumb)
    }
    
    
    
    
    // Update UI
    private func updateUI() {
        
    }
    
    private func setSignOutButton() {
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.backgroundColor = .clear
        signOutButton.setTitleColor(Colors.logoRed, for: .normal)
        signOutButton.setTitleColor(.lightGray, for: .highlighted)
        signOutButton.layer.borderColor = Colors.logoRed.cgColor
    }
    
    private func signOutTouched() {
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.backgroundColor = Colors.logoRed
        signOutButton.setTitleColor(.white, for: .normal)
        signOutButton.layer.borderColor = Colors.logoRed.cgColor
    }
    
    private func assignProfile() {
        print("Should Assign Profile")
        guard let user = FBSDKProfile.current() else { return }
        print("Did Assign Profile")
        profile = user
        let screenScale = UIScreen.main.scale
        let pictureDimension = 80.0 * screenScale
        guard let userImageURL = profile?.imageURL(for: .square, size: CGSize(width: pictureDimension, height: pictureDimension)) else { return }
        profileImage.kf.setImage(with: userImageURL, options: [.backgroundDecode, .transition(.fade(0.2))])
        profileName.text = user.name
    }
    
    
    // Button touch inside handler
    private func handleSignOut() {
        print("SIGN OUT TOUCH")
        
        // Sign the user out
        if (profile != nil) {
            print("PROFILE IS NOT NIL")
            guard let id = profile?.userID else { return }
            //let parameter = "id=\(id!)"
            let requestServer = ServerRequest()
            requestServer.taskLogInOutURLSession(to: false, userID: id, urlToServer: UrlFor.logInOut)
        }
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        setRootViewControllerToLoginVC()
        performSegue(withIdentifier: "unwindToLoginVC", sender: self)

    }
    
    
    private func setRootViewControllerToLoginVC () {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if (FBSDKAccessToken.current() == nil) {
            if let initViewController = storyboard.instantiateViewController(withIdentifier: "LoginIdentifier") as? LoginViewController {
                UIApplication.shared.keyWindow?.rootViewController = initViewController
            }
        }
    }
    
    private func handleMixtapes() {
        //print("PRESSED -> handleMixtapes")
    }

    private func handleFollows() {
        //print("PRESSED -> handleFollows")
    }
    
    
    
    
    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "Settings To View Your List") {
            let count = Mixtape.listOfFollows(in: container!.viewContext).count
            //print("Count of Mixtape follow: ", count)
            if (count == 0) { return false }
        }
        
        // For when segue to follows list - Mind name of the identifier
        if (identifier == "Settings To User Follows List") {
            let count = Artist.listOfFollows(in: container!.viewContext).count
            //print("Count of Deejays Follow: ", count)
            if (count == 0) { return false }
        }
        
        
        return true
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "Location Missing") {
            guard let destination = segue.destination as? AboutViewController else { return }
            destination.aboutURL = URL(string: UrlFor.locationMissing)
            destination.navigationItem.title = "Missing"
        }
        
        if (segue.identifier == "Support FAQ") {
            guard let destination = segue.destination as? AboutViewController else { return }
            destination.aboutURL = URL(string: UrlFor.supportFAQ)
            destination.navigationItem.title = "F.A.Q"
        }
        
        if (segue.identifier == "Support Feedback") {
            guard let destination = segue.destination as? AboutViewController else { return }
            destination.aboutURL = URL(string: UrlFor.supportFeedback)
            destination.navigationItem.title = "Feedback"
        }
        
        if (segue.identifier == "About Terms") {
            guard let destination = segue.destination as? AboutViewController else { return }
            destination.aboutURL = URL(string: UrlFor.aboutTerms)
            destination.navigationItem.title = "Terms Of Use"
        }

        if (segue.identifier == "About Privacy") {
            guard let destination = segue.destination as? AboutViewController else { return }
            destination.aboutURL = URL(string: UrlFor.aboutPrivacy)
            destination.navigationItem.title = "Privacy Policy"
        }

        if (segue.identifier == "About Sources") {
            guard let destination = segue.destination as? AboutViewController else { return }
            destination.aboutURL = URL(string: UrlFor.aboutSources)
            destination.navigationItem.title = "Licenses"
        }
        
        if (segue.identifier == "Settings To Login") {
            guard let _ = segue.destination as? LoginViewController else { return }
            //print("Here From Settings To Login")
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        if (segue.identifier == "Settings To View Your List") {
            guard let destination = segue.destination as? SearchCatalogueViewController else { return }
            destination.isForCatalogue = false
            destination.navigationItem.title = "Your List"
        }

    }
    
    

}















