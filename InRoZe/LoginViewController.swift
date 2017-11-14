//
//  LoginViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 05/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
//import FBSDKCoreKit
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
    
    @IBAction func loginTapped(_ sender: UIButton) {
        //hideUI(state: true)
        
        //spinner.color = Colors.logoRed
        self.view.bringSubview(toFront: foreGroundView)
        self.view.bringSubview(toFront: spinner)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.foreGroundView.isHidden = false
        }
        
        // Facebook login
        let loginManager = LoginManager()
        
        loginManager.logIn(readPermissions: [ReadPermission.publicProfile, ReadPermission.email], viewController: self) { [weak self] loginResult in
            self?.spinner.startAnimating()
            
            switch loginResult {
            case .failed(let error):
                self?.spinner.stopAnimating()
                //self?.hideUI(state: false)
                self?.foreGroundView.isHidden = true
                print(error.localizedDescription)
            case .cancelled:
                self?.spinner.stopAnimating()
                //self?.hideUI(state: false)
                self?.foreGroundView.isHidden = true
                print("cancelled")
            case .success( _,  _, _):
                // Get info about logged user and saved to Server as loggedIn
                let requestHandler = RequestHandler()
                requestHandler.requestUserInfo()
                
                UserProfile.loadCurrent{ profile in
                    // if is the first time app is launched
                    let wasLaunchedOnce = UserDefaults().wasLaunchedOnce
                    
                    if (!wasLaunchedOnce) {
                        UserDefaults().wasLaunchedOnce = true
                        RequestHandler().fetchEventIDsFromServer()
                    } else {
                        self?.updateDatabase()
                    }
                }
            }
        }
    }

    
    // change status bar color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foreGroundView.isHidden = true
        foreGroundView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        print("currentCity: \(UserDefaults().currentCityCode)")
        // facebook button
        updateFacebookButtonState()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Login view WILL appear")
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
    }
    
    private func displayDropList () {
        // Drop down list
        dropList = UIDropDown(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width * 0.6, height: dropListHeight))
        dropList.tableHeight = 196
        dropList.options = availableCities()
        let currentCityName = cityNameFrom(cityCode: UserDefaults().currentCityCode)
        let indexOfSelectedCity = availableCities().index(of: currentCityName)
        dropList.selectedIdx = indexOfSelectedCity
        dropList.animationType = UIDropDownAnimationType(rawValue: 2)!
        dropList.hideOptionsWhenSelect = true
        let yPoint = logoImage.center.y + logoImage.bounds.size.height * 0.5 + spacingFromBottom + dropListHeight * 0.5
        dropList.center = CGPoint(x: self.view.bounds.size.width * 0.5, y: yPoint)
        
        if (UserDefaults().currentCityCode != CityCode.none) {
            dropList.placeholder = currentCityName
        } else {
            dropList.placeholder = "Select a City..."
        }
        dropList.didSelect {(city, index)  in
            UserDefaults().currentCityCode = cityCodeFrom(cityName: city)
            print("Selected City: \(city) at cityCode: \(cityCodeFrom(cityName: city))")
            self.updateFacebookButtonState()
            
        }

        self.view.addSubview(dropList)
        let dropListBottomY = dropList.center.y + dropList.frame.size.height * 0.5
        let facebookButtonTopY = facebookButton.center.y - facebookButton.frame.size.height * 0.5
        dropList.tableHeight = facebookButtonTopY - dropListBottomY - paddingToFacebookButtonTop

    }
    
    
    // enable or disable the facebook button depending on City selected
    private func updateFacebookButtonState() {
        if (UserDefaults().currentCityCode != CityCode.none) {
            facebookButton.isEnabled = true
            facebookButton.backgroundColor = .clear
            facebookButton.layer.borderWidth = 3
            facebookButton.layer.borderColor = UIColor.changeHexStringToColor(ColorInHexFor.facebook).cgColor
            facebookButton.setFAText(prefixText: "", icon: .FAFacebook, postfixText: "  Log in with Facebook", size: 25, forState: .normal)
            facebookButton.setFATitleColor(color: UIColor.changeHexStringToColor(ColorInHexFor.facebook), forState: .normal)
            facebookButton.setTitleColor(.white, for: .highlighted)

        } else {
            facebookButton.isEnabled = false
            facebookButton.backgroundColor = .clear
            facebookButton.layer.borderWidth = 3
            facebookButton.layer.borderColor = UIColor.lightGray.cgColor
            facebookButton.setFAText(prefixText: "", icon: .FAFacebook, postfixText: "  Log in with Facebook", size: 25, forState: .normal)
            facebookButton.setFATitleColor(color: UIColor.lightGray, forState: .normal)
            
        }
    }


    // Once success -> get the request to load
    @objc private func updateDatabase () {
        
        spinner.stopAnimating()
        
        // Perform Segue programmatically
        performSegue(withIdentifier: "login view", sender: self)
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // remove Notification Observer
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationFor.initialLoginRequestIsDone), object: nil)
    }
    
   
}


















