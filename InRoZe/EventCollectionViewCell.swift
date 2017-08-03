//
//  EventCollectionViewCell.swift
//  InRoZe
//
//  Created by Erick Olibo on 25/07/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    

    // The FacebookEvent struct
    var eventCell: FBEvent! {
        didSet {
            //clear()
            placeHolder(isTrue: true)
            spinner.startAnimating()
            
            if eventCell.colors != nil {
//                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
//                    self?.update()
//                }
                update()
            }
        }
    }
    
    // Creates outlets and an action for the bookmark icon
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var placeHolderPicture: UIImageView!
    
    @IBOutlet weak var cellBackground: UIView!

    @IBOutlet weak var coverImage: UIImageView!

    @IBOutlet weak var eventName: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var footer: UIView!
    
    @IBOutlet weak var eventLocation: UILabel!
    
    @IBOutlet weak var dateDisplay: UIView! {
        didSet {
            dateDisplay.layer.cornerRadius = 10

        }
    }
    
    // OUTLETS to test he UIImageColor class
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var primary: UIView!
    @IBOutlet weak var secondary: UIView!
    @IBOutlet weak var detail: UIView!

    private func update() {
        cellBackground.backgroundColor = eventCell.colors!.background
        coverImage.image = UIImage(named: eventCell.cover)
        eventName.attributedText = coloredString(eventCell.name, color: (eventCell.colors!.primary))
        let theDay = "\(eventCell.date.day.uppercased())\n" + "\(eventCell.date.num)\n" + "\(eventCell.date.month.uppercased())"
        if eventCell.colors!.primary.isDarkColor {
            date.attributedText = coloredString(theDay, color: .white)
        } else {
            date.attributedText = coloredString(theDay, color: .black)
        }
        
        footer.backgroundColor = eventCell.colors!.primary
        eventLocation.attributedText = coloredString(eventCell.location, color: eventCell.colors!.detail)
        dateDisplay.backgroundColor = eventCell.colors!.primary
        
        // 4 little Squares
        background.backgroundColor = eventCell.colors!.detail
        primary.backgroundColor = eventCell.colors!.primary
        secondary.backgroundColor = eventCell.colors!.secondary
        detail.backgroundColor = eventCell.colors!.detail
        placeHolder(isTrue: false)
        spinner.stopAnimating()
        
    }
    
    public func clear () {
        cellBackground.backgroundColor = .clear
        coverImage.image = nil
        eventName.text = nil
        date.text = nil
        footer.backgroundColor = .clear
        eventLocation.text = nil
        dateDisplay.backgroundColor = .clear
        background.backgroundColor = .clear
        primary.backgroundColor = .clear
        secondary.backgroundColor = .clear
        detail.backgroundColor = .clear
    }

    public func placeHolder (isTrue: Bool) {
        if isTrue {
            placeHolderPicture.image = UIImage(named: "placeHolderCell")
            backgroundColor = .lightGray
        } else {
            placeHolderPicture.image = nil
            backgroundColor = .clear
        }
        
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        clear()
//        placeHolder(isTrue: true)
//    }
    
}
