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
                artistMatch.picDefaultURL = artistInfo[DBLabels.artistPicDefaultURL] as? String ?? nil
                //print("Update URL Default: ", artistInfo[DBLabels.artistPicDefaultURL] ?? "NULL")
                artistMatch.picFbURL = artistInfo[DBLabels.artistPicFbURL] as? String ?? nil
                artistMatch.picMixURL = artistInfo[DBLabels.artistPicMixURL] as? String ?? nil
                return false
            }
        } catch {
            throw error
        }
        
        let artist = Artist(context: context)
        artist.country = artistInfo[DBLabels.artistCountry] as? String ?? nil
        artist.countryCode = artistInfo[DBLabels.artistCountryCode] as? String ?? nil
        artist.id = artistInfo[DBLabels.artistID] as? String ?? nil
        artist.name = artistInfo[DBLabels.artistName] as? String ?? nil
        artist.type = artistInfo[DBLabels.artistType] as? String ?? nil
        artist.picDefaultURL = artistInfo[DBLabels.artistPicDefaultURL] as? String ?? nil
        //print("Create URL Default: ", artistInfo[DBLabels.artistPicDefaultURL] ?? "NULL")
        artist.picFbURL = artistInfo[DBLabels.artistPicFbURL] as? String ?? nil
        artist.picMixURL = artistInfo[DBLabels.artistPicMixURL] as? String ?? nil
        artist.isFollowed = false
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
            print("[printListOfFollows] - Error while getting Follows list: \(error)")
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
        request.predicate = NSPredicate(format: "ANY performers.id == %@ AND endTime > %@", artist.id!, nowTime)
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
