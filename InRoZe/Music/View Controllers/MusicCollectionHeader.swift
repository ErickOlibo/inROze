//
//  MusicCollectionHeader.swift
//  InRoZe
//
//  Created by Erick Olibo on 04/01/2018.
//  Copyright © 2018 Erick Olibo. All rights reserved.
//

import UIKit

class MusicCollectionHeader: UICollectionReusableView {
    
    // Properties
    static var identifier: String { return String(describing: self) }
    var sectionNames: [String]?
    
    // Outlets
    @IBOutlet weak var catalogueLbl: UILabel!
    @IBOutlet weak var separator: UIView! { didSet { updateSeparator() }}
    @IBOutlet weak var tableView: UITableView! { didSet { updateTableViewHeight() }}
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    private func updateSeparator() {
        separator.backgroundColor = Colors.logoRed
    }
    
    private func updateTableViewHeight() {
        //tableView.frame.height = CGFloat(260 * sectionNames.count)
    }
    
        
}



extension MusicCollectionHeader: UITableViewDataSource, UITableViewDelegate
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionNames?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OtherMusicListCell.identifier, for: indexPath) as! OtherMusicListCell
        guard let name = sectionNames?[indexPath.row] else { return cell }
        cell.selectionStyle = .none
        cell.sectionTitle.text = name
        cell.viewAllList.isHidden = name != "Your List" ? true : false

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260.0
    }

    
    
}
