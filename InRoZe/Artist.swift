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
    
    // Add gigs to Artist
    
}
