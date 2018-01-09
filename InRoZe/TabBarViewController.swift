//
//  TabBarViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 05/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import AVFoundation


class TabBarViewController: UITabBarController {
    
    public var sharedPlayer = AVPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .black
        print("[TabBarViewController] -- View DID Load")

        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = Colors.logoRed
        //listFonts()


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("[TabBarViewController] -- View WILL Appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("[TabBarViewController] -- View DID Appear")
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("[TabBarViewController] -- View WILL Disappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("[TabBarViewController] -- View DID Disappear")
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
