//
//  MusicCollectionHeader.swift
//  InRoZe
//
//  Created by Erick Olibo on 04/01/2018.
//  Copyright © 2018 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData

class MusicCollectionHeader: UICollectionReusableView {
    
    // Core Data model container and context
    //var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    
    // Properties
    static var identifier: String { return String(describing: self) }
    var sectionNames = [String]()
    var recentlyPlayedMix: [Mixtape]?
    var newReleasesMix: [Mixtape]?
    var yourListMix: [Mixtape]?
    var numberOfCell: Int = 0
    var cellsTitleList = [String]()
    
    // Outlets
    @IBOutlet weak var catalogueLbl: UILabel!
    @IBOutlet weak var separator: UIView! { didSet { updateSeparator() }}
    @IBOutlet weak var tableView: UITableView! { didSet { updateTableViewHeight() }}
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Fetch all the sections and mixtapes for each section
        tableView.separatorColor = .clear
        tableView.reloadData()
        
    }
    
    
    func reloadAllData() {
        tableView.reloadData()
    }
    
    private func updateSeparator() {
        separator.backgroundColor = Colors.logoRed
    }
    
    private func updateTableViewHeight() {
        //tableView.frame.height = CGFloat(260 * sectionNames.count)
    }
    
    private func countNumberOfRows () -> Int {
        var titlesName = [String]()
        var numb = 0
        if let released = newReleasesMix?.count, released > 0 {
            titlesName.append(MixSection.newReleases)
            numb += 1
        }
        if let played = recentlyPlayedMix?.count, played > 0 {
            titlesName.append(MixSection.recentlyPlayed)
            numb += 1
        }
        if let yourList = yourListMix?.count, yourList > 0 {
            titlesName.append(MixSection.yourList)
            numb += 1
        }
        
        cellsTitleList = titlesName
        print("Number of Section: ", numb)
        for name in titlesName {
            print("title Name: ", name)
        }
        return numb
    }
    
        
}



extension MusicCollectionHeader: UITableViewDataSource, UITableViewDelegate
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OtherMusicListCell.identifier, for: indexPath) as! OtherMusicListCell
        let name = cellsTitleList[indexPath.row]
        print("Name: [\(name)] - Row: [\(indexPath.row)]")
        cell.selectionStyle = .none
        cell.sectionTitle.text = name
        cell.viewAllList.isHidden = name != MixSection.yourList ? true : false
        
        // Switch Name Cell
        switch name {
        case MixSection.newReleases:
            cell.mixtapes = newReleasesMix
        case MixSection.recentlyPlayed:
            cell.mixtapes = recentlyPlayedMix
        case MixSection.yourList:
            cell.mixtapes = yourListMix
        default:
            print("name of the cell is not conform")
        }
//        if (name == MixSection.yourList) {
//            print("YOUR LIST Mix: [\(yourListMix?.count ?? 0)]")
//            cell.mixtapes = yourListMix
//        }
        
        cell.collectionView.reloadData()
        cell.collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260.0
    }

    
    
}
