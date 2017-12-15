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
    class func createOrUpdateMixtape(with mixInfo: [String: Any], in context: NSManagedObjectContext) throws -> Bool
    {
        let request: NSFetchRequest<Mixtape> = Mixtape.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", mixInfo[DBLabels.mixID] as! String)
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "createOrUpdateMixtape -- database inconsistency")
                
                // update match with mixtape info
                let mix = match[0]
                mix.coverURL = mixInfo[DBLabels.mixID] as?  String ?? nil
                mix.name = mixInfo[DBLabels.mixID] as?  String ?? nil
                mix.length = mixInfo[DBLabels.mixID] as?  Int16 ?? 0
                
                mix.mixURL = mixInfo[DBLabels.mixID] as?  String ?? nil
                mix.tag1 = mixInfo[DBLabels.mixTag1] as?  String ?? nil
                mix.tag2 = mixInfo[DBLabels.mixTag2] as?  String ?? nil
                mix.tag3 = mixInfo[DBLabels.mixTag3] as?  String ?? nil
                mix.tag4 = mixInfo[DBLabels.mixTag4] as?  String ?? nil
                mix.tag5 = mixInfo[DBLabels.mixTag5] as?  String ?? nil
                mix.isActive = mixInfo[DBLabels.mixIsActive] != nil ? true : false
                
                // Most likely will have issues with date
                mix.createdTime = mixInfo[DBLabels.mixID] as?  Date ?? nil
                
                return false
                
            }
        } catch {
            throw error
        }
        
        let newMix = Mixtape(context: context)
        newMix.coverURL = mixInfo[DBLabels.mixID] as?  String ?? nil
        newMix.name = mixInfo[DBLabels.mixID] as?  String ?? nil
        newMix.length = mixInfo[DBLabels.mixID] as?  Int16 ?? 0
        
        newMix.mixURL = mixInfo[DBLabels.mixID] as?  String ?? nil
        newMix.tag1 = mixInfo[DBLabels.mixTag1] as?  String ?? nil
        newMix.tag2 = mixInfo[DBLabels.mixTag2] as?  String ?? nil
        newMix.tag3 = mixInfo[DBLabels.mixTag3] as?  String ?? nil
        newMix.tag4 = mixInfo[DBLabels.mixTag4] as?  String ?? nil
        newMix.tag5 = mixInfo[DBLabels.mixTag5] as?  String ?? nil
        newMix.isActive = mixInfo[DBLabels.mixIsActive] != nil ? true : false
        
        // Most likely will have issues with date
        newMix.createdTime = mixInfo[DBLabels.mixID] as?  Date ?? nil
        
        
        return true
    }
    

    
    
    
    
    
    
}
