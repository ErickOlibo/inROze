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
    
    // Outlets
    @IBOutlet weak var catalogueLbl: UILabel!
    @IBOutlet weak var separator: UIView! { didSet { updateSeparator() }}
    @IBOutlet weak var tableView: UITableView! { didSet { updateTableViewHeight() }}
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Fetch all the sections and mixtapes for each section
        tableView.reloadData()
        
    }
    
    
    
    
    private func updateSeparator() {
        separator.backgroundColor = Colors.logoRed
    }
    
    private func updateTableViewHeight() {
        //tableView.frame.height = CGFloat(260 * sectionNames.count)
    }
    
    private func countNumberOfRows () -> Int {
        var numb = 0
        if let played = recentlyPlayedMix?.count, played > 0 {
            sectionNames.append(MixSection.recentlyPlayed)
            numb += 1
        }
        if let yourList = yourListMix?.count, yourList > 0 {
            sectionNames.append(MixSection.yourList)
            numb += 1
        }
        if let released = newReleasesMix?.count, released > 0 {
            sectionNames.append(MixSection.newReleases)
            numb += 1
        }
        
        print("Number of Section: ", numb)
        
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
        let name = sectionNames[indexPath.row]
        cell.selectionStyle = .none
        cell.sectionTitle.text = name
        cell.viewAllList.isHidden = name != MixSection.yourList ? true : false
        if (name == MixSection.yourList) {
            cell.mixtapes = yourListMix
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260.0
    }

    
    
}
