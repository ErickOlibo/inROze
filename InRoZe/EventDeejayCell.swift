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
    @IBOutlet weak var locationCover: UIImageView!
    @IBOutlet weak var eventCover: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventTimeLocation: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
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
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventDJNameCell.identifier, for: indexPath) as! EventDJNameCell
        
        if let context = container?.viewContext {
            context.perform {
                if let performingDeejays = Artist.orderedPerformingDeejays(for: self.event!, in: context) {
                    let deejay = performingDeejays[indexPath.row]
                    cell.djName.text = deejay.name!
                    cell.thisDJ = deejay
                    print("[\(indexPath.row)] - performing DJ: [\(performingDeejays[indexPath.row].name!)]")
                }
            }
        }
        return cell
    }
    
    // selected collection cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("row: \(indexPath.row)")
        
        
    }
    
    
    
}









