//
//  Mixtape.swift
//  InRoZe
//
//  Created by Erick Olibo on 15/12/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData

public class Mixtape: NSManagedObject
{
    // Creates or Updates a Mixtape object
    // return a Boolean -> True: created new entry | False: updated an entry
    class func createOrUpdateMixtape(with mixInfo: [String: Any], in context: NSManagedObjectContext) throws -> Bool?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let request: NSFetchRequest<Mixtape> = Mixtape.fetchRequest()
        //print("Mix_id : \(mixInfo[DBLabels.mixID] as! String) | artist_id : \(mixInfo[DBLabels.artistID] as! String)")
        request.predicate = NSPredicate(format: "id = %@", mixInfo[DBLabels.mixID] as! String)
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "createOrUpdateMixtape -- database inconsistency")
                
                // update match with mixtape info
                let mix = match[0]
                mix.coverURL = mixInfo[DBLabels.mixCoverURL] as?  String ?? nil
                mix.name = mixInfo[DBLabels.mixName] as?  String ?? nil
                mix.length = mixInfo[DBLabels.mixLength] as?  Int16 ?? 0
                
                mix.mixURL = mixInfo[DBLabels.mixURL] as?  String ?? nil
                mix.tag1 = mixInfo[DBLabels.mixTag1] as?  String ?? nil
                mix.tag2 = mixInfo[DBLabels.mixTag2] as?  String ?? nil
                mix.tag3 = mixInfo[DBLabels.mixTag3] as?  String ?? nil
                mix.tag4 = mixInfo[DBLabels.mixTag4] as?  String ?? nil
                mix.tag5 = mixInfo[DBLabels.mixTag5] as?  String ?? nil
                mix.isActive = mixInfo[DBLabels.mixIsActive] != nil ? true : false
                
                if let cTime = mixInfo[DBLabels.mixCreatedTime] as? String,
                    let createdTime = dateFormatter.date(from: cTime) {
                    mix.createdTime = createdTime
                }
                
                // update relationship between mixtape and the Deejay
                guard let artistID = mixInfo[DBLabels.artistID] as? String else { return nil }
                do {
                    if let deejay = try Artist.findArtistWith(id: artistID, in: context) {
                        mix.deejay = deejay
                    }
                } catch {
                    print("[Mixtape] - MIXTAPE to DEEJAY Update Error")
                }

                return false
                
            }
        } catch {
            throw error
        }
        // verify that mixID exist from Server
        guard let mixID = mixInfo[DBLabels.mixID] as? String else { return nil }
        let newMix = Mixtape(context: context)
        newMix.id = mixID
        newMix.coverURL = mixInfo[DBLabels.mixCoverURL] as?  String ?? nil
        newMix.name = mixInfo[DBLabels.mixName] as?  String ?? nil
        newMix.length = mixInfo[DBLabels.mixLength] as?  Int16 ?? 0
        
        newMix.mixURL = mixInfo[DBLabels.mixURL] as?  String ?? nil
        newMix.tag1 = mixInfo[DBLabels.mixTag1] as?  String ?? nil
        newMix.tag2 = mixInfo[DBLabels.mixTag2] as?  String ?? nil
        newMix.tag3 = mixInfo[DBLabels.mixTag3] as?  String ?? nil
        newMix.tag4 = mixInfo[DBLabels.mixTag4] as?  String ?? nil
        newMix.tag5 = mixInfo[DBLabels.mixTag5] as?  String ?? nil
        newMix.isActive = mixInfo[DBLabels.mixIsActive] != nil ? true : false
        newMix.isFollowed = false
        
        if let cTime = mixInfo[DBLabels.mixCreatedTime] as? String,
            let createdTime = dateFormatter.date(from: cTime) {
            newMix.createdTime = createdTime
        } else {
            newMix.createdTime = Date()
        }
        
        // Create relationship between mixtape and the Deejay
        guard let artistID = mixInfo[DBLabels.artistID] as? String else { return nil }
        do {
            if let deejay = try Artist.findArtistWith(id: artistID, in: context) {
                newMix.deejay = deejay
            }
        } catch {
            print("[Mixtape] - MIXTAPE to DEEJAY Creation Error")
        }
        
        
        
        return true
    }
    
    
    // Delete Mixtapes that are isActive = false from the database
    class func deleteNotActiveMixtapes(in context: NSManagedObjectContext) -> Bool
    {
        let request: NSFetchRequest<Mixtape> = Mixtape.fetchRequest()
        request.predicate = NSPredicate(format: "isActive == NO OR isActive == nil")
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                for match in matches {
                    if let id = match.id {
                        print("DELETING Mixtape with ID: [\(id)]")
                    }
                    context.delete(match)
                }
            }
        } catch {
            print("Error while attempting to delete Mixtapes with isActive = false")
            
        }
        return true
    }
    

    
    
    
    
    
    
}
