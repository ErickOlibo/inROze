//
//  ServerRequest.swift
//  InRoZe
//
//  Created by Erick Olibo on 08/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation

let dataModelDidUpdateNotification = "dataModelDidUpdateNotification"

// GLOBAL var are a bad idea I think (to verify)
// should just let this for the moment
var resultServer = [String : Any]()

public class ServerRequest
{
   
    
    
    public func setUserLoggedIn(to isLogged: Bool, parameters: String, urlToServer: String) {
        
        let postParams = "\(parameters)&isLogged=\(isLogged)"
        let _ = taskForURLSession(postParams: postParams, url: urlToServer)
        //return result.count == 0 ? false : true
    }
    
    public func getEventsIDsCurrentList(parameter: String, urlToServer: String) {
        let _ = taskForURLSession(postParams: parameter, url: urlToServer)
    }
    
    private func taskForURLSession(postParams: String, url: String) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.httpBody = postParams.data(using: .utf8)
        //let result = [String: Any]()
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("JSON Result")
                    //print(json)
                    self.result = json
                    
                }
            } catch let error {
                print("Error in URL Session: ")
                print(error.localizedDescription)
            }
        }
        task.resume()
        //return result
    }
    
    var result: [String : Any]? {
        didSet {
            resultServer = result!
            print("Notification?")
            //print(result!)
            print("end of printing Result")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: dataModelDidUpdateNotification), object: nil)
        }

    }
    
    
    
}

