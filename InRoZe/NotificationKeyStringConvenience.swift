//
//  NotificationKeyStringConvenience.swift
//  InRoZe
//
//  Created by Erick Olibo on 10/08/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import Foundation

/* Contains the conveniences structs for all app notification
 * Keeping track of all radio stations per se that are broadcasting
 */

// Notification center channel names
public struct NotificationFor {
    static let eventIDsDidUpdate = "eventIDsDidUpdate"
    static let coreDataDidUpdate = "coreDataDidUpdate"
    static let serverRequestDoneUpdating = "serverRequestDoneUpdating"
    static let initialLoginRequestIsDone = "initialLoginRequestIsDone"
    static let eventDescriptionRecieved = "eventDescriptionRecieved"
    static let playerDidChangeFollowStatus = "playerDidChangeFollowStatus"
    static let userDidChangeRecentlyPlayedList = "userDidChangeRecentlyPlayedList"
    static let dismissCurrentMixtapeVC = "dismissCurrentMixtapeVC"
}
