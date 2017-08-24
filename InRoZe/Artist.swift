//
//  Artist.swift
//  InRoZe
//
//  Created by Erick Olibo on 23/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData

public class Artist: NSManagedObject
{
    // define particular functions for the coreData class
    // insert or update Artist info from server
    class func insertOrUpdateArtist(with artistDict: [String : String], in context: NSManagedObjectContext) throws -> Artist
    {
        let request: NSFetchRequest<Artist> = Artist.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", artistDict[DBLabels.artistID]!)
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "findOrInsertArtistID -- database inconsistency")
                
                //update values
                let artist = match[0]
                artist.country = artistDict[DBLabels.artistCountry]
                artist.name = artistDict[DBLabels.artistName]
                artist.type = artistDict[DBLabels.artistType]
                
                return artist
            }
        } catch {
            throw error
        }
        
        // insert new Artist
        let newArtist = Artist(context: context)
        newArtist.country = artistDict[DBLabels.artistCountry]
        newArtist.id = artistDict[DBLabels.artistID]
        newArtist.name = artistDict[DBLabels.artistName]
        newArtist.type = artistDict[DBLabels.artistType]
        
        return newArtist
    }
    
    
    // Sets the followed status of an artist
    class func setFollowedStatus(for artistID: String, to status: Bool, in context: NSManagedObjectContext) throws -> Bool
    {
        let request: NSFetchRequest<Artist> = Artist.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", artistID)
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "setFollowedStatus -- database inconsistency")
                //update status
                match[0].isFollowed = status
                return true
            }
        } catch {
            throw error
        }
        return false
    }
    
    
    // finds if an artist is in the database and returns it
    class func findArtist(with id: String, in context: NSManagedObjectContext) throws -> Artist
    {
        var artist = Artist()
        let request: NSFetchRequest<Artist> = Artist.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "findOrInsertArtistID -- database inconsistency")
                artist = match[0]
                return artist
            }
        } catch {
            throw error
        }
        return artist
    }
    
    // find artist performing at an event
    class func findArtistPerformingAt(this eventID: String, in context: NSManagedObjectContext) throws -> [Artist]
    {
        var artists = [Artist]()
        let request: NSFetchRequest<Artist> = Artist.fetchRequest()
        request.predicate = NSPredicate(format: "events.id = %@", eventID)
        do {
            let match = try context.fetch(request)
            if (match.count > 0) {
                for artist in match {
                    artists.append(artist)
                }
            }
        } catch {
            throw error
        }
        
        
        return artists
    }
    
    /*
    // insert of update artists performing at an event
    class func insertOrUpdatePerformerWith(with artistId: String, in context: NSManagedObjectContext) throws -> Artist
    {
        let artist = Artist()
        
        
        
        return artist
    }
    */
    
}
















