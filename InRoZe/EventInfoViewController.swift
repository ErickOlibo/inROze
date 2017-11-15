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
    

    // ViewController Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //view.backgroundColor = .lightGray
        //print("Name: \(event?.name ?? "NO NAME")")
        collectionView.delegate = self
        collectionView.dataSource = self
        self.navigationController?.navigationBar.tintColor = Colors.logoRed
        
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
        guard let imageURL = thisEvent.imageURL else { return }
        guard let eventDesc = thisEvent.text else { return }
        eventText.attributedText = addTitleToText(forText: eventDesc, withTitle: "DETAILS:")
        eventCover.kf.setImage(with: URL(string: imageURL), options: [.backgroundDecode])
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










