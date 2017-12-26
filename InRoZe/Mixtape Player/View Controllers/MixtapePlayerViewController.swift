//
//  MixtapePlayerViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 25/12/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData

class MixtapePlayerViewController: UIViewController {
    
    // context & container
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    
    
    // properties
    var mixtape: Mixtape?
    var colors: UIImageColors?
//    var colorsInDB: ColorsInHexString? {
//        didSet {
//            print("didSet ColorsInDB: \(colorsInDB?.background ?? "nil") - \(colorsInDB?.detail ?? "nil") - \(colorsInDB?.primary ?? "nil") - \(colorsInDB?.secondary ?? "nil")")
//        }
//    }
    
    // Outlets
    @IBOutlet weak var mixtapeCover: UIImageView!
    
    // Actions
    @IBAction func dismissViewOnSwipeDown(_ sender: UISwipeGestureRecognizer) {
        print ("Swipe down for dismiss recognized")
        //self.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "unwindToDeejayGigs", sender: self)
    }
    
    
    
    // View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .black
        setupNavBar()
        setupMixtapeCover()

        // Do any additional setup after loading the view.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    
    private func colorsForCover() {
        // Get and/or Set colors for this cover after isFollowed set to true
        // CODE HERE
        
    }
    
    
    private func setupMixtapeCover () {
        //guard let mix = mixtape else {return }
        guard let coverURL = mixtape?.cover768URL else { return }
        guard let mixID = mixtape?.id else { return }
        print("AGAIN IN PLAYER - Thread: [\(Thread.current)]")
        mixtapeCover.layer.masksToBounds = true
        mixtapeCover.layer.cornerRadius = 10.0
        mixtapeCover.layer.borderColor = UIColor.black.cgColor
        mixtapeCover.layer.borderWidth = 1.0
        mixtapeCover.kf.setImage(with: URL(string: coverURL), options: [.backgroundDecode], completionHandler: {
            (image, error, cacheType, imageUrl) in
            
            if (image != nil) {
                /////
                if let context = self.container?.viewContext {
                    context.perform {
                        let colorsInDB = Mixtape.getMixtapesColors(with: mixID, in: context)
                        if (colorsInDB != nil) {
                            print("COLORS already in CORE DATA - Get them with getMixtapesColors()")
                            // colors in database,
                            // made additional set up here
                            
                        } else {
                            print(" NOT COLORS in core data - Create them")
                            // colors absent from database. generate them and save the context.
                            image?.getColors(scaleDownSize: CGSize(width: 100, height: 100)){ [weak self] colors in
                                self?.container?.performBackgroundTask { context in
                                    let colorsInHex = colorsToHexString(with: colors)
                                    _ = Mixtape.updateMixtapeImageColors(with: mixID, and: colorsInHex, in: context)
                                    // Save Context
                                    do {
                                        print("are you SAVING??")
                                        try context.save()
                                    } catch {
                                        print("MixtapePlayerViewController -> Error while trying yo save the cover image Colors to Database: \(error)")
                                    }
                                    
                                }
                                
                            }
                        }
                        
                    }
                }
                
//                if (self.colorsInDB != nil) {
//                    print("COLORS already in CORE DATA - Get them with getMixtapesColors()")
//                    // colors in database,
//                    // made additional set up here
//
//                } else {
//                    print(" NOT COLORS in core data - Create them")
//                    // colors absent from database. generate them and save the context.
//                    image?.getColors(scaleDownSize: CGSize(width: 100, height: 100)){ [weak self] colors in
//                        self?.container?.performBackgroundTask { context in
//                            let colorsInHex = colorsToHexString(with: colors)
//                            _ = Mixtape.updateMixtapeImageColors(with: mixID, and: colorsInHex, in: context)
//                            // Save Context
//                            do {
//                                print("are you SAVING??")
//                                try context.save()
//                            } catch {
//                                print("MixtapePlayerViewController -> Error while trying yo save the cover image Colors to Database: \(error)")
//                            }
//
//                        }
//
//                    }
//                }
                
                /////
                
            }
            // set the colors or get Colors from core data
        })
    }
    private func setupNavBar() {
        navigationItem.largeTitleDisplayMode = .never
        //navigationController?.navigationBar.prefersLargeTitles = false
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
