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
    @IBOutlet weak var selectCity: UIView!
    @IBOutlet weak var selectCityHeight: NSLayoutConstraint!
    
    var dropList: UIDropDown!
    
    @IBAction func loginTapped(_ sender: UIButton) {
        
        
        facebookButton.isHidden = true
        
        // Facebook login
        let loginManager = LoginManager()
        loginManager.logIn([.publicProfile, .email], viewController: self) { [weak self] loginResult in
            switch loginResult {
            case .failed(let error):
                self?.facebookButton.isHidden = false
                print(error.localizedDescription)
            case .cancelled:
                self?.facebookButton.isHidden = false
                print("cancelled")
            case .success( _,  _, _):
                self?.spinner.startAnimating()

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
        //print("DidLayout Subview View: \(self.selectCity.bounds.size)")
        //print("LogoImage center: \(logoImage.center.y) | logo size: \(logoImage.bounds.size.height)")
        displayDropList()
    }
    
    private func displayDropList () {
        // Drop down list
        //let orginalHeight = selectCityHeight.constant
        dropList = UIDropDown(frame: CGRect(x: 0, y: 0, width: self.selectCity.bounds.size.width, height: 40))
        dropList.hideOptionsWhenSelect = true
        //let centerY = logoImage.center.y + logoImage.bounds.size.height * 0.5 + 50
        dropList.center = CGPoint(x: self.selectCity.bounds.size.width * 0.5, y: self.selectCity.bounds.size.height * 0.5)
        print("DropList Center: \(dropList.center)")
        dropList.placeholder = "Select a City..."
        dropList.options = availableCities()
        dropList.didSelect { (option, index) in
            //put selection in the userDefault and enable facebook button
            
            print("Selected: \(option) at index: \(index)")
            
        }
        
        
        dropList.tableWillAppear {
            self.selectCity.center.y += self.dropList.tableHeight * 0.5
            self.selectCity.bounds.size.height += self.dropList.tableHeight
            
        }
        
        dropList.tableWillDisappear {
            self.selectCity.center.y -= self.dropList.tableHeight * 0.5
            self.selectCity.bounds.size.height -= self.dropList.tableHeight
            
        }
 
        self.selectCity.addSubview(dropList)
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
            //facebookButton.setFATitleColor(color: UIColor.green, forState: .selected)
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


















