//
//  EventInfoViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 14/11/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData

class EventInfoViewController: UIViewController {
    
    // Core Data model container and context
    //var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    
    // properties
    var event: Event? //{ didSet { updateUI() } }
    var orderedDJs = [Artist]()
    let color = UIColor.lightGray.cgColor
    let thick: CGFloat = 0.333
    
    // OUtlets
    @IBOutlet weak var eventCover: UIImageView!
    @IBOutlet weak var titleDateView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timeLocationView: UIView!
    @IBOutlet weak var eventText: UITextView!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var timeIcon: UILabel!
    @IBOutlet weak var placeIcon: UILabel!
    @IBOutlet weak var startEndTime: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventAddress: UILabel!
    

    // ViewController Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //view.backgroundColor = .lightGray
        //print("Name: \(event?.name ?? "NO NAME")")
        collectionView.delegate = self
        collectionView.dataSource = self
        self.navigationController?.navigationBar.tintColor = Colors.logoRed
        titleDateView.backgroundColor = Colors.logoRed
        timeLocationView.backgroundColor = UIColor.groupTableViewBackground
        
        // Separator for views
        titleDateView.addBorder(toSide: .Bottom, withColor: color, andThickness: thick)
        timeLocationView.addBorder(toSide: .Top, withColor: color, andThickness: thick)
        timeLocationView.addBorder(toSide: .Bottom, withColor: color, andThickness: thick)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Event Info View Controller")
        updateUI()
    }
    

    // Convenience Methods
    private func updateUI() {
        orderDJs()
        collectionView.reloadData()
        
        guard let thisEvent = event else { return }
        eventTitle.text = thisEvent.name ?? ""
        eventDate.addBorder(toSide: .Right, withColor: UIColor.white.cgColor, andThickness: 2.0)
        
        guard let startTime = thisEvent.startTime else { return }
        let splitStartDate = Date().split(this: startTime)
        eventDate.text = "\(splitStartDate.num)\n\(splitStartDate.month)"
        eventDate.tintColor = Colors.logoRed
        
        guard let endTime = thisEvent.endTime else { return }
        let splitEndDate = Date().split(this: endTime)
        startEndTime.text = "\(splitStartDate.hour) - \(splitEndDate.hour) (local time)"
        
        guard let imageURL = thisEvent.imageURL else { return }
        eventCover.kf.setImage(with: URL(string: imageURL), options: [.backgroundDecode])
        
        guard let eventDesc = thisEvent.text else { return }
        eventText.attributedText = addTitleToText(forText: eventDesc, withTitle: "DETAILS:")
        
        guard let placeName = thisEvent.location?.name else { return }
        guard let address = thisEvent.location?.street else { return }
        guard let city = thisEvent.location?.city else { return }
        eventLocation.text = placeName
        eventAddress.text = address + ", " + city.capitalized
        
        // The icons from FontAwesome
        guard let iconForTime = FAType.FAClockO.text else { return }
        guard let iconForPlace = FAType.FAMapMarker.text else { return }
        timeIcon.attributedText = fontAwesomeAttributedString(forString: iconForTime, withColor: Colors.logoRed, andFontSize: 30.0)
        placeIcon.attributedText = fontAwesomeAttributedString(forString: iconForPlace, withColor: .black, andFontSize: 30.0)
//        let fontSize: CGFloat = 20.0
//        let attributeOne = [ NSAttributedStringKey.font: UIFont(name: "FontAwesome", size: fontSize)! ]
//        let iconAttributedText = NSMutableAttributedString()
//        guard let iconForTime = FAType.FAHashtag.text else { return }
//        guard let iconForPlace = FAType.FAHashtag.text else { return }
        
        
    }

    private func addTitleToText(forText text: String, withTitle title: String) -> NSAttributedString {
        let lineBreak = "\n\n"
        let titleAndText = title + lineBreak + text
        let attributedDescription = NSMutableAttributedString(string: titleAndText, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15.0)])
        let boldFontAttribute = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15.0)]
        attributedDescription.addAttributes(boldFontAttribute, range: (titleAndText as NSString).range(of: title))
        return attributedDescription
    }
    
    private func orderDJs() {
        guard let allDJs = event?.performers?.allObjects as? [Artist] else { return }
        let djsListArr = Array(allDJs)
        let sorted = djsListArr.sorted(by: { lhs, rhs in
            if lhs.isFollowed == rhs.isFollowed {
                return lhs.name! < rhs.name!
            }
            return lhs.isFollowed && !rhs.isFollowed
        })
        orderedDJs = sorted
    }

}


extension EventInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return orderedDJs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventInfoDJNameCell.identifier, for: indexPath) as! EventInfoDJNameCell
        cell.thisDJ = orderedDJs[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("row: \(indexPath.row)")
    }
    
}










