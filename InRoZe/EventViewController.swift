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
    let eventCell = "Event Cell"
    let kCellSizeCoef: CGFloat = 0.8
    let kFirstItemTransform: CGFloat = 0.05
    
    // DATA SOURCE for try
    let eventNameArray = FacebookEvents.eventNameArray
    let eventCoverArray = FacebookEvents.eventCoverArray
    let eventFeeArray = FacebookEvents.eventFeeArray
    
    
    
    // change status bar color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        // Testing the UIColorExtensions Helpers
        // from UIColor to Hex String format back to UIColor
        let testColor: UIColor = .black
        let hexString = UIColor.changeColorToHexString(testColor)
        let color = UIColor.changeHexStringToColor(hexString)
        view.backgroundColor = color
        collectionView.backgroundColor = color
        
        let stickyLayout = collectionView.collectionViewLayout as! StickyCollectionViewFlowLayout
        stickyLayout.firstItemTransform = kFirstItemTransform
    }
    
}




extension EventViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventCell, for: indexPath) as! EventCollectionViewCell
        
        var indexPathRow = Int(arc4random_uniform(10))
        cell.coverImage.image = UIImage(named: eventCoverArray[indexPathRow])
        indexPathRow = Int(arc4random_uniform(10))
        cell.eventName.text = eventNameArray[indexPathRow]
        
        // Title navBar calls current date but displaying Fee/price
        indexPathRow = Int(arc4random_uniform(10))
        currentDate.text = eventFeeArray[indexPathRow]
        
        // date (label) and dateDisplay bgcolor and footer bgcolor
        let date = FacebookEvents.getEventDate()
        
        cell.date.text = "\(date.day.uppercased())\n" + "\(date.num)\n" + "\(date.month.uppercased())"
        cell.dateDisplay.backgroundColor = Constants.colorOf(day: date.day)
        cell.footer.backgroundColor = Constants.colorOf(day: date.day)
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("the Selected Cell nr is: \(indexPath.row)")
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
