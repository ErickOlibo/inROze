//
//  ArtistSearchViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 22/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class ArtistSearchViewController: UIViewController {
    
    @IBAction func signOutButton(_ sender: UIButton) {
        handleSignOut()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Artist Search")
        
        //Some other info
        let profile = UserProfile.current
        if (profile != nil) {
            print("\(profile!.fullName!)")
            //print("\(profile!.firstName!)")
            //print("\(profile!.profileURL!)")
        }
    }
    
    fileprivate func handleSignOut() {
        //Some user info
        let profile = UserProfile.current
        
        if (profile != nil) {
            let id = profile?.userId
            
            // Going to the network -> MOVE FROM MAIN QUEUE
            let parameter = "id=\(id!)"
            let requestServer = ServerRequest()
            requestServer.setUserLoggedIn(to: false, parameters: parameter, urlToServer: UrlFor.logInOut)
        }
        
        //Facebook LogOut
        let loginManager = LoginManager()
        loginManager.logOut()
        
        if let _ = AccessToken.current {
            
            print("Token is SET")
        } else {
            print("Token is NIL")
        }
        
    }


}
