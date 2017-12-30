//
//  FollowsTableView+NSFetchResultsController.swift
//  InRoZe
//
//  Created by Erick Olibo on 17/11/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher


extension FollowsViewController
{
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchResultsController.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FollowsCell.identifier, for: indexPath) as! FollowsCell
        cell.cleanCell = true
        cell.selectionStyle = .none
        cell.tag = indexPath.row
        let event = fetchResultsController.object(at: indexPath)
        cell.event = event
        
        guard let imageURL = event.imageURL else { return cell }
        cell.eventCover.kf.setImage(with: URL(string: imageURL), options: [.backgroundDecode]) {
            (image, error, cachetype, imageUrl) in
            cell.eventCover.image = nil
            if (image != nil) {
                if (event.colorPrimary != nil && event.colorSecondary != nil && event.colorDetail != nil && event.colorBackground != nil) {
                    let colorsInHex = ColorsInHexString(background: event.colorBackground!, primary: event.colorPrimary!, secondary: event.colorSecondary!, detail: event.colorDetail!)
                    let colors = colorsFromHexString(with: colorsInHex)
                    cell.coverImage = image
                    cell.colors = colors
                    
                    
                } else if let colors = self.colorsOfEventCovers[event.id!]{
                    cell.coverImage = image
                    cell.colors = colors
                } else {
                    image?.getColors(scaleDownSize: CGSize(width: 100, height: 100)){ [weak self] colors in
                        cell.coverImage = image
                        cell.colors = colors
                        self?.colorsOfEventCovers[event.id!] = colors
                    }
                }
            }
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        guard let sections = fetchResultsController.sections else { fatalError("ISSUE WITH SECTIONS")}
        let dayTitle = sections[section].name
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMdd"
        guard let startDay = formatter.date(from: dayTitle) else { fatalError("CANT FORMAT DATE") }
        formatter.dateFormat = "EEEE"
        let weekDay = formatter.string(from: startDay)

        formatter.dateFormat = "d MMMM"
        let dayNumMonth = formatter.string(from: startDay).uppercased()
        let dayLabel = UILabel()
        let numLabel =  UILabel()

        let attributeOne =  [ NSAttributedStringKey.font: UIFont(name: "AvenirNext-Bold", size: 35.0)!, NSAttributedStringKey.foregroundColor: UIColor.black ]
        let attributeTwo =  [ NSAttributedStringKey.font: UIFont(name: "AvenirNext-medium", size: 15.0)!, NSAttributedStringKey.foregroundColor: UIColor.gray ]
        let attrWeekDay = NSAttributedString(string: weekDay, attributes: attributeOne)
        let attrNumMonth = NSAttributedString(string: dayNumMonth, attributes: attributeTwo)
        dayLabel.attributedText = attrWeekDay
        numLabel.attributedText = attrNumMonth

        // Day of Week
        dayLabel.frame = CGRect(x: 35, y: 50, width: CellSize.phoneSizeWidth, height: 50)
        dayLabel.textAlignment = .left
        
        numLabel.frame = CGRect(x: 35, y: 35, width: CellSize.phoneSizeWidth, height: 25)
        numLabel.textAlignment = .left
        
        let redLine = UIView(frame: CGRect(x: 15, y: 61, width: 10, height: 25))
        redLine.backgroundColor = Colors.logoRed
        
        view.addSubview(dayLabel)
        view.addSubview(numLabel)
        view.addSubview(redLine)
        view.backgroundColor = .white
        return view
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    // Just Added
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Follow Cell pressed at indexPath Row [\(indexPath.row)]")
    }
    
    
    
    // Mark - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Follows To EventInfo") {
            guard let followsCell = sender as? FollowsCell else { return }
            guard let destination = segue.destination as? EventInfoViewController else { return }
            guard let thisEvent = followsCell.event else { return }
            destination.event = thisEvent
            destination.navigationItem.title = thisEvent.location?.name ?? ""
            
            
        }
    }
}













