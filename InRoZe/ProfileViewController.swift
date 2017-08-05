//
//  ProfileViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 25/07/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class ProfileViewController: UIViewController {
    
    @IBAction func signOutButton(_ sender: UIButton) {
        handleSignOut()
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .yellow
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("VIEW DID APPEAR IN PROFILE")
        //Some other info
        let profile = UserProfile.current
        if (profile != nil) {
            print("\(profile!.fullName!)")
            print("\(profile!.firstName!)")
            print("\(profile!.profileURL!)")
        }
        
    }
    
    
    fileprivate func handleSignOut() {
        
        //Facebook LogOut
        let loginManager = LoginManager()
        loginManager.logOut()
        
        if let _ = AccessToken.current {
            print("Token is SET")
        } else {
            print("Token is NIL")
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
