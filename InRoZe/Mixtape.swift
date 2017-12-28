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
                mix.cover320URL = mixInfo[DBLabels.mixC320URL] as?  String ?? nil
                mix.cover640URL = mixInfo[DBLabels.mixC640URL] as?  String ?? nil
                mix.cover768URL = mixInfo[DBLabels.mixC768URL] as?  String ?? nil
                mix.cover1024URL = mixInfo[DBLabels.mixC1024URL] as?  String ?? nil
                mix.name = mixInfo[DBLabels.mixName] as?  String ?? nil
                mix.length = mixInfo[DBLabels.mixLength] as?  String ?? nil
                mix.streamURL = mixInfo[DBLabels.mixStreamURL] as?  String ?? nil
                mix.mixURL = mixInfo[DBLabels.mixURL] as?  String ?? nil
                mix.tag1 = mixInfo[DBLabels.mixTag1] as?  String ?? nil
                mix.tag2 = mixInfo[DBLabels.mixTag2] as?  String ?? nil
                mix.tag3 = mixInfo[DBLabels.mixTag3] as?  String ?? nil
                mix.tag4 = mixInfo[DBLabels.mixTag4] as?  String ?? nil
                mix.tag5 = mixInfo[DBLabels.mixTag5] as?  String ?? nil
                mix.isActive = mixInfo[DBLabels.mixIsActive] as? String != nil ? true : false
                //print("ID: [\(mix.id!)] - MIX ACTIVE: [\(mix.isActive)]")
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
        newMix.cover320URL = mixInfo[DBLabels.mixC320URL] as?  String ?? nil
        newMix.cover640URL = mixInfo[DBLabels.mixC640URL] as?  String ?? nil
        newMix.cover768URL = mixInfo[DBLabels.mixC768URL] as?  String ?? nil
        newMix.cover1024URL = mixInfo[DBLabels.mixC1024URL] as?  String ?? nil
        newMix.name = mixInfo[DBLabels.mixName] as?  String ?? nil
        newMix.length = mixInfo[DBLabels.mixLength] as?  String ?? nil
        newMix.streamURL = mixInfo[DBLabels.mixStreamURL] as?  String ?? nil
        newMix.mixURL = mixInfo[DBLabels.mixURL] as?  String ?? nil
        newMix.tag1 = mixInfo[DBLabels.mixTag1] as?  String ?? nil
        newMix.tag2 = mixInfo[DBLabels.mixTag2] as?  String ?? nil
        newMix.tag3 = mixInfo[DBLabels.mixTag3] as?  String ?? nil
        newMix.tag4 = mixInfo[DBLabels.mixTag4] as?  String ?? nil
        newMix.tag5 = mixInfo[DBLabels.mixTag5] as?  String ?? nil
        newMix.isActive = mixInfo[DBLabels.mixIsActive] as? String != nil ? true : false
        //print("ID: [\(newMix.id!)] - MIX ACTIVE: [\(newMix.isActive)]")
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
    
    
    class func currentIsFollowedState(for mixID: String, in context: NSManagedObjectContext) -> Bool? {
        let request: NSFetchRequest<Mixtape> = Mixtape.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", mixID)
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "currentIsFollowedState -- database inconsistency")
                return match[0].isFollowed
            }
        } catch {
            print("[currentIsFollowedState] - Error while Saving Context: \(error)")
        }
        return nil
    }
    
    
    class func changeIsFollowed(for mixID: String, in context: NSManagedObjectContext) -> Bool {
        let request: NSFetchRequest<Mixtape> = Mixtape.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", mixID)
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "changeIsFollowed -- database inconsistency")
                match[0].isFollowed = !match[0].isFollowed
                
                // save context
                do {
                    try context.save()
                } catch {
                    print("[changeIsFollowed] - Error while Saving Context: \(error)")
                }
                return true
            }
        } catch {
            print("[changeIsFollowed] - Error while Saving Context: \(error)")
        }
        return false
    }
    
    
    class func listOfFollows(in context: NSManagedObjectContext) -> [Mixtape] {
        var follows = [Mixtape]()
        let request: NSFetchRequest<Mixtape> = Mixtape.fetchRequest()
        request.predicate = NSPredicate(format: "isFollowed = true")
        do {
            follows = try context.fetch(request)
            
            return follows
        } catch {
            print("[printListOfFollows Mixtapes] - Error while getting Follows list: \(error)")
        }
        return follows
    }
    
    // update Mixtape cover with ImageColors
    class func updateMixtapeImageColors(with id: String, and colors: ColorsInHexString, in context: NSManagedObjectContext) -> Bool
    {
        let request: NSFetchRequest<Mixtape> = Mixtape.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "MixtapeID is not unique in the database")
                let mix = match[0]
                mix.colorBackground = colors.background
                mix.colorPrimary = colors.primary
                mix.colorSecondary = colors.secondary
                mix.colorDetail = colors.detail
            }
        } catch {
            print("[Mixtape] - UpdateMixtapeImageColors failed with error")
        }
        return true
    }
    
    
    // Get the mixtape colors from the source
    class func getMixtapesColors(with id: String, in context: NSManagedObjectContext) -> ColorsInHexString?
    {
        let request: NSFetchRequest<Mixtape> = Mixtape.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "MixtapeID is not unique in the database")
                let mix = match[0]
                if (mix.colorBackground != nil && mix.colorDetail != nil && mix.colorPrimary != nil && mix.colorSecondary != nil) {
                    return ColorsInHexString(background: mix.colorBackground,
                                             primary: mix.colorPrimary,
                                             secondary: mix.colorSecondary,
                                             detail: mix.colorDetail)
                } else {
                    return nil
                }
            }
        } catch {
            print("[Mixtape] - getMixtapesColors failed with error")
        }
        return nil
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
