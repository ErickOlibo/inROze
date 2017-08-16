//
//  LoginViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 05/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import FacebookLogin
//import FacebookCore
//import FBSDKCoreKit

class LoginViewController: UIViewController {
    
    
    @IBAction func loginTapped(_ sender: UIButton) {
        
        // Facebook login
        let loginManager = LoginManager()
        loginManager.logIn([.publicProfile, .email], viewController: self) { [weak self] loginResult in
            switch loginResult {
            case .failed(let error):
                print(error.localizedDescription)
            case .cancelled:
                print("cancelled")
            case .success( _,  _, _):
                // Get info about logged user
                let requestHandler = RequestHandler()
                requestHandler.requestUserInfo()
                
                //Perform Segue programmatically
                self?.performSegue(withIdentifier: "login view", sender: self)
            }
        }
    }
    
    // change status bar color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 

}


















