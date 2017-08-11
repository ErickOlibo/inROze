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
        let ids = request.sampleEvents
        let param = request.param
        _ = request.requestEventsInfo(with: ids, parameters: param)
        
    }
 

}



