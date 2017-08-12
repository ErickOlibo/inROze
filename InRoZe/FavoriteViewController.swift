//
//  FavoriteViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 21/07/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Favorite")
        let request = FacebookRequest()
        
        //TRY
        //_ = request.requestCurrentEventsInfo(with: request.sampleEvents, parameters: request.tmpParam)
        
        
        // slicing and fetching
        let array = request.sampleEvents
        var fIdx = 0
        let bSize = 2
        while fIdx < array.count {
            var batch = bSize
            if (array.count - fIdx < bSize) {
                batch = array.count - fIdx
            }
            let currentArray = Array(array[fIdx ..< fIdx + batch])
            _ = request.requestCurrentEventsInfo(with: currentArray, parameters: request.tmpParam)
            fIdx += bSize
        }
        

        
    }
 

}



