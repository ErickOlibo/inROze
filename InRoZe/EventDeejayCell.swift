//
//  EventDeejayCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 02/10/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData


class EventDeejayCell: UITableViewCell
{
    static var identifier: String {
        return String(describing: self)
    }
    
    var event: Event? { didSet { configureCellScroll() } }
    var djsViews = [DJNameView]()
    
    let djCellWidth: CGFloat = 90
    
    // context & container
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    // outlets to the UI components in the custom UITableViewCell
    @IBOutlet weak var eventCover: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventTimeLocation: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var coverHeight: NSLayoutConstraint!
    
    // for scrollView setup
    @IBOutlet weak var deejaysView: UIView!
    @IBOutlet weak var deejaysViewWidth: NSLayoutConstraint!
    
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        //collectionView.reloadData() // here is my scrolling issue
    }
    
    
    
    // configure the Cell
    private func configureCellScroll() {
        guard let event = event else { return }
        guard let name = event.name else { return }
        coverHeight.constant = eventCoverHeight
        eventCover.layoutIfNeeded()
        selectionStyle = .none
        eventTimeLocation.attributedText = dateTimeLocationFormatter(with: event)
        eventTitle.text = "[\(self.tag)] - \(name)"
        //eventTitle.text = name
        
        guard let imageURL = event.imageURL else { return }
        eventCover.kf.setImage(with: URL(string: imageURL), options: [.backgroundDecode])
        guard let djCount = event.performers?.count else { return }
        
        // load my class djView to scroll
//        for row in 0..<djCount {
//            let spacing = 10
//            let cellWidth = 80
//            let distX = CGFloat(row * ( spacing + cellWidth))
//            let nameView = DJNameView(frame: CGRect(x: distX, y: 0, width: 80, height: 100))
//            nameView.dj = thisDJ(row: row)
//            deejaysView.addSubview(nameView)
//        }
        
        // Alternative way
        for row in 0..<djCount {
            let spacing = 10
            let cellWidth = 80
            let distX = CGFloat(row * ( spacing + cellWidth))
            let nameView = djsViews[row]
            nameView.frame.origin = CGPoint(x: distX, y: 0)
            deejaysView.addSubview(nameView)
            
            // add gestureReconigzer
            let gestureRec = UITapGestureRecognizer(target: self, action: #selector (self.touchedDJcell(_:)))
            nameView.addGestureRecognizer(gestureRec)
        }
        
        
        let djsArea = djCellWidth * CGFloat(djCount)
        deejaysViewWidth.constant = djsArea
        
    }
    
    @objc private func touchedDJcell(_ sender: UITapGestureRecognizer) {
        guard let nameView = sender.view as? DJNameView else { return }
        
        print("DJ Cell Tapped - sender: [\(nameView.djName.text!)]")
    
    }
    
    
    
    private func configureCell() {
        guard let event = event else { return }
        guard let name = event.name else { return }
        coverHeight.constant = eventCoverHeight
        eventCover.layoutIfNeeded()
        selectionStyle = .none
        eventTimeLocation.attributedText = dateTimeLocationFormatter(with: event)
        eventTitle.text = "[\(self.tag)] - \(name)"
        //eventTitle.text = name
        
        guard let imageURL = event.imageURL else { return }
        eventCover.kf.setImage(with: URL(string: imageURL), options: [.backgroundDecode])
        
        // setting up collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.tag = self.tag
        collectionView.reloadData() // here is my scrolling issue
        collectionView.scrollRectToVisible(CGRect.zero, animated: false)
        
    }
    
    private func thisDJ (row: Int) -> Artist {
        let djsSet = event!.performers?.allObjects as! [Artist]
        let sorted = djsSet.sorted(by: {$0.name! < $1.name!})
        let deejay = sorted[row]
        return deejay
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        deejaysView.subviews.forEach() { $0.removeFromSuperview() }
        
        
    }
    
    
}




extension EventDeejayCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        let nrDJs = event?.performers?.count ?? 0
        return nrDJs
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let nameCell = cell as? EventDJNameCell else { return }

        let djsSet = event!.performers?.allObjects as! [Artist]
        let sorted = djsSet.sorted(by: {$0.name! < $1.name!})
        
        let deejay = sorted[indexPath.row]
        nameCell.djName.text = deejay.name!
        nameCell.thisDJ = deejay
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventDJNameCell.identifier, for: indexPath) as! EventDJNameCell
        return cell
    }
    
    // selected collection cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("row: \(indexPath.row)")
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//
//        
//    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    }
    
    
    
    
    
    
    
    
}
