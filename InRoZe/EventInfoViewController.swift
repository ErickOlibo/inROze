//
//  EventInfoViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 14/11/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class EventInfoViewController: UIViewController {
    
    // Core Data model container and context
    //var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    
    // properties
    var event: Event?
    var orderedDJs = [Artist]()
    let color = UIColor.lightGray.cgColor
    let thick: CGFloat = 0.333
    var colors: UIImageColors? { didSet { configureColorsToUI() } }
    
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
    @IBOutlet weak var directionIcon: UILabel!
    

    // ViewController Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        self.navigationController?.navigationBar.tintColor = Colors.logoRed
        titleDateView.backgroundColor = UIColor.groupTableViewBackground
        timeLocationView.backgroundColor = UIColor.groupTableViewBackground
        
        // Separator for views
        titleDateView.addBorder(toSide: .Bottom, withColor: color, andThickness: thick)
        timeLocationView.addBorder(toSide: .Top, withColor: color, andThickness: thick)
        timeLocationView.addBorder(toSide: .Bottom, withColor: color, andThickness: thick)
        
        // Tap recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapMapDirection))
        directionIcon.isUserInteractionEnabled = true
        directionIcon.addGestureRecognizer(tap)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    // For the tap on the label
    @objc func tapMapDirection(sender: UITapGestureRecognizer) {
        
        guard let venueName = event?.location?.name else { return }
        
        let alertController = UIAlertController(title: "Open in Maps", message: "Get Directions to \(venueName)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) -> Void in
            alertController.dismiss(animated: true, completion: nil)
            self.openMapForPlace()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action: UIAlertAction) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Convenience functions
    private func configureColorsToUI() {
        guard let background = colors?.background else { return }
        guard let primary = colors?.primary else { return }
        guard let secondary = colors?.secondary else { return }
        
        // here is for the View design
        if (background.isWhiteColor) {
            titleDateView.backgroundColor = secondary
            eventTitle.textColor = background
            eventDate.textColor = background
            eventDate.addBorder(toSide: .Right, withColor: background.cgColor, andThickness: 2.0)
        } else {
            titleDateView.backgroundColor = background
            eventTitle.textColor = primary
            eventDate.textColor = primary
            eventDate.addBorder(toSide: .Right, withColor: primary.cgColor, andThickness: 2.0)
        }
        
    }
    
    
    private func openMapForPlace() {
        
        guard let venueName = event?.location?.name else { return }
        guard let lat = event?.location?.latitude else { return }
        guard let lon = event?.location?.longitude else { return }
        
        let latitude: CLLocationDegrees = Double(lat)
        let longitude: CLLocationDegrees = Double(lon)
        
        let regionDistance:CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = venueName
        mapItem.openInMaps(launchOptions: options)
    }
    
    
    // Convenience Methods
    private func updateUI() {
        orderDJs()
        collectionView.reloadData()
        
        guard let thisEvent = event else { return }
        guard let eventID = thisEvent.id else { return }
        eventTitle.text = thisEvent.name ?? ""
        
        guard let startTime = thisEvent.startTime else { return }
        let splitStartDate = Date().split(this: startTime)
        eventDate.text = "\(splitStartDate.num)\n\(splitStartDate.month)"
        
        guard let endTime = thisEvent.endTime else { return }
        let splitEndDate = Date().split(this: endTime)
        startEndTime.text = "\(splitStartDate.hour) - \(splitEndDate.hour) (local time)"
        
        // Set the Colors and update the UI
        guard let imageURL = thisEvent.imageURL else { return }
        eventCover.kf.setImage(with: URL(string: imageURL), options: [.backgroundDecode]) {
            (image, error, cachetype, imageUrl) in
            
            if (image != nil) {
                // conditional Settings for Colors
                if (thisEvent.primary != nil && thisEvent.secondary != nil && thisEvent.detail != nil && thisEvent.background != nil) {
                    // In Database
                    let colorsInHex = ColorsInHexString(background: thisEvent.background!, primary: thisEvent.primary!, secondary: thisEvent.secondary!, detail: thisEvent.detail!)
                    let colors = colorsFromHexString(with: colorsInHex)
                    self.colors = colors
                } else {
                    image?.getColors(scaleDownSize: CGSize(width: 100, height: 100)){ [weak self] colors in
                        self?.colors = colors
                        self?.container?.performBackgroundTask { context in
                            let colorsInHex = colorsToHexString(with: colors)
                            _ = Event.updateEventImageColors(with: eventID, and: colorsInHex, in: context)
                            
                            // Save Context
                            do {
                                try context.save()
                            } catch {
                                print("EVENT INFO -> Error while trying to save This Event Colors to Database: \(error)")
                            }
                        }
                    }
                }
            }
        }
        
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
        guard let iconForDirection = FAType.FAMapSigns.text else { return }
        timeIcon.attributedText = fontAwesomeAttributedString(forString: iconForTime, withColor: .black, andFontSize: 30.0)
        placeIcon.attributedText = fontAwesomeAttributedString(forString: iconForPlace, withColor: .black, andFontSize: 30.0)
        directionIcon.attributedText = fontAwesomeAttributedString(forString: iconForDirection, withColor: Colors.logoRed, andFontSize: 30.0)
        
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
    
    
    // List of segue to be done here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Event Info To Deejay Profile") {
            guard let eventInfoDJcell = sender as? EventInfoDJNameCell else { return }
            guard let _ = eventInfoDJcell.superview as? UICollectionView else { return }
            guard let destination = segue.destination as? DeejayGigsTableViewController else { return }
            guard let thisDJ = eventInfoDJcell.thisDJ else { return }
            destination.artist = thisDJ
            destination.navigationItem.title = thisDJ.name!
        }
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
        //print("Event Info View Collection for Row: \(indexPath.row)")
    }
    
}










