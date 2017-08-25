//
//  UICollectionView+NSFetchedResultsController.swift
//  InRoZe
//
//  Created by Erick Olibo on 17/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

//// Core Data model container and context
//private let context = AppDelegate.viewContext
//private let container = AppDelegate.persistentContainer

// MARK: - Extension
extension EventViewController: UICollectionViewDataSource
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = fetchResultsController.sections?[section].numberOfObjects ?? 0
        print("******* COLLECTIONVIEW ITEMS ***** number Of Items: [\(numberOfItems)]")
        return fetchResultsController.sections?[section].numberOfObjects ?? 0
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchResultsController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventCell, for: indexPath) as! EventCollectionViewCell
        // Here I should set the cell
        
        // Clear the reuseable cell for use
        if (cell.coverImage != nil) {
            cell.clear()
        } else {
            print("Cell is NIL")
        }
        
        let event = fetchResultsController.object(at: indexPath)
        
        // Create an empty eventCell
        var eventToCell = EventCell()
        
        //cell.placeHolderPicture.image = UIImage(named: "placeHolderCell")
        //cell.placeHolderPicture.alpha = 1
        cell.backgroundColor = .darkGray
        cell.spinner.startAnimating()
        
        
        //print("[\(indexPath.row)] -> name: \(event.name!) | location: \(event.location!.name!)")
        cell.coverImage.sd_setImage(with: URL(string: event.imageURL! )) { [weak self] (image, error, cacheType, imageURL) in
            
            if (image != nil) {
                
                eventToCell.event = event
                eventToCell.img = image
                
                // Get metric about the picture
                let imgWidthInPoints = image!.size.width
                let imgWidthInPixels = imgWidthInPoints * image!.scale
                let imgHeightInPoints = image!.size.height
                let imgHeightInPixels = imgHeightInPoints * image!.scale
                let ratio = String(format: "%.2f", imgWidthInPixels / imgHeightInPixels)
                 print("[\(indexPath.row)] -> Pixels (W: \(imgWidthInPixels) | H: \(imgHeightInPixels)) -> Ratio (\(ratio)) -> OFFSET (X: \(event.offsetX) | Y: \(event.offsetY))")
                
                //print("***********")
                
                cell.coverImage.image = nil
                
                // conditional colors setting 3 options
                if (event.primary != nil && event.secondary != nil && event.detail != nil && event.background != nil) {
                    // option 1 -> Colors are already in the Database
                    //print("COLORS already in database")
                    let colorsInHex = ColorsInHexString(background: event.background!, primary: event.primary!, secondary: event.secondary!, detail: event.detail!)
                    let colors = colorsFromHexString(with: colorsInHex)
                    
                    eventToCell.colors = colors
                    self!.configureWith(cell: cell, eventCell: eventToCell)
                    
                } else if let colors = self?.colorsEventDictionary[event.id!] {
                    // Option 2 -> Colors are alreadt in EventDictionary
                    //print("COLORS are in the EVENT DICTIONARY")
                    
                    eventToCell.colors = colors
                    self!.configureWith(cell: cell, eventCell: eventToCell)
                    
                    
                }else {
                    image?.getColors(scaleDownSize: CGSize(width: 100, height: 100)){ [weak self] colors in
                        // Save colors to core data
                        //print("COLORS NOT IN DATABASE")
                        
                        eventToCell.colors = colors
                        self!.configureWith(cell: cell, eventCell: eventToCell)
                        
                        // append to Event Dictionarry
                        self?.colorsEventDictionary[event.id!] = colors
                    }
                }
            }
        }
        
        return cell
    }
    
    
    func configureWith(cell : EventCollectionViewCell, eventCell: EventCell) {
        
        // Animator
        let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut)
        cell.coverImage.alpha = 0
        //cell.placeHolderPicture.alpha = 1
        
        let event = eventCell.event!
        let colors = eventCell.colors!
        let image = eventCell.img!
        cell.coverImage.image = image

        
        // try to configure the cell
        cell.cellBackground.backgroundColor = colors.background.withAlphaComponent(0)
        
        // 4 littler Squares (UI)
        cell.background.backgroundColor = colors.detail.withAlphaComponent(0)
        cell.primary.backgroundColor = colors.primary.withAlphaComponent(0)
        cell.secondary.backgroundColor = colors.secondary.withAlphaComponent(0)
        cell.detail.backgroundColor = colors.detail.withAlphaComponent(0)
        
        // footer line and date frame
        cell.footer.backgroundColor = colors.primary.withAlphaComponent(0)
        cell.dateDisplay.backgroundColor = colors.primary.withAlphaComponent(0)
        
        // Set the date format and color
        let splitDate = Date().split(this: event.startTime! as Date)
        let theDate = "\(splitDate.day.uppercased())\n" + "\(splitDate.num)\n" + "\(splitDate.month.uppercased())"
        if colors.primary.isDarkColor {
            cell.date.attributedText = coloredString(theDate, color: .white)
            cell.date.textColor.withAlphaComponent(0)
        } else {
            cell.date.attributedText = coloredString(theDate, color: .black)
            cell.date.textColor.withAlphaComponent(0)
        }
        
        // Set attibuted text for Name and Location
        cell.date.attributedText = coloredString(theDate, color: colors.detail)
        cell.eventName.attributedText = coloredString(event.name!, color: colors.primary)
        cell.eventLocation.attributedText = coloredString(event.location!.name!, color: colors.detail)
        cell.eventName.textColor.withAlphaComponent(0)
        cell.eventLocation.textColor.withAlphaComponent(0)
        cell.backgroundColor = colors.background.withAlphaComponent(0)
        //cell.backgroundColor = UIColor.black.withAlphaComponent(1)
        
        // Create animations
        animator.addAnimations {
            // try to configure the cell
            cell.cellBackground.backgroundColor = colors.background.withAlphaComponent(1)
            cell.backgroundColor = colors.background

            
            
            // Text animations
            cell.date.textColor.withAlphaComponent(1)
            cell.eventName.textColor.withAlphaComponent(1)
            cell.eventLocation.textColor.withAlphaComponent(1)
            
            
            // 4 littler Squares (UI)
            cell.background.backgroundColor = colors.detail.withAlphaComponent(1)
            cell.primary.backgroundColor = colors.primary.withAlphaComponent(1)
            cell.secondary.backgroundColor = colors.secondary.withAlphaComponent(1)
            cell.detail.backgroundColor = colors.detail.withAlphaComponent(1)
            
            // footer line and date frame
            cell.footer.backgroundColor = colors.detail.withAlphaComponent(1)
            //cell.dateDisplay.backgroundColor = colors.primary.withAlphaComponent(1)
            
            //cell.placeHolderPicture.alpha = 0
            
            
            cell.coverImage.layer.borderWidth = 1
            cell.coverImage.layer.cornerRadius = 10
            cell.coverImage.layer.masksToBounds = true
            cell.separator.backgroundColor = colors.primary
            cell.coverImage.layer.borderColor = colors.detail.cgColor
            cell.backgroundColor = colors.background.withAlphaComponent(1)
            cell.coverImage.alpha = 1
            
        }
        
        animator.startAnimation()
        // remove the placeholder stop spinner
        cell.spinner.stopAnimating()
//        cell.placeHolderPicture.image = nil
//        cell.backgroundColor = .clear
//        cell.coverImage.image = image
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // When cell is selected a segue to a detail view can be triggered here
        print("Slected Event: \(indexPath.row)")
    }
    
    
}


extension EventViewController: UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: collectionView.bounds.width * (9 / 16) + cellHeightOffset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: NSInteger) -> CGFloat {
        return 0
    }
}

extension EventViewController: NSFetchedResultsControllerDelegate
{
    // MARK: -
    // MARK: Fetched Results Controller Delegate Methods
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // collectionView should beginUpdates <- works for tableView
        
        print("controllerWillChangeContent")
        
        // Do Something
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // collectionView should endUpdates -> works with tableView
        print("controllerDidChangeContent")
        
        // Do something
        collectionView!.performBatchUpdates({ () -> Void in
            for operation in self.blockOperations {
                operation.start()
            }
        }) { (finished) -> Void  in
            self.blockOperations.removeAll(keepingCapacity: false)
        }
        
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            //print("[Controller Did Change Object] - INSERT: \(newIndexPath!)")
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.insertItems(at: [newIndexPath!])
                    }
                })
            )
        case .delete:
            print("[Controller Did Change Object] - DELETE: \(indexPath!)")
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.deleteItems(at: [indexPath!])
                    }
                })
            )
        case .update:
            //print("[Controller Did Change Object] - UPDATE: \(indexPath!)")
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.reloadItems(at: [indexPath!])
                    }
                })
            )
        case .move:
            //print("[Controller Did Change Object] - MOVE: \(indexPath!)")
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.deleteItems(at: [indexPath!])
                    }
                })
            )
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.insertItems(at: [newIndexPath!])
                    }
                })
            )
        }
    }
  
    
    
}



