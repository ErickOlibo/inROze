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
    @IBOutlet weak var mixProgressView: UIProgressView! //{ didSet { progressBarUI() }}
    @IBOutlet weak var elapsedTime: UILabel!
    @IBOutlet weak var remainingTime: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var skipForwardButton: UIButton!
    @IBOutlet weak var skipBackwardButton: UIButton!
    @IBOutlet weak var deejayName: UILabel!
    @IBOutlet weak var mixtapeName: UILabel!
    
    
    
    // Actions
    @IBAction func touchedPlayPause(_ sender: UIButton) {
        print("touchedPlayPause")
    }
    
    @IBAction func touchedSkipForward(_ sender: UIButton) {
        print("touchedSkipForward")
    }
    
    @IBAction func touchedSkipBackward(_ sender: UIButton) {
        print("touchedSkipBackward")
    }
    
    
    
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
        //tryTimer()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupNavBar() {
        navigationItem.largeTitleDisplayMode = .never
        //navigationController?.navigationBar.prefersLargeTitles = false
    }

    private func progressBarUI() {
        mixProgressView.transform = mixProgressView.transform.scaledBy(x: 1.0, y: 4.0)
        guard let setColors = colors else { return }
        
        // Conditional color
        if (setColors.background.isWhiteColor) {
            elapsedTime.textColor = setColors.background
            remainingTime.textColor = setColors.background
            mixProgressView.progressTintColor = setColors.background
            view.backgroundColor = setColors.secondary
            mixProgressView.trackTintColor = setColors.primary
            mixtapeCover.layer.borderColor = setColors.primary.cgColor
            deejayName.textColor = setColors.background
            mixtapeName.textColor = setColors.background
        } else {
            elapsedTime.textColor = setColors.primary
            remainingTime.textColor = setColors.primary
            mixProgressView.progressTintColor = setColors.primary
            view.backgroundColor = setColors.background
            mixProgressView.trackTintColor = setColors.secondary
            mixtapeCover.layer.borderColor = setColors.secondary.cgColor
            deejayName.textColor = setColors.primary
            mixtapeName.textColor = setColors.primary
        }
        tryTimer()
    }
    
    private func tryTimer () {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer: Timer) in
            self.mixProgressView.setProgress(self.mixProgressView.progress + 0.01, animated: true)
            if self.mixProgressView.progress >= 1 {
                timer.invalidate()
            }
        }
        timer.fire()
    }
    
    private func colorsFromCover() {
        // Get and/or Set colors for this cover after isFollowed set to true
        print("Colors are SET and READY to USE")
        progressBarUI()
        setupMixtapeInfo()
        
        
    }
    
    private func setupMixtapeInfo () {
        guard let mixTitle = mixtape?.name else { return }
        guard let mixDJ = mixtape?.deejay?.name else { return }
        deejayName.text = mixDJ
        mixtapeName.text = mixTitle
        
    }
    
    private func setupMixtapeCover () {
        guard let mix = mixtape else { return }
        guard let coverURL = mixtape?.cover768URL else { return }
        //print("AGAIN IN PLAYER - Thread: [\(Thread.current)]")
        mixtapeCover.layer.masksToBounds = true
        mixtapeCover.layer.cornerRadius = 5.0
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
