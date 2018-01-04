//
//  MixtapePlayerViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 25/12/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class MixtapePlayerViewController: UIViewController {
    
    // context & container
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    

    // properties
    override var prefersStatusBarHidden: Bool { return true }
    private var player: AVPlayer!
    private var duration: CMTime!
    var mixtape: Mixtape?
    var colors: UIImageColors? { didSet { updateUI() }}
    //var isPlaying: Bool = false
    private var colorOne: UIColor = .black // Defines the view background color
    private var colorTwo: UIColor = .black // Defines the text labels, play/pause button color
    private var colorThree: UIColor = .black // Defines the skip back and front button color
    

    
    // Outlets
    @IBOutlet weak var mixtapeCover: UIImageView!
    @IBOutlet weak var mixProgressView: UIProgressView!
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
        playPauseAudio()
    }
    
    @IBAction func touchedSkipForward(_ sender: UIButton) {
        print("touchedSkipForward")
        seekNewCurrentTime(byLookForward: true)
        
    }
    
    @IBAction func touchedSkipBackward(_ sender: UIButton) {
        print("touchedSkipBackward")
        seekNewCurrentTime(byLookForward: false)
    }
    
    
    @IBAction func dismissViewOnSwipeDown(_ sender: UISwipeGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

    // VIEW CONTROLLER LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        // START Spinner and show frontView
        // CODE HERE
        
        
        // Basic UI Setting
        mixProgressView.transform = mixProgressView.transform.scaledBy(x: 1.0, y: 4.0)
        setAudioStreamFromMixCloud()
        setMixtapeCoverUI()
        setMixtapeInfoUI()
        setMixtapeCoverAndColors()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
                //print("DONE SAVING")
            } catch {
                print("MixtapePlayerViewController -> Error while trying yo save the cover image Colors to Database: \(error)")
            }
        }
        // for the moment STOP MUSIC
        player.pause()
    }

  
    
    // METHODS
    private func setAudioStreamFromMixCloud() {

        guard let strURL = mixtape?.streamURL else { return }
        //guard let length = mixtape?.length else { return }
        guard let streamURL = URL(string: strURL) else { return }
        //print("streamURL: \(streamURL)")
        let playerItem = AVPlayerItem(url: streamURL)
        player = AVPlayer(playerItem: playerItem)
        duration = playerItem.asset.duration
        let durationInt = Int(CMTimeGetSeconds(duration))
        

        //print("Duration From server: \(length)")
        
        // TRACK PLAYER PROGRESS -> Not sure it should not be here
        let interval = CMTime(value: 1, timescale: 1)
        player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { (progressTime) in
            let progress = CMTimeGetSeconds(progressTime)
            let totalLength = CMTimeGetSeconds(self.duration)
            let ratio = Float(progress / totalLength)
            //print(" Total: \(totalLength) | current: \(progress) | RATIO: \(ratio)")
            self.mixProgressView.setProgress(ratio, animated: true)
            
            // Update Elapsed and Remaining Label
            let progressSecs = Int(CMTimeGetSeconds(progressTime))
            guard let elapsed = timeDuration(from: String(progressSecs)) else { return }
            self.elapsedTime.text = elapsed

            let leftTime = String(durationInt - progressSecs)
            guard let remaining = timeDuration(from: leftTime) else { return }
            self.remainingTime.text = "-" + remaining
            
            // pause/ Stop when progress is duration
            if (progress >= totalLength) {
                self.player.pause()
            }
        }

    }
    
    
    private func playPauseAudio() {

        if (player.rate != 0) {
            // Already playing So pause Audio
            player.pause()
            updatePlayPauseIcon()
            
        }  else {
            // not playing so Start Audio
            player.play()
            updatePlayPauseIcon()
            
        }
        
    }
    
    private func setMixtapeCoverUI() {
        mixtapeCover.layer.masksToBounds = true
        mixtapeCover.layer.cornerRadius = 5.0
        mixtapeCover.layer.borderColor = UIColor.black.cgColor
        mixtapeCover.layer.borderWidth = 1.0
    }
    
    private func setMixtapeInfoUI() {
        guard let mixTitle = mixtape?.name else { return }
        guard let mixDJ = mixtape?.deejay?.name else { return }
        guard let length = mixtape?.length else { return }
        guard let duration = timeDuration(from: length) else { return }
        guard let startTime = timeDuration(from: "0") else { return }
        
        elapsedTime.text = startTime
        remainingTime.text = "-" + duration
        deejayName.text = mixDJ
        mixtapeName.text = mixTitle
    }
    
    private func setMixtapeCoverAndColors () {
        guard let mix = mixtape else { return }
        guard let coverURL = mixtape?.cover768URL else { return }
        
        mixtapeCover.kf.setImage(with: URL(string: coverURL), options: [.backgroundDecode, .transition(.fade(0.2))], completionHandler: {
            (image, error, cacheType, imageUrl) in
            if (image != nil) {
                if (mix.colorBackground != nil && mix.colorDetail != nil && mix.colorPrimary != nil && mix.colorSecondary != nil) {
                    let colorsDBInHex = ColorsInHexString(background: mix.colorBackground!, primary: mix.colorPrimary!, secondary: mix.colorSecondary!, detail: mix.colorDetail!)
                    self.colors = colorsFromHexString(with: colorsDBInHex)
                } else {
                    //print(" NOT COLORS in core data - Create them")
                    image?.getColors(scaleDownSize: CGSize(width: 100, height: 100)){ [weak self] colors in
                        self?.colors = colors
                    }
                }
            } else {
                // IMAGE = NIL -> Something went wrong with the cover image
                // dismiss the Modal View after displaying message error to user
            }
        })
    }
    

    
    
    private func updateUI () {
        //print("Colors are SET and READY to be USED")
        updatesTheThreeColors()

        updatePlayerNavButtonUI()
        updatePlayerColorsUI()
        updatePlayPauseIcon()
        //tryTimer()
        // STOP Spinner and hide frontView
        
    }
    
    private func updatesTheThreeColors() {
        guard let setColors = colors else { return }
        if (setColors.background.isWhiteColor) {
            colorOne = setColors.secondary
            colorTwo = setColors.background
            colorThree = setColors.primary
        } else {
            colorOne = setColors.background
            colorTwo = setColors.primary
            colorThree = setColors.secondary
        }
    }
    
    
    
    private func updatePlayPauseIcon() {
        playPauseButton.layer.masksToBounds = true
        playPauseButton.layer.cornerRadius = 45.0
        playPauseButton.layer.borderWidth = 4.0
        
        guard let iconPlay = FAType.FAPlay.text else { return }
        guard let iconPause = FAType.FAPause.text else { return }
        let attrPlay = fontAwesomeAttributedString(forString: iconPlay, withColor: colorTwo, andFontSize: 60.0)
        let attrPause = fontAwesomeAttributedString(forString: iconPause, withColor: colorTwo, andFontSize: 55.0)

        if (player.rate != 0) {
            //print("Track is Playing - Show pause icon")
            playPauseButton.contentEdgeInsets.left = 0
            playPauseButton.setAttributedTitle(attrPause, for: .normal)
            playPauseButton.layer.borderColor = colorThree.cgColor
            
        } else {
            //print("Track is Paused - Show play icon")
            
            playPauseButton.contentEdgeInsets.left = 12
            playPauseButton.setAttributedTitle(attrPlay, for: .normal)
            playPauseButton.layer.borderColor = colorTwo.cgColor
        }
    }
    
    private func updatePlayerNavButtonUI() {
        let fontSize = CGFloat(45.0)
        guard let iconSkipBack = FAType.FARotateLeft.text else { return }
        guard let iconSkipFront = FAType.FARotateRight.text else { return }
        let attrSkipBack = fontAwesomeAttributedString(forString: iconSkipBack, withColor: colorThree, andFontSize: fontSize)
        skipBackwardButton.setAttributedTitle(attrSkipBack, for: .normal)
        let attrSkipFront = fontAwesomeAttributedString(forString: iconSkipFront, withColor: colorThree, andFontSize: fontSize)
        skipForwardButton.setAttributedTitle(attrSkipFront, for: .normal)
    }
    
    private func updatePlayerColorsUI () {
        view.backgroundColor = colorOne
        mixtapeCover.layer.borderColor = colorThree.cgColor
        elapsedTime.textColor = colorTwo
        remainingTime.textColor = colorTwo
        mixProgressView.progressTintColor = colorTwo
        mixProgressView.trackTintColor = colorThree
        deejayName.textColor = colorTwo
        mixtapeName.textColor = colorTwo
    }
    

    private func seekNewCurrentTime(byLookForward isForward: Bool) {
        let length = Int64(CMTimeGetSeconds(duration))
        let currentTime = player.currentTime()
        let currentSeconds = Int64(CMTimeGetSeconds(currentTime))
        let fiveMinutes: Int64 = 300
        let zeroTime = Int64(0.0)
        
        
        
        if (isForward) {
            let seekedTime = (currentSeconds + fiveMinutes >= length) ? length : (currentSeconds + fiveMinutes)
            let targetTime = CMTimeMake(seekedTime, 1)
            player.seek(to: targetTime)
            
        } else {
            let seekedTime = (currentSeconds - fiveMinutes <= zeroTime) ? zeroTime : (currentSeconds - fiveMinutes)
            let targetTime = CMTimeMake(seekedTime, 1)
            player.seek(to: targetTime)
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
