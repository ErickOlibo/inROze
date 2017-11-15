//
//  EventInfoViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 14/11/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData

class EventInfoViewController: UIViewController {
    
    // Core Data model container and context
    //var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    
    
    // OUtlets
    @IBOutlet weak var eventCover: UIImageView!
    
    //@IBOutlet weak var eventDesc: UILabel!
    @IBOutlet weak var eventText: UITextView!
    
    // properties
    var event: Event? //{ didSet { updateUI() } }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .lightGray
        print("Name: \(event?.name ?? "NO NAME")")
        self.navigationController?.navigationBar.tintColor = Colors.logoRed
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Event Info View Controller")
        updateUI()
    }
    
    private func updateUI() {
        guard let thisEvent = event else { return }
//        let name = thisEvent.name ?? ""
//        let place = thisEvent.location?.name ?? ""
//        print("URL [\(thisEvent.imageURL ?? "No URL")]")
//        print("Place: \(place) || Name: \(name)")
//        print("Details [\(thisEvent.detail ?? "No Details")]")
        guard let imageURL = thisEvent.imageURL else { return }
        guard let eventDesc = thisEvent.text else { return }
        eventText.text = eventDesc
        eventCover.kf.setImage(with: URL(string: imageURL), options: [.backgroundDecode])
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
