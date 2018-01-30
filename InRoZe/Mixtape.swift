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
                mix.haystack = createHaystack(for: mix)
                //print("Update Haystack: \(mix.haystack ?? "NIL")")

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
        // Create haystack
        newMix.haystack = createHaystack(for: newMix)
        //print("Create Haystack: \(newMix.haystack ?? "NIL")")
        return true
    }
    
    
    
    // Create haystack
    class func createHaystack(for mixtape: Mixtape) -> String {
        var haystack = ""
        let sepa = " | "
        if let djname = mixtape.deejay?.name {
            haystack += djname + sepa
        }
        if let mixName = mixtape.name {
            haystack += mixName
        }
        
        guard let tag1 = mixtape.tag1, tag1 != "" else { return haystack}
        haystack +=  sepa + tag1
        guard let tag2 = mixtape.tag2, tag2 != "" else { return haystack}
        haystack +=  sepa + tag2
        guard let tag3 = mixtape.tag3, tag3 != "" else { return haystack}
        haystack +=  sepa + tag3
        guard let tag4 = mixtape.tag4, tag4 != "" else { return haystack}
        haystack +=  sepa + tag4
        guard let tag5 = mixtape.tag5, tag5 != "" else { return haystack}
        haystack +=  sepa + tag5
        
        return haystack
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
    
    // your list for Mixtape view
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
    
    
    // New Release for Mixtape View
    class func newReleases(in context: NSManagedObjectContext) -> [Mixtape] {
        var newMixes = [Mixtape]()
        let nowTime = NSDate()
        let twoWeeksAgo: Double = -14 * 24 * 60 * 60
        let afterThisDate = nowTime.addingTimeInterval(twoWeeksAgo)
        
        let request: NSFetchRequest<Mixtape> = Mixtape.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdTime", ascending: false, selector: nil)]
        request.fetchLimit = 50
        request.predicate = NSPredicate(format: "createdTime > %@", afterThisDate)
        do {
            newMixes = try context.fetch(request)
            return newMixes
        } catch {
            print("[newReleases] - Error while fetching new releases: \(error)")
        }
        return newMixes
    }
    
    
    // Recently Played for Mixtape View
    class func recentlyPlayed(in context: NSManagedObjectContext) -> [Mixtape] {
        var recentlyPlayedMixes = [Mixtape]()
        let nowTime = NSDate()
        let oneMonthAgo: Double = -30 * 24 * 60 * 60
        let afterThisDate = nowTime.addingTimeInterval(oneMonthAgo)
        
        let request: NSFetchRequest<Mixtape> = Mixtape.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "playedTime", ascending: false, selector: nil)]
        request.fetchLimit = 50
        request.predicate = NSPredicate(format: "playedTime != nil AND playedTime > %@", afterThisDate)
        do {
            recentlyPlayedMixes = try context.fetch(request)
            return recentlyPlayedMixes
        } catch {
            print("[recentlyPlayed] - Error while fetching recently played: \(error)")
        }
        return recentlyPlayedMixes
    }
    
    
    
    // SET PLAYED TIME AND DATE HERE from Mixtape ID
    class func setPlayedTime(with id: String, in context: NSManagedObjectContext) -> Bool {
        let request: NSFetchRequest<Mixtape> = Mixtape.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "setPlayedTime - Database inconsistency")
                let mixtape = match[0]
                mixtape.playedTime = Date()
                do {
                    try context.save()
                } catch {
                    print("[setPlayedTime] - Error while Saving Context: \(error)")
                }
                // reload MusicViewController ThreeCells and the CollectionCells inside for the RecnetlyPlayed list
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationFor.userDidChangeRecentlyPlayedList), object: nil)
                return true
            }
        } catch {
            print("[setPlayedTime] - Error while setting played Time - \(error)")
        }
        return false
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
