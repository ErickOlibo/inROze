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
        let params = [FBUser.email, FBUser.name, FBUser.id, FBUser.gender, FBUser.cover].joined(separator: ", ")
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : params])
            .start(completionHandler:  { (connection, result, error) in
                if let result = result as? NSDictionary{
                    self.saveCurrentUserProfile(result)
                }
            })
    }
    
    // Save user info into the Server
    private func saveCurrentUserProfile(_ result: NSDictionary) {
        if let id = result[FBUser.id]  as? String,
            let name = result[FBUser.name] as? String {
            
            if let _ = AccessToken.current {
                // Get some info about User
                let email = result[FBUser.email] as? String? ?? ""
                let gender = result[FBUser.gender] as? String? ?? "Neutral"
                
                // Going to the network -> MOVE FROM MAIN QUEUE
                let parameters = "id=\(id)&name=\(name)&email=\(email!)&gender=\(gender!)"
                let serverRequest = ServerRequest()
                serverRequest.setUserLoggedIn(to: true, parameters: parameters, urlToServer: UrlFor.logInOut)
                
                
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


















