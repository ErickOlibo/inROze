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
    // Finds or creates an entry for a certain Artist ID
    // Unique attribute is ID
    class func findOrCreateArtist(with artistInfo: [String : String], in context: NSManagedObjectContext) throws -> Artist
    {
        let request: NSFetchRequest<Artist> = Artist.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", artistInfo[DBLabels.artistID]!)
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "findOrCreateArtist -- database inconsistency")
                // update match
                let artistMatch = match[0]
                artistMatch.country = artistInfo[DBLabels.artistCountry]
                artistMatch.countryCode = artistInfo[DBLabels.artistCountryCode]
                artistMatch.name = artistInfo[DBLabels.artistName]
                artistMatch.type = artistInfo[DBLabels.artistType]
                return artistMatch
            }
        } catch {
            throw error
        }
        
        let artist = Artist(context: context)
        artist.country = artistInfo[DBLabels.artistCountry]
        artist.countryCode = artistInfo[DBLabels.artistCountryCode]
        artist.id = artistInfo[DBLabels.artistID]
        artist.name = artistInfo[DBLabels.artistName]
        artist.type = artistInfo[DBLabels.artistType]
        return artist
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

        // Add sor Descriptors and Predicate
        request.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true, selector: nil)]
        request.predicate = NSPredicate(format: "ANY performers.id == %@", artist.id!)
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
