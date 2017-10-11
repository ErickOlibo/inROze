//
//  EventsTableView+NSFetchResultsController.swift
//  InRoZe
//
//  Created by Erick Olibo on 22/09/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData
//import SDWebImage
import Kingfisher

extension EventsViewController
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let eventCell = cell as? EventDeejayCell else { return }
        eventCell.setCollectionViewDataSourceDelegate(eventCell.self, forRow: indexPath.row)
        let event = fetchResultsController.object(at: indexPath)
        eventCell.event = event
        eventCell.selectionStyle = .none
        guard let eventURL = URL(string: event.imageURL!) else { return }
        
        let thisURL = event.imageURL!
        var ending = ""
        if thisURL.lowercased().range(of: "jpg") != nil {
            ending = "JPG"
        } else if thisURL.lowercased().range(of: "png") != nil {
            ending = "PNG"
        } else {
            ending = "//"
        }
        //let imageviewMode = eventCell.eventCover.contentMode
        let eventFrameSize = eventCell.eventCover.frame.size
        let currentRow = indexPath.row
        let screenScale = UIScreen.main.scale
        // resize
        let imageSize = CGSize(width: eventFrameSize.width * screenScale, height: eventFrameSize.height * screenScale)
        
        let processor = ResizingImageProcessor(referenceSize: imageSize, mode: .aspectFill)
//        var processor = ResizingImageProcessor(referenceSize: imageSize, mode: .aspectFill) >> CroppingImageProcessor(size: imageSize)
//        processor = processor.append(another: RoundCornerImageProcessor(cornerRadius: 10 * screenScale))
        
        //print("[\(currentRow)] --> Mode: [\(imageviewMode.rawValue)] || Frame: [\(eventFrameSize)]")
        //, options: [.processor(processor), .cacheSerializer(FormatIndicatedCacheSerializer.png)]
        
        eventCell.eventCover.kf.setImage(with: eventURL, options: [.processor(processor)]) { (image, error, cacheType, imageURL) in
            let fetchImageSize = image?.size ?? CGSize(width: 0, height: 0)
            print("[\(currentRow)] Place: [\(event.location!.name!)] --> Cache: [\(cacheType.hashValue)] --> Size: [\(fetchImageSize)] | Frame: [\(eventFrameSize)] Image Type: [\(ending)]")
//            switch cacheType {
//            case .none:
//                print("[\(currentRow)] --> Just downloaded - Size: [\(fetchImageSize)] | Frame: [\(eventFrameSize)]")
//            case .memory:
//                print("[\(currentRow)] --> Got from memory cache - Size: [\(fetchImageSize)] | Frame: [\(eventFrameSize)]")
//            case .disk:
//                print("[\(currentRow)] --> Got from disk cache - Size: [\(fetchImageSize)] | Frame: [\(eventFrameSize)]")
//            }
        }
        
//        eventCell.eventCover.sd_setImage(with: URL(string: event.imageURL! )) { (image, error, cacheType, imageURL) in
//            if (image != nil) {
//                print("Event Image Size: \(String(describing: image?.size))")
//                //let rndImage = image?.withRenderingMode(.alwaysOriginal)
//                //eventCell.eventCover.image = rndImage
//            }
//        }
        eventCell.eventTimeLocation.attributedText = dateTimeLocationFormatter(with: event)
        eventCell.eventTitle.text = event.name
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventDeejayCell.identifier, for: indexPath) as! EventDeejayCell
        return cell
    }
    
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell pressed at indexPath Row [\(indexPath.row)]")
    }
    
    // SECTION for Height at index path
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let event = fetchResultsController.object(at: indexPath)
        if let performerCount = event.performers?.count, performerCount > 0 {
            return cellHeightDeejays
        } else {
            return cellHeightDefault
        }
    }


    // - Mark - Navigation
    
    // list of segue to be done here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Deejay Gigs List" {
            if let deejayNameCell = sender as? EventDJNameCell {
                if let _ = deejayNameCell.superview as? UICollectionView {
                    if let destination = segue.destination as? DeejayGigsTableViewController {
                        let thisDJ = deejayNameCell.thisDJ!
                        destination.artist = thisDJ
                        destination.navigationItem.title = thisDJ.name!
                    }
                }
            }
        }
    }

   
}

