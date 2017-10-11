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
    
    var event: Event?
    
    // context & container
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    // outlets to the UI components in the custom UITableViewCell
    @IBOutlet weak var eventCover: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventTimeLocation: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var coverHeight: NSLayoutConstraint!
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        print("SetCollectionViewSource: what row: [\(row)]")
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        //collectionView.reloadData() // here is my scrolling issue
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
        return event?.performers?.count ?? 0
        //return 0
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("Before Reuse how many Cells visible: [\(self.collectionView.visibleCells.count)]")
    }

}
