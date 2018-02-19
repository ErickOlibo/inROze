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
    public var tabBarVC: TabBarViewController!

    private var duration: CMTime!
    private var colors: UIImageColors? { didSet { updateUI() }}
    private var colorOne: UIColor = .black // Defines the view background color
    private var colorTwo: UIColor = .black // Defines the text labels, play/pause button color
    private var colorThree: UIColor = .black // Defines the skip back and front button color
    private let seekingTime: Int64 = 60 // Seek time backward and forward




    // Outlets
    
    @IBOutlet weak var musicSlider: UISlider!
    @IBOutlet weak var isFollowButton: UIButton!
    @IBOutlet weak var mixcloudButton: UIButton!
    //@IBOutlet weak var mixcloudIcon: UIImageView!
    @IBOutlet weak var mixtapeCover: UIImageView!
    @IBOutlet weak var mixProgressView: UIProgressView!
    @IBOutlet weak var elapsedTime: UILabel!
    @IBOutlet weak var remainingTime: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var skipForwardButton: UIButton!
    @IBOutlet weak var skipBackwardButton: UIButton!
    @IBOutlet weak var deejayName: UILabel!
    @IBOutlet weak var mixtapeName: UILabel!
    @IBOutlet weak var sixtyLess: UILabel!
    @IBOutlet weak var sixtyMore: UILabel!
    
    

    // Actions
    @IBAction func touchInsideSlider(_ sender: UISlider) {
        print("Touch inside Slider")
    }
    
    @IBAction func touchOutsideSlider(_ sender: UISlider) {
        print("Touch Outside Slider")
    }
    
    
    
    @IBAction func changedMusicSliderPosition(_ sender: UISlider) {
        //print("Sender Value: ", sender.value)
        
        if let duration = player.currentItem?.duration {
            player.pause()
            let songLength = CMTimeGetSeconds(duration)
            let newValue = Float64(musicSlider.value) * songLength
            // Set the eleapsedTime and remainingTime
            let progressSecs = Int(newValue)
            let remainSecs = Int(songLength) - progressSecs
            
            //print("Prog / Remain: [\(progressSecs) / \(remainSecs)]")
            guard let remaining = timeDuration(from: String(remainSecs)) else { return }
            guard let elapsed = timeDuration(from: String(progressSecs)) else { return }
            elapsedTime.text = elapsed
            remainingTime.text = "-" + remaining
            
            
            let seekTime = CMTime(value: Int64(newValue), timescale: 1)
            player.seek(to: seekTime, completionHandler: { [weak self] (completedSeek) in
                //do somthing on completion
                self?.player.play()
                self?.updateNowPlayingCenter()
            })
        }
    }
    
    
    
    
    @IBAction func pressedFollowMixtape(_ sender: UIButton) {
        pressedFollowedMix()
    }
    
    @IBAction func touchedPlayPause(_ sender: UIButton) {
        //print("PLAYER VIEW -> touchedPlayPause")
        toggleBetweenPlayPause()
    }
    
    @IBAction func touchedSkipForward(_ sender: UIButton) {
        //print("touchedSkipForward")
        seekNewCurrentTime(byLookForward: true, isCommandCenter: false)
    }
    
    @IBAction func touchedSkipBackward(_ sender: UIButton) {
        //print("touchedSkipBackward")
        seekNewCurrentTime(byLookForward: false, isCommandCenter: false)
    }
    
    @objc private func miniPlayPauseTapped() {
        //print("MINI Player --> PLAY / PAUSE Button tapped")
        toggleBetweenPlayPause()
    }
    

    // VIEW CONTROLLER LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("MIXTAPE PLAYER VIEW DID LOAD")
        setupCommandCenterControllers()
        UIApplication.shared.beginReceivingRemoteControlEvents()
        navigationItem.largeTitleDisplayMode = .never
        //mixProgressView.transform = mixProgressView.transform.scaledBy(x: 1.0, y: 4.0)
        registerForNotifications()
        setAudioStreamFromMixCloud()
        setMixtapeCoverUI()
        pressedPlayerPlay()
        setPlayedTime()
        updatePlayPauseIcons()
        setMixtapeInfoUI()
        setMixtapeCoverAndColors()
        popBarExtraSetup()
        //setMusicSlider()
        //getSeekButtonFrameSize()
        setGestureSlider()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updatedIsFollowedMix()
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //removeRegisterForNotifications()
        guard let colorsDB = colors else { return }
        guard let mixID = mixtape?.id else { return }
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

    private func setGestureSlider() {
        musicSlider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)

    }
    
    @objc private func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                print("Slider Began sliding - Drag")
                
            case .moved:
                print("Slider is Moving - Dragging")
                
            case .ended:
                print("Slider Ended sliding - End Drag")
                
            default:
                break
            }
        }
    }
    
    
    
    
    
    @objc private func handleLong(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            print("LONG BACKWARD BEGAN -> Time [\(Date().timeIntervalSince1970)]")

        }
        if recognizer.state == .changed {
            print("LONG BACKWARD CHANGED")
            
        }
        if recognizer.state == .ended {
            print("LONG BACKWARD ENDED -> Time [\(Date().timeIntervalSince1970)]")

        }
    }
    
    
    
//    private func setMusicSlider() {
//        let thumbHigh = UIImage(named: "sliderThumbHigh")
//        let thumbNorm = UIImage(named: "sliderThumbNorm")
//        musicSlider.setThumbImage(thumbNorm, for: .normal)
//        musicSlider.setThumbImage(thumbHigh, for: .highlighted)
//        //musicSlider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
//    }

//    @objc private func handleSliderChange() {
//        print("Handle Change: ", musicSlider.value)
//    }
    
    
    
    
    @objc private func pressedFollowedMix() {
        //print("Pressed FollowedMix")
        guard let id = mixtape?.id else { return }
        if let context = container?.viewContext {
            context.perform {
                if let state = Mixtape.currentIsFollowedState(for: id, in: context) {
                    self.mixtape!.isFollowed = !state
                    self.updatedIsFollowedMix()
                    self.changeState()
                }
            }
        }
    }
    
    private func updatedIsFollowedMix() {
        //print("updatedIsFollowedMix")
        let followColor = colorOne.isDarkColor ? UIColor.white : UIColor.black
        
        guard let following = mixtape?.isFollowed else { return }
        guard let iconAdded = FAType.FACheck.text else { return }
        guard let iconAdd = FAType.FAPlus.text else { return }
        let attrAdd = fontAwesomeAttributedString(forString: iconAdd, withColor: followColor, andFontSize: 20)
        let attrAdded = fontAwesomeAttributedString(forString: iconAdded, withColor: followColor, andFontSize: 20)
        let attributeOne = [ NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Bold", size: 20.0)! ]
        let add = NSAttributedString(string: " Add", attributes: attributeOne)
        let added = NSAttributedString(string: " Added", attributes: attributeOne)
        let combiAdd  = NSMutableAttributedString()
        let combiAdded  = NSMutableAttributedString()
        combiAdd.append(attrAdd)
        combiAdd.append(color(attributedString: add, color: followColor))
        combiAdded.append(attrAdded)
        combiAdded.append(color(attributedString: added, color: followColor))
        let titleIsFollow = following ? combiAdded : combiAdd
        isFollowButton.setAttributedTitle(titleIsFollow, for: .normal)
    }
    
    
    private func changeState() {
        guard let id = mixtape?.id else { return }
        container?.performBackgroundTask{ context in
            _ = Mixtape.changeIsFollowed(for: id, in: context)
            
            // reload DJ profile and Music your list on isFollowed status change
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationFor.playerDidChangeFollowStatus), object: nil)
        }
    }
    
    
    
    private func popBarExtraSetup() {
        popupPresentationContainer?.popupBar.progressViewStyle = .bottom
        popupPresentationContainer?.popupBar.tintColor = Colors.logoRed
    }
    
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
    private func removeCommandCenterControllers() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // target Need all to be implemented
        commandCenter.togglePlayPauseCommand.removeTarget(self, action: #selector(toggleBetweenPlayPause))
        commandCenter.nextTrackCommand.removeTarget(self, action: #selector(toggleThis))
        commandCenter.previousTrackCommand.removeTarget(self, action: #selector(toggleThis))
        commandCenter.skipForwardCommand.removeTarget(self, action: #selector(seekForward))
        commandCenter.skipBackwardCommand.removeTarget(self, action: #selector(seekBackward))
        
        // enable ALL option to see seeking icon and number
        commandCenter.togglePlayPauseCommand.isEnabled = false
        commandCenter.nextTrackCommand.isEnabled = false
        commandCenter.previousTrackCommand.isEnabled = false
        
        commandCenter.skipForwardCommand.isEnabled = false
        commandCenter.skipBackwardCommand.isEnabled = false
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
        //print("Here This")
    }
    
    private func newCurrentTimeForCenter(for newTime: CMTime) {
        var currentSongInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
        let current = Double(CMTimeGetSeconds(newTime))
        currentSongInfo![MPNowPlayingInfoPropertyElapsedPlaybackTime] = current
        MPNowPlayingInfoCenter.default().nowPlayingInfo = currentSongInfo
    }
    
    private func updateNowPlayingCenter() {
        let playRate: Float = 1.0
        guard let mixtape = mixtape else { return }
        guard let dj = mixtape.deejay?.name else { return }
        guard let mixTitle = mixtape.name else { return }
        guard let imageURL = mixtape.cover320URL else { return }
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
        NotificationCenter.default.addObserver(self, selector: #selector(noticeToDismiss), name: NSNotification.Name(rawValue: NotificationFor.dismissCurrentMixtapeVC), object: nil)
    }
    
    
    private func removeRegisterForNotifications() {
        NotificationCenter.default.removeObserver(self, name: .AVAudioSessionRouteChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: .AVAudioSessionInterruption, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationFor.dismissCurrentMixtapeVC), object: nil)
    }
    
    
    @objc private func noticeToDismiss() {
        removeRegisterForNotifications()
        removeCommandCenterControllers()
        player.pause()
        player.removeTimeObserver(tabBarVC.playerObserverToken)
        //self.dismissPopupBar(animated: true, completion: nil)
    }
    
    
    @objc private func handleInterruption(_ notification: Notification) {
        guard let info = notification.userInfo,
            let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSessionInterruptionType(rawValue: typeValue) else { return }
        if type == .began {
            //print("Interuption BEGAN")
        } else if type == .ended {
            //print("Interuption ENDED")
            guard let optionsValue = info[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            let options = AVAudioSessionInterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume) {
                pressedPlayerPlay()
                //print("Audio now Should Resume -> ", Thread.current)
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
        case .oldDeviceUnavailable:
            player.pause()
            DispatchQueue.main.async {
                self.updatePlayPauseIcons()
            }
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
        player.rate != 0 ? player.pause() : pressedPlayerPlay()
        //if player.rate == 0 { dismissPlayerAfterPause(inSeconds: timeBeforeDismissPopupBar) }
        setPlayedTime()
        updatePlayPauseIcons()
    }
    

    private func setAudioStreamFromMixCloud() {
        guard var strURL = mixtape?.streamURL else { return }
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        guard let streamURL = URL(string: strURL) else { return }
        
        
        
        let playerItem = AVPlayerItem(url: streamURL)
        player.replaceCurrentItem(with: playerItem)
        duration = playerItem.asset.duration
        let durationInt = Int(CMTimeGetSeconds(duration))
        
        // TRACK PLAYER PROGRESS -> Not sure it should not be here
        let interval = CMTime(value: 1, timescale: 1)
        tabBarVC.playerObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { (progressTime) in
            let progress = CMTimeGetSeconds(progressTime)
            //print("PROGRESS: ", progress)
            let totalLength = CMTimeGetSeconds(self.duration)
            let ratio = Float(progress / totalLength)
            //self.mixProgressView.setProgress(ratio, animated: true)
            self.popupItem.progress = ratio
            self.musicSlider.value = ratio
            
            let progressSecs = Int(CMTimeGetSeconds(progressTime))
            guard let elapsed = timeDuration(from: String(progressSecs)) else { return }
            self.elapsedTime.text = elapsed

            let leftTime = String(durationInt - progressSecs)
            guard let remaining = timeDuration(from: leftTime) else { return }
            self.remainingTime.text = "-" + remaining
            
            if (progress >= totalLength) {
                self.player.pause()
                self.popupPresentationContainer?.dismissPopupBar(animated: true, completion: nil)
                //self.mixProgressView.setProgress(0.0, animated: true)
                self.musicSlider.value = 0.0
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
        mixtapeCover.kf.setImage(with: URL(string: coverURL), options: [.backgroundDecode, .transition(.fade(0.2))]) {
            (image, error, cacheType, imageUrl) in
            if (image != nil) {
                self.updateMiniPlayerUI(image: image!)
                if (mix.colorBackground != nil && mix.colorDetail != nil && mix.colorPrimary != nil && mix.colorSecondary != nil) {
                    let colorsDBInHex = ColorsInHexString(background: mix.colorBackground!, primary: mix.colorPrimary!, secondary: mix.colorSecondary!, detail: mix.colorDetail!)
                    self.colors = colorsFromHexString(with: colorsDBInHex)
                } else {
                    image?.getColors(scaleDownSize: CGSize(width: 100, height: 100)){ [weak self] colors in
                        self?.colors = colors
                    }
                }
            } else {
                // IMAGE = NIL -> Something went wrong with the cover image
                // dismiss the Modal View after displaying message error to user
            }
        }
    }

    private func updateUI () {
        updatesTheThreeColors()
        updatePlayerNavButtonUI()
        updatePlayerColorsUI()
        updatePlayPauseIcons()
        updateMixcloudButtonColor()
        updatedIsFollowedMix()
        updateSixtyTextColor()
        updateMusicSliderColors()
    }
    
    private func updateMusicSliderColors() {
        musicSlider.maximumTrackTintColor = colorThree
        musicSlider.minimumTrackTintColor = colorTwo
    }
    
//    private func updateSliderThumb(color: UIColor) {
//        let positionImage = UIImage.circle(diameter: 24, color: color)
//        musicSlider.setThumbImage(positionImage, for: .normal)
//
//    }
    
    
    
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
    
    private func updateSixtyTextColor() {
        sixtyMore.textColor = colorThree
        sixtyLess.textColor = colorThree
    }
    
    private func updatePlayerNavButtonUI() {
        let fontSize = CGFloat(50.0)
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
        //mixProgressView.progressTintColor = colorTwo
        //mixProgressView.trackTintColor = colorThree
        deejayName.textColor = colorTwo
        mixtapeName.textColor = colorTwo
    }
    
//    private func updateMixcloudIconColor() {
//        let imageName = colorOne.isDarkColor ? "MixcloudWhite" : "MixcloudBlack"
//        mixcloudIcon.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
//    }
    
    private func updateMixcloudButtonColor() {
        let imageName = colorOne.isDarkColor ? "MixcloudWhite" : "MixcloudBlack"
        mixcloudButton.setImage((UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal))!, for: .normal)
        
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
        if (segue.identifier == "From PlayerView To MixCloudProfile") {
            guard let destination = segue.destination as? MixCloudProfileViewController else { return }
            guard let mcURL = mixtape?.deejay?.mcPageURL else { return }
            destination.profileURL = URL(string: mcURL)
            destination.navigationItem.title = "Mixcloud Page"
            
            
        }
    }
 

}





