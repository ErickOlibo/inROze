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
    @IBOutlet weak var currentSettingsCity: UILabel!
    
    
    
    
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
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Settings")
        setFollowsMix()
        setCurrentCity()

    }
    
    
    // Covenience Methods
    private func setCurrentCity() {
        currentSettingsCity.text = currentCity.name.rawValue
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
        //signOutTouched()
        if (profile != nil) {
            let id = profile?.userId
            let parameter = "id=\(id!)"
            let requestServer = ServerRequest()
            requestServer.setUserLoggedIn(to: false, parameters: parameter, urlToServer: UrlFor.logInOut)
        }
        let loginManager = LoginManager()
        loginManager.logOut()
        self.dismiss(animated: true, completion: nil)
        // Animated: true might cause issues. if it does, change to false
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func handleMixtapes() {
        print("PRESSED -> handleMixtapes")
    }

    private func handleFollows() {
        print("PRESSED -> handleFollows")
    }
    
    
    // Trying the delegate from a statci cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DID SELECT at IndexPath [Section : Row] -> [\(indexPath.section) : \(indexPath.row)]")
        
        // Cell pressed is Where is my city
        let whereCityPath = IndexPath(row: 1, section: 0)
        let missingDJPath = IndexPath(row: 2, section: 1)
        if whereCityPath == indexPath { openMyCityAlert() }
        if missingDJPath == indexPath { openMissingDJAlert()}
        
    }
    
    
    // Covenience Methods
    private func openMyCityAlert() {
        let alert = UIAlertController(title: "Your City?",
                                      message: "We are adding new Capital cities and large cities on a regular basis.\n\nVOTE for your city!",
                                      preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action: UIAlertAction) -> Void in
            alert.dismiss(animated: true, completion: nil)
            print("Cancel pressed")
        }
        let ok = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) -> Void in
            alert.dismiss(animated: true, completion: nil)
//            let textCityName = alert.textFields?[0]
//            print("OK pressed - \(textCityName?.text!)")
        }
        
        // add text field
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "City Name"
            textField.textColor = Colors.logoRed
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    private func openMissingDJAlert() {
        let alert = UIAlertController(title: "Your Local DJ?",
                                      message: "If you are or know a DJ that should appear in our app, let us know.\n\nSuggest a local DJ!",
                                      preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action: UIAlertAction) -> Void in
            alert.dismiss(animated: true, completion: nil)
            print("Cancel pressed")
        }
        let ok = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) -> Void in
            alert.dismiss(animated: true, completion: nil)
            //            let textCityName = alert.textFields?[0]
            //            print("OK pressed - \(textCityName?.text!)")
        }
        
        // add text field
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Deejay's name"
            textField.textColor = Colors.logoRed
        }
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "His city"
            textField.textColor = Colors.logoRed
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "About Inroze") {
            guard let destination = segue.destination as? AboutViewController else { return }
            destination.aboutURL = URL(string: UrlFor.aboutInroze)
            destination.navigationItem.title = "InRoze"
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
        

    }
    
    

}















