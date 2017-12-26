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
    var colors: UIImageColors? { didSet { colorsFromCover() }}

    
    // Outlets
    @IBOutlet weak var mixtapeCover: UIImageView!
    
    // Actions
    @IBAction func dismissViewOnSwipeDown(_ sender: UISwipeGestureRecognizer) {
        //print ("Swipe down for dismiss recognized")
        self.dismiss(animated: true, completion: nil)

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
    
    private func setupNavBar() {
        navigationItem.largeTitleDisplayMode = .never
        //navigationController?.navigationBar.prefersLargeTitles = false
    }

    
    private func colorsFromCover() {
        // Get and/or Set colors for this cover after isFollowed set to true
        // CODE HERE
        print("Colors are SET and READY to USE")
        
    }
    
    
    private func setupMixtapeCover () {
        guard let mix = mixtape else {return }
        guard let coverURL = mixtape?.cover768URL else { return }
        //print("AGAIN IN PLAYER - Thread: [\(Thread.current)]")
        mixtapeCover.layer.masksToBounds = true
        mixtapeCover.layer.cornerRadius = 10.0
        mixtapeCover.layer.borderColor = UIColor.black.cgColor
        mixtapeCover.layer.borderWidth = 1.0
        mixtapeCover.kf.setImage(with: URL(string: coverURL), options: [.backgroundDecode], completionHandler: {
            (image, error, cacheType, imageUrl) in
            
            if (image != nil) {
                if (mix.colorBackground != nil && mix.colorDetail != nil && mix.colorPrimary != nil && mix.colorSecondary != nil) {
                    //print("COLORS already in CORE DATA - Get them with getMixtapesColors()")
                    // made additional set up here
                    let colorsDBInHex = ColorsInHexString(background: mix.colorBackground!, primary: mix.colorPrimary!, secondary: mix.colorSecondary!, detail: mix.colorDetail!)
                    self.colors = colorsFromHexString(with: colorsDBInHex)

                } else {
                    //print(" NOT COLORS in core data - Create them")
                    image?.getColors(scaleDownSize: CGSize(width: 100, height: 100)){ [weak self] colors in
                        self?.colors = colors
                    }
                }
            }
        })
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let colorsDB = colors else { return }
        guard let mixID = mixtape?.id else { return }
        container?.performBackgroundTask { context in
            let colorsInHex = colorsToHexString(with: colorsDB)
            _ = Mixtape.updateMixtapeImageColors(with: mixID, and: colorsInHex, in: context)
            do {
                try context.save()
                print("DONE SAVING")
            } catch {
                print("MixtapePlayerViewController -> Error while trying yo save the cover image Colors to Database: \(error)")
            }
            
        }
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
