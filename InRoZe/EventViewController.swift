//
//  EventViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 25/07/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    
    
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    
    // To try to sticky stuff
    let eventCell = "eventCell"
    let kCellSizeCoef: CGFloat = 0.8
    let kFirstItemTransform: CGFloat = 0.05
    
    let eventNameArray = ["Create a Hight Quality, High Ranking Search Ad",
                          "Evolve Your Ad Campaigns with Programmatic Buying",
                          "How Remarketing Keeps Customers Coming Back",
                          "Surviving and Thriving on Social Media",
                          "Keep Mobile Users Engaged In and Out of Your App",
                          "Appeal to Searchers and Search Engines with Seo",
                          "Build Your Business Fast with Growth Hacking",
                          "Track Your Acquisitions with Digital Metricks",
                          "This is fuckaries and I'm not sure I'm liking it",
                          "I'm supposed to really write 2 or 3 of them just for fun"]
    
    let eventCoverArray = ["fb1", "fb2", "fb3", "fb4", "fb5", "fb6", "fb7", "fb8", "fb9", "fb10"]
    
    let eventFeeArray = ["FREE to 20€", "0€/17€/100€", "Free for All", "123€", "12€/18€/29€",
                        "FREE to 20€", "0€/17€/100€", "Free for All", "123€", "12€/18€/29€"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        // Testing the UIColorExtensions Helpers
        // from UIColor to Hex String format back to UIColor
        let testColor: UIColor = .blue
        let hexString = UIColor.changeColorToHexString(testColor)
        let color = UIColor.changeHexStringToColor(hexString)
        view.backgroundColor = color
        
        let stickyLayout = collectionView.collectionViewLayout as! StickyCollectionViewFlowLayout
        stickyLayout.firstItemTransform = kFirstItemTransform
    }
    
}




extension EventViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventNameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventCell, for: indexPath) as! EventCollectionViewCell
        let name = eventNameArray[indexPath.row]
        let fee = eventFeeArray[indexPath.row]
        let image = eventCoverArray[indexPath.row]
        
        cell.nameEvent = name
        cell.eventFee = fee
        cell.imageName = image
        return cell
    }
    
    
}

extension EventViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: collectionView.bounds.height * kCellSizeCoef)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: NSInteger) -> CGFloat {
        return 0
    }
}
