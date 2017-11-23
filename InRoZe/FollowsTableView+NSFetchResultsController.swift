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
            //print("Sections Count: [\(sections.count)] -- This Section objects Count: [\(sections[section].numberOfObjects)]")
            return sections[section].numberOfObjects
            
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FollowsCell.identifier, for: indexPath) as! FollowsCell
        cell.tag = indexPath.row
        let event = fetchResultsController.object(at: indexPath)
        cell.event = event
        
        guard let imageURL = event.imageURL else { return cell }
        cell.eventCover.kf.setImage(with: URL(string: imageURL), options: [.backgroundDecode]) {
            (image, error, cachetype, imageUrl) in
            
            if (image != nil) {
                if (event.primary != nil && event.secondary != nil && event.detail != nil && event.background != nil) {
                    let colorsInHex = ColorsInHexString(background: event.background!, primary: event.primary!, secondary: event.secondary!, detail: event.detail!)
                    let colors = colorsFromHexString(with: colorsInHex)
                    cell.colors = colors
                    
                } else if let colors = self.colorsOfEventCovers[event.id!]{
                    cell.colors = colors
                } else {
                    image?.getColors(scaleDownSize: CGSize(width: 100, height: 100)){ [weak self] colors in
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
        guard let sections = fetchResultsController.sections else { fatalError("ISSUE WITH SECTINOS")}
        let dayTitle = sections[section].name
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMdd"
        guard let startDay = formatter.date(from: dayTitle) else { fatalError("CANT FORMAT DATE") }
        formatter.dateFormat = "EEEE"
        let weekDay = formatter.string(from: startDay)
        let splitDate = Date().split(this: startDay)
        
        let dayLabel = UILabel()
        let numLabel =  UILabel()
        //dayLabel.text = weekDay
        let numMonth = splitDate.num + ". " + splitDate.month
        let attributeOne =  [ NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Bold", size: 18.0)!, NSAttributedStringKey.foregroundColor: UIColor.white ]
        let attrWeekDay = NSAttributedString(string: weekDay, attributes: attributeOne)
        let attrNumMonth = NSAttributedString(string: numMonth, attributes: attributeOne)
        dayLabel.attributedText = attrWeekDay
        numLabel.attributedText = attrNumMonth
        //dayLabel.text = splitDate.day + " " + splitDate.num + " " + splitDate.month
        //dayLabel.textColor = .white
        numLabel.frame = CGRect(x: CellSize.phoneSizeWidth - 110, y: 0, width: 100, height: 30)
        numLabel.textAlignment = .right
        dayLabel.frame = CGRect(x: 10, y: 0, width: 200, height: 30)
        view.addSubview(dayLabel)
        view.addSubview(numLabel)
        view.backgroundColor = Colors.logoRed
        return view
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Follow Cell pressed at indexPath Row [\(indexPath.row)]")
    }
    
    
    
    // Mark - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Preparing for segue in Follows")
        if (segue.identifier == "Follows To EventInfo") {
            guard let followsCell = sender as? FollowsCell else { return }
            guard let destination = segue.destination as? EventInfoViewController else { return }
            guard let thisEvent = followsCell.event else { return }
            destination.event = thisEvent
            destination.navigationItem.title = thisEvent.location?.name ?? ""
            
            
        }
    }
}













