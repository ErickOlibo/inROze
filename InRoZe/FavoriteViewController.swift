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
        
        
        //request.collectEventIDsFromCoreData()
        
        //TRY
        //_ = request.requestCurrentEventsInfo(with: request.sampleEvents, parameters: request.tmpParam)
        
      
        // slicing and fetching
        let array = request.sampleEvents
        let params = request.param
        let batchSize = 2 // no issue with batch size bigger than all eventIDs
        _ = request.recursiveGraphRequest(array: array, parameters: params, batchSize: batchSize)
       

  
    }
 

}



