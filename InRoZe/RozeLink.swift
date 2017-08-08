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
    // Logs IN or OUT the current User in the Server
    static func setUserLoggedIn(to isLogged: Bool, parameters: String, urlToServer: String) -> Bool {
        
        let postParams = "\(parameters)&isLogged=\(isLogged)"
        let result = taskForURLSession(postParams: postParams, url: urlToServer)
        return result.count == 0 ? false : true
        
      
    }
    
    // Gets the latest Events IDs from the Server (userID is necessary)
    static func getEventsIDsCurrentList(parameter: String, urlToServer: String) -> [String: Any] {
        return taskForURLSession(postParams: parameter, url: urlToServer)
    }
    
    // the Task of server query -> request and return
    private static func taskForURLSession(postParams: String, url: String) -> [String: Any] {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.httpBody = postParams.data(using: .utf8)
        
        var result = [String: Any]()
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
                    result = json
                }
            } catch let error {
                print("Error in URL Session: ")
                print(error.localizedDescription)
            }
        }
        task.resume()
        return result
    }
}

extension RozeLink {
    
    struct url {
        static let logInOut = "https://www.defkut.com/inroze/ServerRoze/users.php";
        static let currentEventsID = "https://www.defkut.com/inroze/ServerRoze/currentEvents.php";
    }
    
    
    
}








