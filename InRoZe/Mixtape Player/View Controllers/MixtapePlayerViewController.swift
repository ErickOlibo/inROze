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
import MediaPlayer

class MixtapePlayerViewController: UIViewController {
    
    // context & container
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer

    // properties
    override var prefersStatusBarHidden: Bool { return true }
    public var player: AVPlayer! //{ didSet { print("Player in MusicVC SET: \(player.description)") } }
    public var mixtape: Mixtape?
    public var tabBarVC: Any?

    private var duration: CMTime!
    private var colors: UIImageColors? { didSet { updateUI() }}
    private var colorOne: UIColor = .black // Defines the view background color
    private var colorTwo: UIColor = .black // Defines the text labels, play/pause button color
    private var colorThree: UIColor = .black // Defines the skip back and front button color
    private let timeBeforeDismissPopupBar: Int = 60 // for the number of seconds
    private let seekingTime: Int64 = 60 // Seek time backward and forward


    // Outlets
    @IBOutlet weak var mixcloudIcon: UIImageView!
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
        print("PLAYER VIEW -> touchedPlayPause")
        toggleBetweenPlayPause()
    }
    
    @IBAction func touchedSkipForward(_ sender: UIButton) {
        print("touchedSkipForward")
        seekNewCurrentTime(byLookForward: true, isCommandCenter: false)
    }
    
    @IBAction func touchedSkipBackward(_ sender: UIButton) {
        print("touchedSkipBackward")
        seekNewCurrentTime(byLookForward: false, isCommandCenter: false)
    }
    
    @objc private func miniPlayPauseTapped() {
        print("MINI Player --> PLAY / PAUSE Button tapped")
        toggleBetweenPlayPause()
    }
    

    // VIEW CONTROLLER LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCommandCenterControllers()
        UIApplication.shared.beginReceivingRemoteControlEvents()
        //instantiateAudioSession()
        navigationItem.largeTitleDisplayMode = .never
        mixProgressView.transform = mixProgressView.transform.scaledBy(x: 1.0, y: 4.0)
        registerForNotifications()
        setAudioStreamFromMixCloud()
        setMixtapeCoverUI()
        //player.play()
        pressedPlayerPlay()
        setPlayedTime()
        updatePlayPauseIcons()
        
        setMixtapeInfoUI()
        setMixtapeCoverAndColors()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeRegisterForNotifications()
        guard let colorsDB = colors else { return }
        guard let mixID = mixtape?.id else { return }
        //print("*** [\(mixID)] - [\(player.description)] - WILL DISAPPEAR")
        container?.performBackgroundTask { context in
            let colorsInHex = colorsToHexString(with: colorsDB)
            _ = Mixtape.updateMixtapeImageColors(with: mixID, and: colorsInHex, in: context)
            do {
                try context.save()
            } catch {
                print("MixtapePlayerViewController -> Error while trying yo save the cover image Colors to Database: \(error)")
            }
        }
    }
    

  
    
    // METHODS
    
    
    private func pressedPlayerPlay() {
        player.play()
        updateNowPlayingCenter()
    }
    
    private func setupCommandCenterControllers() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // target Need all to be implemented
        commandCenter.togglePlayPauseCommand.addTarget(self, action: #selector(toggleBetweenPlayPause))
        commandCenter.nextTrackCommand.addTarget(self, action: #selector(toggleThis))
        commandCenter.previousTrackCommand.addTarget(self, action: #selector(toggleThis))
        commandCenter.skipForwardCommand.addTarget(self, action: #selector(seekForward))
        commandCenter.skipBackwardCommand.addTarget(self, action: #selector(seekBackward))
        
        // enable ALL option to see seeking icon and number
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.isEnabled = true
        
        commandCenter.skipForwardCommand.isEnabled = true
        commandCenter.skipBackwardCommand.isEnabled = true
        commandCenter.skipBackwardCommand.preferredIntervals = [60]
        commandCenter.skipForwardCommand.preferredIntervals = [60]

    }
    
    @objc private func seekForward() {
        seekNewCurrentTime(byLookForward: true, isCommandCenter: true)
    }
    
    @objc private func seekBackward() {
        seekNewCurrentTime(byLookForward: false, isCommandCenter: true)
    }
    
    @objc private func toggleThis() {
        print("Here This")
    }
    
    private func newCurrentTimeForCenter(for newTime: CMTime) {
        var currentSongInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
        //print("SongInfo -> PREVIOUS: ", currentSongInfo ?? "nil")
        let current = Double(CMTimeGetSeconds(newTime))
        currentSongInfo![MPNowPlayingInfoPropertyElapsedPlaybackTime] = current
        MPNowPlayingInfoCenter.default().nowPlayingInfo = currentSongInfo
        //print("SongInfo -> NEW INFO: ", currentSongInfo ?? "nil")
    }
    
    private func updateNowPlayingCenter() {
        let playRate: Float = 1.0
        guard let mixtape = mixtape else { return }
        guard let dj = mixtape.deejay?.name else { return }
        guard let mixTitle = mixtape.name else { return }
        guard let imageURL = mixtape.cover768URL else { return }
        guard let mixLength = mixtape.length, let lengthInt = Double(mixLength)  else { return }
        var songDuration = lengthInt
        if let length = player.currentItem?.asset.duration {
            songDuration = Double(CMTimeGetSeconds(length))
        }
        let current = Double(CMTimeGetSeconds(player.currentTime()))
        
        let tempImageView = UIImageView()
        tempImageView.kf.setImage(with: URL(string: imageURL), options: [.backgroundDecode]) {
            (image, error, cachetype, imageUrl) in
            tempImageView.image = nil
            if (image != nil) {
                let artWork = MPMediaItemArtwork.init(boundsSize: image!.size) { (size) -> UIImage in
                    return image!
                }
                let songInfo: Dictionary <String, Any> = [
                    MPMediaItemPropertyTitle: mixTitle,
                    MPMediaItemPropertyArtist: dj,
                    MPMediaItemPropertyArtwork: artWork,
                    MPNowPlayingInfoPropertyElapsedPlaybackTime: current,
                    MPMediaItemPropertyPlaybackDuration: songDuration,
                    MPNowPlayingInfoPropertyPlaybackRate: playRate
                ]
                //print("SongInfo: ", songInfo)
                MPNowPlayingInfoCenter.default().nowPlayingInfo = songInfo
            }
        }

    }
    

    
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(audioRouteChangeListener),
            name: NSNotification.Name.AVAudioSessionRouteChange,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleInterruption),
            name: .AVAudioSessionInterruption,
            object: AVAudioSession.sharedInstance())
    }
    
    
    private func removeRegisterForNotifications() {
        NotificationCenter.default.removeObserver(self, name: .AVAudioSessionRouteChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: .AVAudioSessionInterruption, object: nil)
    }
    
    
    @objc private func handleInterruption(_ notification: Notification) {
        guard let info = notification.userInfo,
            let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSessionInterruptionType(rawValue: typeValue) else { return }
        if type == .began {
            print("Interuption BEGAN")
        } else if type == .ended {
            print("Interuption ENDED")
            
            guard let optionsValue = info[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            
            let options = AVAudioSessionInterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume) {
                //player.play()
                pressedPlayerPlay()
                print("Audio now Should Resume -> ", Thread.current)
            }
            
        }
        
    }
    
    
    private func dismissPlayerAfterPause(inSeconds delay: Int) {
        print("dismissPlayerAfterPause -> Are We HERE")
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            print("BEFORE Are We HERE")
            if self.player.rate == 0 {
                print("INSIDE Are We HERE")
                if let thisTabBarVC = self.tabBarVC as? TabBarViewController {
                    thisTabBarVC.dismissPopupBar(animated: true, completion: nil)
                }
            }
        }
    }

    @objc private func audioRouteChangeListener(_ notification: NSNotification) {
        guard let info = notification.userInfo,
            let reasonVal = info[AVAudioSessionRouteChangeReasonKey] as? UInt,
            let type = AVAudioSessionRouteChangeReason(rawValue: reasonVal) else { return }
        switch type {
        case .newDeviceAvailable:
            DispatchQueue.main.async {
                self.updatePlayPauseIcons()
            }
            print("info -> Headphone JUST plugged IN -> ", Thread.current)
        case .oldDeviceUnavailable:
            player.pause()
            dismissPlayerAfterPause(inSeconds: timeBeforeDismissPopupBar)
            print("OUT - player Rate: ", player.rate)
            DispatchQueue.main.async {
                self.updatePlayPauseIcons()
            }
            print("info -> Headphone JUST plugged OUT -> ", Thread.current)
        default:
            break
        }
    }
    
 
    private func updatePlayPauseIcons() {
        updateIconForMiniPlayer()
        updateIconForPlayerView()
    }
    
    private func updateIconForPlayerView() {
        playPauseButton.layer.masksToBounds = true
        playPauseButton.layer.cornerRadius = 45.0
        playPauseButton.layer.borderWidth = 4.0
        
        guard let iconPlay = FAType.FAPlay.text else { return }
        guard let iconPause = FAType.FAPause.text else { return }
        let attrPlay = fontAwesomeAttributedString(forString: iconPlay, withColor: colorTwo, andFontSize: 60.0)
        let attrPause = fontAwesomeAttributedString(forString: iconPause, withColor: colorTwo, andFontSize: 55.0)
        if (player.rate != 0) {
            playPauseButton.contentEdgeInsets.left = 0
            playPauseButton.setAttributedTitle(attrPause, for: .normal)
            playPauseButton.layer.borderColor = colorThree.cgColor
            
        } else {
            playPauseButton.contentEdgeInsets.left = 12
            playPauseButton.setAttributedTitle(attrPlay, for: .normal)
            playPauseButton.layer.borderColor = colorTwo.cgColor
        }
    }
    
    private func updateIconForMiniPlayer() {
        let pause = UIBarButtonItem(image: UIImage(named: "Pause_mini"), style: .plain, target: self, action: #selector(miniPlayPauseTapped))
        let play = UIBarButtonItem(image: UIImage(named: "Play_mini"), style: .plain, target: self, action: #selector(miniPlayPauseTapped))
        popupItem.leftBarButtonItems = player.rate != 0 ? [pause] : [play]
    }
    

    private func setPlayedTime() {
        guard let mixID = mixtape?.id else { return }
        guard player.rate != 0 else { return }
        container?.performBackgroundTask{ context in
            _ = Mixtape.setPlayedTime(with: mixID, in: context)
        }
    }

    @objc private func toggleBetweenPlayPause() {
        player.rate != 0 ? player.pause() : pressedPlayerPlay()  // player.play()
        if player.rate == 0 { dismissPlayerAfterPause(inSeconds: timeBeforeDismissPopupBar) }
        setPlayedTime()
        updatePlayPauseIcons()
    }
    

    private func setAudioStreamFromMixCloud() {
        guard let strURL = mixtape?.streamURL else { return }
        guard let streamURL = URL(string: strURL) else { return }
        let playerItem = AVPlayerItem(url: streamURL)
        player.replaceCurrentItem(with: playerItem)
        duration = playerItem.asset.duration
        let durationInt = Int(CMTimeGetSeconds(duration))
        
        // TRACK PLAYER PROGRESS -> Not sure it should not be here
        let interval = CMTime(value: 1, timescale: 1)
        player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { (progressTime) in
            let progress = CMTimeGetSeconds(progressTime)
            //print("PROGRESS: ", progress)
            let totalLength = CMTimeGetSeconds(self.duration)
            let ratio = Float(progress / totalLength)
            self.mixProgressView.setProgress(ratio, animated: true)
            self.popupItem.progress = ratio
            
            let progressSecs = Int(CMTimeGetSeconds(progressTime))
            guard let elapsed = timeDuration(from: String(progressSecs)) else { return }
            self.elapsedTime.text = elapsed

            let leftTime = String(durationInt - progressSecs)
            guard let remaining = timeDuration(from: leftTime) else { return }
            self.remainingTime.text = "-" + remaining
            
            if (progress >= totalLength) {
                self.player.pause()
                self.dismissPlayerAfterPause(inSeconds: self.timeBeforeDismissPopupBar)
                self.mixProgressView.setProgress(0.0, animated: true)
                self.popupItem.progress = 0.0
                self.updatePlayPauseIcons()
            }
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
    
    private func updateMiniPlayerUI(image: UIImage) {
        guard let mixTitle = mixtape?.name else { return }
        guard let mixDJ = mixtape?.deejay?.name else { return }
        popupItem.title = mixDJ
        popupItem.subtitle = mixTitle
        popupItem.image = image
        
    }
    
    
    private func setMixtapeCoverAndColors () {
        guard let mix = mixtape else { return }
        guard let coverURL = mixtape?.cover768URL else { return }
        
        mixtapeCover.kf.setImage(with: URL(string: coverURL), options: [.backgroundDecode, .transition(.fade(0.2))], completionHandler: {
            (image, error, cacheType, imageUrl) in
            if (image != nil) {
                self.updateMiniPlayerUI(image: image!)
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
        updatesTheThreeColors()
        updatePlayerNavButtonUI()
        updatePlayerColorsUI()
        updatePlayPauseIcons()
        updateMixcloudIconColor()
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
    
    private func updateMixcloudIconColor() {
        let imageName = colorOne.isDarkColor ? "MixcloudWhite" : "MixcloudBlack"
        mixcloudIcon.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
    }

    private func seekNewCurrentTime(byLookForward isForward: Bool, isCommandCenter: Bool) {
        let length = Int64(CMTimeGetSeconds(duration))
        let currentTime = player.currentTime()
        let currentSeconds = Int64(CMTimeGetSeconds(currentTime))
        let zeroTime = Int64(0.0)
        var newPlayPosition = CMTime()
        if (isForward) {
            let seekedTime = (currentSeconds + seekingTime >= length) ? length : (currentSeconds + seekingTime)
            let targetTime = CMTimeMake(seekedTime, 1)
            player.seek(to: targetTime)
            newPlayPosition = targetTime
            
        } else {
            let seekedTime = (currentSeconds - seekingTime <= zeroTime) ? zeroTime : (currentSeconds - seekingTime)
            let targetTime = CMTimeMake(seekedTime, 1)
            player.seek(to: targetTime)
            newPlayPosition = targetTime
        }
        
        if (isCommandCenter) {
            newCurrentTimeForCenter(for: newPlayPosition)
        }
        
    }
    

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "MusicPlayer To Mixcloud Profile") {
            guard let destination = segue.destination as? AboutViewController else { return }
            guard let mcURL = mixtape?.deejay?.mcPageURL else { return }
            destination.aboutURL = URL(string: mcURL)
            destination.navigationItem.title = "Mixcloud Page"
            
            
        }
    }
 

}





