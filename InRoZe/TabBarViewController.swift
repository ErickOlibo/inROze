//
//  TabBarViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 05/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit


class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .black
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = Colors.logoRed
        //listFonts()


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func listFonts() {
        let fontFamilyNames = UIFont.familyNames
        
        for familyName in fontFamilyNames {
            
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName)
            print("Font Names = [\(names)]")
        }
    }

}
