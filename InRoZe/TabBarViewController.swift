//
//  TabBarViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 05/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import AVFoundation


class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    public var sharedPlayer = AVPlayer()
    public var isShowingMiniPlayer: Bool = false
    private var isSameTab: Bool = false
    
    // token to keep for the MixtapePlayerViewController
    public var playerObserverToken: Any!
    
    
    // View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        //view.backgroundColor = .black
        //print("[TabBarViewController] -- View DID Load")
        self.tabBar.isTranslucent = true
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


extension TabBarViewController
{
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let indexOfTab = tabBar.items?.index(of: item) else { return }
        let index = Int(indexOfTab)
        isSameTab = (selectedIndex == index) ? true : false
    }
    
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let tempNavC = viewController as? UINavigationController else { return }
        if (isSameTab) {
            //print("Clicked on the same Tab")
            if let root = tempNavC.viewControllers[0] as? EventsViewController {
                root.tableView.setContentOffset(.zero, animated: true)
                root.collectionView.setContentOffset(.zero, animated: true)
            }
            if let root = tempNavC.viewControllers[0] as? FollowsViewController {
                root.tableView.setContentOffset(.zero, animated: true)
            }
            if let root = tempNavC.viewControllers[0] as? MusicViewController {
                root.collectionView?.setContentOffset(.zero, animated: true)
            }
            if let root = tempNavC.viewControllers[0] as? DeejaysViewController {
                root.tableView.setContentOffset(.zero, animated: true)
            }
        }
    }
    
    
}














