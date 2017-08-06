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
    
    @IBAction func loginTapped(_ sender: UIButton) {
        
        // Facebook login
        let loginManager = LoginManager()
        loginManager.logIn([.publicProfile, .email], viewController: self) { [weak self] loginResult in
            switch loginResult {
            case .failed(let error):
                print(error.localizedDescription)
            case .cancelled:
                print("cancelled")
            case .success(let grantedPermissions, let declinedPermissions, let userInfo):
                
                let granted = grantedPermissions.map { "\($0)" }.joined(separator: " ")
                print("\(granted)")
                
                let declined = declinedPermissions.map { "\($0)" }.joined(separator: " ")
                print("\(declined)")
                
                let userOne = userInfo.appId
                //let userTwo = userInfo.authenticationToken
                // print("authToken: [\(userTwo)]")
                
                let userThree = userInfo.expirationDate
                let userFour = userInfo.refreshDate
                let userFive = userInfo.userId
                print("appID: [\(userOne)]")
                print("expiration: [\(userThree)]")
                print("refresh: [\(userFour)]")
                print("userID: [\(userFive ?? "")]")
                
                
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
        
        // Getting Logged User info and save them on UserProfile.Current
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "email, name, id, gender, cover"])
            .start(completionHandler:  { (connection, result, error) in
                if let result = result as? NSDictionary, let email = result["email"] as? String,
                    let name = result["name"] as? String,
                    let gender = result["gender"] as? String,
                    let cover = result["cover"] as? NSDictionary,
                    let userID = result["id"]  as? String {
                    
                    print("\(email)")
                    print("\(name)")
                    print("\(gender)")
                    print("\(userID)")
                    print("\(cover["source"]!)")
                    
                }
            })
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


















