//
//  OtherMusicListCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 05/01/2018.
//  Copyright © 2018 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData

class OtherMusicListCell: UITableViewCell {
    
    // Core Data model container and context
    //var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    
    
    // Properties
    static var identifier: String { return String(describing: self) }
    var mixtapes: [Mixtape]?
    
    // Outlets
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var separator: UIView! { didSet { updateSeparator() }}
    @IBOutlet weak var viewAllList: UIButton! { didSet { updateViewAllButton() }}
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // Actions
    @IBAction func viewAllTouched(_ sender: UIButton) {
        print("VIEW ALL TOUCHED")
    }
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func updateSeparator() {
        separator.backgroundColor = Colors.logoRed
    }
    
    private func updateViewAllButton() {
        viewAllList.setTitleColor(Colors.logoRed, for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension OtherMusicListCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return mixtapes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicListCollectionCell.identifier, for: indexPath) as! MusicListCollectionCell
        guard let mix = mixtapes?[indexPath.row] else { return cell }
        cell.mixtape = mix
        return cell
    }
    
}




