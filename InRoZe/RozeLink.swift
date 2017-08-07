//
//  RozeLink.swift
//  InRoZe
//
//  Created by Erick Olibo on 07/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation


// Struct To handle all connection to the InRoze Server
public struct RozeLink {
    
    
    // logs IN or OUT the current user
    // The boolean must be set to true (logs in) false (logs out)
    static func setUserLogIn(_ status: Bool, id: String, name: String, email: String?, gender: String?) {
        // MySQL Boolean deal in 1 and 0
        let isLogged = status ? 1 : 0
        let none = "none"
        
        let urlUser = url.logIn
        var request = URLRequest(url: URL(string: urlUser)!)
        request.httpMethod = "POST"
        let postParams = "id=\(id)&name=\(name)&email=\(email ?? none)&gender=\(gender ?? none)&isLogged=\(isLogged)"
        request.httpBody = postParams.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {

                    print(json)
                }
            } catch let error {
                print("Error in URL Session: ")
                print(error.localizedDescription)
            }
        }
        task.resume()
        
        
    }
    
}

extension RozeLink {
    
    struct url {
        static let logIn = "https://www.defkut.com/inroze/ServerRoze/users.php";
    }
    
    
    
}
