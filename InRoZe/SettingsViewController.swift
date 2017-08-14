//
//  SettingsViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 25/07/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class SettingsViewController: UIViewController {
    
    // Core Data model container and context
    let context = AppDelegate.viewContext
    let container = AppDelegate.persistentContainer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Settings")
        let context = container.viewContext
        context.perform{
            let events = Event.eventsStartingAfterNow(in: context)
            if events.count == 0 {
                print("Events = 0")
            } else {
                print("Events count: \(events.count)")
                for event in events {
                    if event.name != nil { print("NAME: \(event.name!)") }
                    if event.startTime != nil {
                        print("START: \(event.startTime!)")
                        let newFormat = DateFormatter()
                        newFormat.locale = NSLocale.current
                        newFormat.dateFormat = "MMMM dd yyyy HH:mm"
                        let reverse = newFormat.string(from: event.startTime! as Date)
                        print("******** REVERSE start: \(reverse) *********")
                        if event.location != nil {
                            
                            print("LOCATION: \(event.location!.name!)")
                        }
                    }
                    if event.endTime != nil { print("END: \(event.endTime!)") }
                    if event.updatedTime != nil { print("UPDATED: \(event.updatedTime!)") }
                }
            }
        }
    }

}
