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
import FBSDKCoreKit

class LoginViewController: UIViewController {
    
    var userProfile: UserProfile?
    
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
                self?.requestUserInfo()
                
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

    
    // Call FB SDK GraphRequest and fetch user info
    private func requestUserInfo() {
        print("Inside request User")
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "email, name, id, gender, cover"])
            .start(completionHandler:  { (connection, result, error) in
                if let result = result as? NSDictionary{
                    print("HERE WITH INFO")
                    self.saveCurrentUserProfile(result)
                }
            })
    }

    
    // Save user info onto the dedicated database
    private func saveCurrentUserProfile(_ result: NSDictionary) {
        print("HERE WITH RESULTS")
        if let email = result["email"] as? String,
            let name = result["name"] as? String,
            let gender = result["gender"] as? String,
            let cover = result["cover"] as? NSDictionary,
            let userID = result["id"]  as? String,
            let profile = cover["source"] as? String {
            
            if let _ = AccessToken.current {
                
                print("[ \(email) | \(name) | \(gender) | \(userID) ]")
                print("\(profile)")
                
                if let currentUser = UserProfile.current {
                    print("current user got: \(currentUser)")
                } else {
                    print("Current user is NIL")
                    UserProfile.loadCurrent{ profile in
                        print("\(profile)")
                    }
                }
            }
        }
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


















