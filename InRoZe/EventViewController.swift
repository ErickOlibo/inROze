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
    
    
    //instantiate 
    
    
    // Setting Cell Layout
    let eventCell = "Event Cell"
    let cellHeightOffset: CGFloat = 140.0 // distance between bottom picture and bottom cell
    let zoomOutFirstItemTransform: CGFloat = 0.1
    
    // DATA SOURCE for try
    let eventNameArray = FacebookEvents.eventNameArray
    let eventCoverArray = FacebookEvents.eventCoverArray
    let eventFeeArray = FacebookEvents.eventFeeArray
    let eventLocationArray = FacebookEvents.eventLocationArray
    
    var eventDateArray = [FacebookEvents.getEventDate()]
    
    
    
    // change status bar color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        for _ in 1...(eventCoverArray.count) {
            let date = FacebookEvents.getEventDate()
           eventDateArray.append(date)
        }
        
        // Testing the UIColorExtensions Helpers
        // from UIColor to Hex String format back to UIColor
        let testColor: UIColor = .purple
        let hexString = UIColor.changeColorToHexString(testColor)
        let color = UIColor.changeHexStringToColor(hexString)
        view.backgroundColor = color
        collectionView.backgroundColor = color
        
        let stickyLayout = collectionView.collectionViewLayout as! StickyCollectionViewFlowLayout
        stickyLayout.firstItemTransform = zoomOutFirstItemTransform
        
    }
    
    fileprivate func coloredString(_ string: String, color: UIColor) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        let stringRange = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: stringRange)
        return attributedString
    }
    
    
    // # MARK - Create gradient layered view
    fileprivate func createGradientLayer() {
        
    }
    
}




extension EventViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventCoverArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventCell, for: indexPath) as! EventCollectionViewCell
        
        let eName = eventNameArray[indexPath.row]
        let date = eventDateArray[indexPath.row]
        let eDate = "\(date.day.uppercased())\n" + "\(date.num)\n" + "\(date.month.uppercased())"
        let place = eventLocationArray[indexPath.row]
        
        cell.eventName.text = eventNameArray[indexPath.row]
        currentDate.text = eventFeeArray[indexPath.row]
        
        
        let cellImage = UIImage(named: eventCoverArray[indexPath.row])
        cell.coverImage.image = cellImage // BLOCK THE MAIN THREAD
        
        // Image part on a bacground queue --> (scaleDownSize: CGSize(width: 100, height: 100))
        cellImage?.getColors(scaleDownSize: CGSize(width: 100, height: 100)) { colors in
            cell.eventName.attributedText = self.coloredString(eName, color: colors.primary)
            if colors.secondary.isDarkColor {
                
                cell.date.attributedText = self.coloredString(eDate, color: .white)
            } else {
                cell.date.attributedText = self.coloredString(eDate, color: .black)
            }
            //cell.date.attributedText = self.coloredString(eDate, color: colors.detail)
            cell.eventLocation.attributedText = self.coloredString(place, color: colors.detail)
            
            cell.dateDisplay.backgroundColor = colors.primary
            cell.footer.backgroundColor = colors.primary
            
            cell.cellBackground.backgroundColor = colors.background

            // Small squares
            cell.background.backgroundColor = colors.detail
            cell.primary.backgroundColor = colors.primary
            cell.secondary.backgroundColor = colors.secondary
            cell.detail.backgroundColor = colors.detail
            
        }

        

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("the Selected Cell nr is: \(indexPath.row)")
    }
    
    
}

extension EventViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: collectionView.bounds.width * (9 / 16) + cellHeightOffset)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: NSInteger) -> CGFloat {
        return 0
    }
}








