//
//  Artist.swift
//  InRoZe
//
//  Created by Erick Olibo on 26/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData

public class Artist: NSManagedObject
{
    // Creates or Updates an Artist object with Dictionary
    // Returns a Boolean- > True: for Created | False: for Updated
    class func createOrUpdateArtist(with artistInfo: [String : Any], in context: NSManagedObjectContext) throws -> Bool
    {
        let request: NSFetchRequest<Artist> = Artist.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", artistInfo[DBLabels.artistID] as! String)
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "createOrUpdateArtist -- database inconsistency")
                // update match
                let artistMatch = match[0]
                artistMatch.country = artistInfo[DBLabels.artistCountry] as? String ?? nil
                artistMatch.countryCode = artistInfo[DBLabels.artistCountryCode] as? String ?? nil
                artistMatch.name = artistInfo[DBLabels.artistName] as? String ?? nil
                artistMatch.type = artistInfo[DBLabels.artistType] as? String ?? nil
                artistMatch.dfPicURL = artistInfo[DBLabels.artistDfPicURL] as? String ?? nil
                artistMatch.fbPicURL = artistInfo[DBLabels.artistFbPicURL] as? String ?? nil
                artistMatch.mcPicURL = artistInfo[DBLabels.artistMcPicURL] as? String ?? nil
                artistMatch.dfCoverURL = artistInfo[DBLabels.artistDfCoverURL] as? String ?? nil
                artistMatch.fbCoverURL = artistInfo[DBLabels.artistFbCoverURL] as? String ?? nil
                artistMatch.mcCoverURL = artistInfo[DBLabels.artistMcCoverURL] as? String ?? nil
                
                if let nameMC = artistInfo[DBLabels.artistNameMC] as? String {
                    artistMatch.mcPageURL = UrlFor.mixcloud + nameMC
                } else { artistMatch.mcPageURL = nil }
                
                if let fbPageID = artistInfo[DBLabels.artistFbPageID] as? String {
                    artistMatch.fbPageURL = UrlFor.facebook + fbPageID
                } else { artistMatch.fbPageURL = nil }
                
                return false
            }
        } catch {
            throw error
        }
        
        let artist = Artist(context: context)
        artist.id = artistInfo[DBLabels.artistID] as? String ?? nil
        artist.country = artistInfo[DBLabels.artistCountry] as? String ?? nil
        artist.countryCode = artistInfo[DBLabels.artistCountryCode] as? String ?? nil
        artist.name = artistInfo[DBLabels.artistName] as? String ?? nil
        artist.type = artistInfo[DBLabels.artistType] as? String ?? nil
        artist.dfPicURL = artistInfo[DBLabels.artistDfPicURL] as? String ?? nil
        artist.fbPicURL = artistInfo[DBLabels.artistFbPicURL] as? String ?? nil
        artist.mcPicURL = artistInfo[DBLabels.artistMcPicURL] as? String ?? nil
        artist.dfCoverURL = artistInfo[DBLabels.artistDfCoverURL] as? String ?? nil
        artist.fbCoverURL = artistInfo[DBLabels.artistFbCoverURL] as? String ?? nil
        artist.mcCoverURL = artistInfo[DBLabels.artistMcCoverURL] as? String ?? nil
        artist.isFollowed = false
        
        if let nameMC = artistInfo[DBLabels.artistNameMC] as? String {
            artist.mcPageURL = UrlFor.mixcloud + nameMC
        } else { artist.mcPageURL = nil }
        
        if let fbPageID = artistInfo[DBLabels.artistFbPageID] as? String {
            artist.fbPageURL = UrlFor.facebook + fbPageID
        } else { artist.fbPageURL = nil }
        
        return true
    }

    
    class func findArtistWith(id: String, in context: NSManagedObjectContext) throws -> Artist? {
        let request: NSFetchRequest<Artist> = Artist.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "findArtistWithID -- database inconsistency")
                return match[0]
                
            }
        } catch {
            throw error
        }
        return nil
    }
    
    // new idea on setIsFollowed
    class func currentIsFollowedState(for artistID: String, in context: NSManagedObjectContext) -> Bool? {
        let request: NSFetchRequest<Artist> = Artist.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", artistID)
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "findArtistWithID -- database inconsistency")
                return match[0].isFollowed
            }
        } catch {
            print("[currentIsFollowedState] - Error while Saving Context: \(error)")
        }
        return nil
    }
    
    // new idea changeIsFollowed
    class func changeIsFollowed(for artistID: String, in context: NSManagedObjectContext) -> Bool {
        let request: NSFetchRequest<Artist> = Artist.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", artistID)
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "findArtistWithID -- database inconsistency")
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
    

    class func listOfFollows(in context: NSManagedObjectContext) -> [Artist] {
        var follows = [Artist]()        
        let request: NSFetchRequest<Artist> = Artist.fetchRequest()
        request.predicate = NSPredicate(format: "isFollowed = true")
        do {
            follows = try context.fetch(request)
            
            return follows
        } catch {
            print("[printListOfFollows Artists] - Error while getting Follows list: \(error)")
        }
        return follows
    }
    
    
    class func printListOfFollows(in context: NSManagedObjectContext) {
        var text = "List of DJS: "
        let request: NSFetchRequest<Artist> = Artist.fetchRequest()
        request.predicate = NSPredicate(format: "isFollowed = true")
        do {
           let match = try context.fetch(request)
            if match.count > 0 {
                for dj in match {
                    text += "\(dj.name!) | "
                }
            }
        } catch {
            print("[printListOfFollows] - Error while getting Follows list: \(error)")
            
        }
        print("[printListOfFollows] - \(text)")
        
    }
  
    class func findPerformingEvents(for artist: Artist, in context: NSManagedObjectContext) -> [Event]? {
        let request: NSFetchRequest<Event> = Event.fetchRequest()

        // Add sort Descriptors and Predicate
        let nowTime = NSDate()
        request.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true, selector: nil)]
        request.predicate = NSPredicate(format: "ANY performers.id == %@ AND endTime > %@ AND imageURL != nil AND name != nil AND text != nil", artist.id!, nowTime)
        do {
            let match = try context.fetch(request)
            //print("match for [findPerformingEvents]: \(match.count)")
            if match.count > 0 {
                return match
            }
        } catch {
            print("[findPerformingEvents] - Error while searching for Artist: \(error)")
        }
        return nil
    }
    
    
    class func findPerformingMixtapes(for artist: Artist, in context: NSManagedObjectContext) -> [Mixtape]? {
        let request: NSFetchRequest<Mixtape> = Mixtape.fetchRequest()
        
        // Add sort Descriptors and Predicate
        request.sortDescriptors = [NSSortDescriptor(key: "createdTime", ascending: false, selector: nil)]
        request.predicate = NSPredicate(format: "ANY deejay.id == %@", artist.id!)
        do {
            let match = try context.fetch(request)
            //print("match for [findPerformingEvents]: \(match.count)")
            if match.count > 0 {
                return match
            }
        } catch {
            print("[findPerformingEvents] - Error while searching for Artist: \(error)")
        }
        return nil
    }
    
    
    
    
    
    class func orderedPerformingDeejays(for event: Event, in context: NSManagedObjectContext) -> [Artist]? {
        let request: NSFetchRequest<Artist> = Artist.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: nil)]
        request.predicate = NSPredicate(format: "ANY gigs.id == %@", event.id!)
        do {
            let match = try context.fetch(request)
            
            if match.count > 0 {
               return match
            }
        } catch {
            print("[orderedPerformingDeejays] - Error while ordering performers: \(error)")
        }        
        return nil
    }
    
    
    
    
    
    
    
    
    
    
    
}
