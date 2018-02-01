//
//  LoginViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 05/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
//import FacebookLogin
//import FacebookCore
import FBSDKLoginKit
import FBSDKCoreKit
import Font_Awesome_Swift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var cityBackground: UIImageView!
    @IBOutlet weak var foreGroundView: UIView!

    
    var dropList: UIDropDown!
    let spacingFromBottom: CGFloat = 20
    let dropListHeight: CGFloat = 40
    let paddingToFacebookButtonTop: CGFloat = 10 // calculated number
    var isdroppedDown = false
    
    @IBAction func loginTapped(_ sender: UIButton) { handleSignIn() }

    
    // change status bar color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        foreGroundView.isHidden = true
        foreGroundView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        print("viewDidLoad -> currentCity: ", currentCity.name.rawValue)
        // facebook button
        updateFacebookButtonState()
        
        // DropDown list setup
        dropList = UIDropDown(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width * 0.6, height: dropListHeight))
        dropList.tableHeight = 196
        self.view.addSubview(dropList)
        
        //print("login DID LOAD. Drop frame: \(dropList.frame)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //print("Login view WILL appear")
        updateFacebookButtonState()
        
        // add a City background random
        cityBackground.image = randomCityBackground()
        // Add Notification observer for after login fetch request to FB and Server
        NotificationCenter.default.addObserver(self, selector: #selector(updateDatabase), name: NSNotification.Name(rawValue: NotificationFor.initialLoginRequestIsDone), object: nil)
    }
    

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayDropList()
        //print("login DID APPEAR. Drop frame: \(dropList.frame)")
        dropList.tableDidAppear { self.isdroppedDown = true }
        dropList.tableDidDisappear  { self.isdroppedDown = false }
        UserDefaults().isFromLoginView = true
        
        
    }
    
    // Methods
    private func handleSignIn() {
        //hideUI(state: true)
        if isdroppedDown { dropList.willHideTable() }
        self.view.bringSubview(toFront: foreGroundView)
        self.view.bringSubview(toFront: spinner)
        foreGroundView.isHidden = false
        
        // Facebook login
        let loginManager = FBSDKLoginManager()
        let permissions = ["public_profile","email"]
        loginManager.logIn(withReadPermissions: permissions, from: self) { [weak self] (loginResult, error) in
            self?.spinner.startAnimating()
            if (error != nil) {
                print("LOGIN FAILED")
                self?.spinner.stopAnimating()
                self?.foreGroundView.isHidden = true
                guard let err = error else { return }
                print(err.localizedDescription)
                loginManager.logOut()
                
            } else if loginResult!.isCancelled {
                print("LOGIN CANCELLED")
                self?.spinner.stopAnimating()
                self?.foreGroundView.isHidden = true
                loginManager.logOut()
                
            } else {
                if (loginResult?.grantedPermissions != nil) {
                    print("LOGIN SUCCESS")
                    // Get info about logged user and saved to Server as loggedIn
                    RequestHandler().requestUserInfo()
                    UserDefaults().isLoggedIn = true
                    FBSDKProfile.loadCurrentProfile { (profile, error) in
                        let userID = profile?.userID ?? "123456"
                        let param = "id=\(userID)"
                        ServerRequest().setUserLoggedIn(to: true, parameters: param, urlToServer: UrlFor.logInOut)
                        RequestHandler().fetchEventIDsFromServer()
                    }
                }
            }
        }
    }
    
    
    
    private func displayDropList () {
        // Drop down list
        dropList.options = availableCities()
        let currentCityName = currentCity.name.rawValue
        let indexOfSelectedCity = availableCities().index(of: currentCityName)
        if (UserDefaults().currentCityCode != "NONE") {
            dropList.selectedIdx = indexOfSelectedCity
        }
        
        dropList.animationType = UIDropDownAnimationType(rawValue: 2)!
        dropList.hideOptionsWhenSelect = true
        let yPoint = logoImage.center.y + logoImage.bounds.size.height * 0.5 + spacingFromBottom + dropListHeight * 0.5
        dropList.center = CGPoint(x: self.view.bounds.size.width * 0.5, y: yPoint)
        
        if (UserDefaults.standard.object(forKey: UserKeys.cityCode) != nil) {
            dropList.placeholder = currentCityName
        } else {
            dropList.placeholder = "Select a City..."
        }
        dropList.didSelect {(city, index)  in
            let listCities = listCitiesInfo()
            let index = listCities.index(where: { $0.name == city })
            guard let idx = index else { return }
            let newCity = listCities[idx]
            
            UserDefaults().currentCityCode = newCity.code
            print("Selected City: \(city) at cityCode: \(newCity.code)")
            self.updateFacebookButtonState()
            
        }
        let dropListBottomY = dropList.center.y + dropList.frame.size.height * 0.5
        let facebookButtonTopY = facebookButton.center.y - facebookButton.frame.size.height * 0.5
        dropList.tableHeight = facebookButtonTopY - dropListBottomY - paddingToFacebookButtonTop

    }
    
    
    // enable or disable the facebook button depending on City selected
    private func updateFacebookButtonState() {
        if (UserDefaults.standard.object(forKey: UserKeys.cityCode) != nil) {
            facebookButton.isEnabled = true
            facebookButton.backgroundColor = .clear
            facebookButton.layer.borderWidth = 3
            facebookButton.layer.borderColor = Colors.facebook.cgColor
            facebookButton.setFAText(prefixText: "", icon: .FAFacebook, postfixText: "  Log in with Facebook", size: 14, forState: .normal, iconSize: 25)
            //facebookButton.setFAText(prefixText: "", icon: .FAFacebook, postfixText: "  Log in with Facebook", size: 14, forState: .normal)
            facebookButton.setFATitleColor(color: Colors.facebook, forState: .normal)
            facebookButton.setTitleColor(.white, for: .highlighted)

        } else {
            facebookButton.isEnabled = false
            facebookButton.backgroundColor = .clear
            facebookButton.layer.borderWidth = 3
            facebookButton.layer.borderColor = UIColor.lightGray.cgColor
            facebookButton.setFAText(prefixText: "", icon: .FAFacebook, postfixText: "  Log in with Facebook", size: 14, forState: .normal, iconSize: 25)
            //facebookButton.setFAText(prefixText: "", icon: .FAFacebook, postfixText: "  Log in with Facebook", size: 14, forState: .normal)
            facebookButton.setFATitleColor(color: UIColor.lightGray, forState: .normal)
            
        }
    }


    // Once success -> get the request to load
    @objc private func updateDatabase() {
        
        DispatchQueue.main.async { [unowned self] in
            
            // Perform Segue programmatically
            //print("I SHOULD THEN PERFORM SEGUE: \(Thread.current)")
            self.performSegue(withIdentifier: "login view", sender: self)
            self.spinner.stopAnimating()
            self.foreGroundView.isHidden = true
            //print("After SEGUE: \(Thread.current)")
        }
        
        
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // remove Notification Observer
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationFor.initialLoginRequestIsDone), object: nil)
    }
    
    
    // Unwinded from Modal
    @IBAction func unwindToLoginVC(_ segue: UIStoryboardSegue) {
        print("UNWIND To LOGIN VC")
        //updateUI()
        
    }
    
    
   
}


















