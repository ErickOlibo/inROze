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

        cell.placeHolderPicture.image = UIImage(named: "placeHolderCell")
        cell.backgroundColor = .darkGray
        cell.spinner.startAnimating()
        
        //var cellImageView = UIImageView()
        
        cell.coverImage.sd_setImage(with: URL(string: event.imageURL! )) { (image, error, cacheType, imageURL) in
            
            // is the shit here
            if (image != nil) {
                cell.coverImage.image = nil

                // conditional colors setting
                if (event.primary != nil && event.secondary != nil && event.detail != nil && event.background != nil) {
                    print("COLORS already in database")
                    let colorsInHex = ColorsInHexString(background: event.background!, primary: event.primary!, secondary: event.secondary!, detail: event.detail!)
                    let colors = colorsFromHexString(with: colorsInHex)
                    
                    cell.cellBackground.backgroundColor = colors.background
                    
                    // 4 littler Squares (UI)
                    cell.background.backgroundColor = colors.detail
                    cell.primary.backgroundColor = colors.primary
                    cell.secondary.backgroundColor = colors.secondary
                    cell.detail.backgroundColor = colors.detail
                    
                    // footer line and date frame
                    cell.footer.backgroundColor = colors.primary
                    cell.dateDisplay.backgroundColor = colors.primary
                    
                    // Set the date format and color
                    let splitDate = Date().split(this: event.startTime! as Date)
                    let theDate = "\(splitDate.day.uppercased())\n" + "\(splitDate.num)\n" + "\(splitDate.month.uppercased())"
                    if colors.primary.isDarkColor {
                        cell.date.attributedText = coloredString(theDate, color: .white)
                    } else {
                        cell.date.attributedText = coloredString(theDate, color: .black)
                    }
                    
                    // Set attibuted text for Name and Location
                    cell.eventName.attributedText = coloredString(event.name!, color: colors.primary)
                    cell.eventLocation.attributedText = coloredString(event.location!.name!, color: colors.detail)
                    
                    // remove the placeholder stop spinner
                    cell.spinner.stopAnimating()
                    cell.placeHolderPicture.image = nil
                    cell.backgroundColor = .clear
                    cell.coverImage.image = image
                    
                    
                } else {
                    image?.getColors(scaleDownSize: CGSize(width: 100, height: 100)){ [weak self] colors in
                        // Save colors to core data
                        print("COLORS NOT IN DATABASE")
                        if let context = self?.container.viewContext {
                            print("In  a SELF optional")
                            context.perform {
                                let colorsInHex = colorsToHexString(with: colors)
                                _ = Event.updateEventImageColors(with: event.id!, and: colorsInHex, in: context)
                                
                                // Save context
                                do {
                                    try context.save()
                                } catch {
                                    print("CELL -> Error trying to save colors to database: \(error)")
                                }
                            }
                        }
                        
                        // the cell background
                        cell.cellBackground.backgroundColor = colors.background
                        
                        // 4 littler Squares (UI)
                        cell.background.backgroundColor = colors.detail
                        cell.primary.backgroundColor = colors.primary
                        cell.secondary.backgroundColor = colors.secondary
                        cell.detail.backgroundColor = colors.detail
                        
                        // footer line and date frame
                        cell.footer.backgroundColor = colors.primary
                        cell.dateDisplay.backgroundColor = colors.primary
                        
                        // Set the date format and color
                        let splitDate = Date().split(this: event.startTime! as Date)
                        let theDate = "\(splitDate.day.uppercased())\n" + "\(splitDate.num)\n" + "\(splitDate.month.uppercased())"
                        if colors.primary.isDarkColor {
                            cell.date.attributedText = coloredString(theDate, color: .white)
                        } else {
                            cell.date.attributedText = coloredString(theDate, color: .black)
                        }
                        
                        // Set attibuted text for Name and Location
                        cell.eventName.attributedText = coloredString(event.name!, color: colors.primary)
                        cell.eventLocation.attributedText = coloredString(event.location!.name!, color: colors.detail)
                        
                        
                        
                        // remove the placeholder stop spinner
                        cell.spinner.stopAnimating()
                        cell.placeHolderPicture.image = nil
                        cell.backgroundColor = .clear
                        cell.coverImage.image = image
                    }
                }
                
   
            }
        }
        
        
        
        
        
        return cell
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



