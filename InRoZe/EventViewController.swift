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

    let eventCell = "Event Cell"
    let cellHeightOffset: CGFloat = 140.0 // distance between bottom picture and bottom cell
    let zoomOutFirstItemTransform: CGFloat = 0.1

    // Get Events
    var fbEvents = FBEventS(size: 100)
    
    // change status bar color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .black
        let stickyLayout = collectionView.collectionViewLayout as! StickyCollectionViewFlowLayout
        stickyLayout.firstItemTransform = zoomOutFirstItemTransform
        
        
    }
}


extension EventViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fbEvents.events.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventCell, for: indexPath) as! EventCollectionViewCell
        // Here I should reset the cell
        if ((cell.coverImage) != nil) {
            cell.clear()
            cell.placeHolder(isTrue: true)
            print("Reuseable cell (\(indexPath.row)) is NOT NIL")
        } else {
            print("cell is NIL")
        }
        
        var event = fbEvents.events[indexPath.row]
        let cover = UIImage(named: event.cover)
        
        if event.colors == nil {
            cover?.getColors(scaleDownSize: CGSize(width: 100, height: 100)) { colors in
                event.colors = colors
                cell.eventCell = event
            }
        } else { cell.eventCell = event }
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






