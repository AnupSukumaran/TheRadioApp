//
//  HomeFn.swift
//  TheRadioApp
//
//  Created by Sukumar Anup Sukumaran on 25/09/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import NVActivityIndicatorView
import MediaPlayer

protocol FunctionRemainingActionDelegate: class {
    func startAnimatingBars(state: Bool)
    func changePlayButtonState(state: Bool)
    func hidePlayButton(state: Bool)
}

class HomeFn: NSObject {
    
    static let shared = HomeFn()
    
    weak var delegate: FunctionRemainingActionDelegate?
    
    var audioTitle = "The Jazzmas Channel"
    var audioUrl = "http://185.80.220.101/1647_64"
    var tempAudioUrl = ""
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    var activeIndic: NVActivityIndicatorView?
    
    
    
    //MARK: Setup Remote Plaer
    func setupRemoteCommandCenter() {
        
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { event in
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { event in
            return .success
        }
    }
    
    //MARK: Adding Notifications for
    func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    @objc private func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                return
        }
        
        switch type {
        case .began:
            DispatchQueue.main.async {
                print("Found1😃😄😁")
                self.player?.pause()
                self.delegate?.changePlayButtonState(state: false)
//                self.playButton.isSelected = false
//                self.NowPlayingAnimation.stopAnimating()
                // self.pause()
                
            }
        case .ended:
            guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { break }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            DispatchQueue.main.async {
                print("Hello1234😁")
                options.contains(.shouldResume) ? print("self.play()") : print("self.pause()") }
        }
    }
    
    
    
    //MARK: Adding NVActivityIndicatorView Loading View
    func addLoadingIndic(view: UIView) {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        activeIndic = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType.ballScaleRippleMultiple, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), padding: 0.0)
        view.addSubview(activeIndic!)
    }
    

    func definingFromTable() {
        if audioUrl == tempAudioUrl {
            print("Not changed")
          
        } else {
              tempAudioUrl = audioUrl
            playerItem = nil
             delegate?.startAnimatingBars(state: false)
            delegate?.changePlayButtonState(state: true)
             print("urlChanging")
        }
    }
    
    func definingPlayer() {
        
        tempAudioUrl = audioUrl
        if playerItem == nil {
            activeIndic?.startAnimating()
            delegate?.hidePlayButton(state: true)
            prepareToPlay()
            
        } else {
            print("PlayerItem is Not Nil")
            delegate?.startAnimatingBars(state: true)
        }
    }
    
    func prepareToPlay() {
        
      //  let url = URL(string:"http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio2_mf_p")
        
        //http://185.80.220.101/1647_64 -  The Jazzmas Channel
        //http://listen.011fm.com/stream27   - Holiday Jazz
        //http://192.232.192.96:9978/stream    - Jazz Blues Soul
        //http://185.80.220.101/1radio_smoothjazz_128    - The Wave Smooth Jazz
        //http://bigrradio.cdnstream1.com/5127_128    - The Vocal Jazz Channel
        //http://listen.57fm.com/toj    - A Taste of Jazz
        //http://allzic40.ice.infomaniak.ch/allzic40.mp3    -  Allzic - Jazz
        let url = URL(string: audioUrl)
        let asset = AVAsset(url: url!)
        
        let assetKeys = ["playable", "hasProtectedContent" ]
     
        playerItem = AVPlayerItem(asset: asset,
                                  automaticallyLoadedAssetKeys: assetKeys)
        
        if let pItem =  playerItem {
            pItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: nil)
            pItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackBufferEmpty), options: [.old, .new], context: nil)
            pItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackLikelyToKeepUp), options: [.old, .new], context: nil)
            pItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.timedMetadata), options: [.old, .new], context: nil)
        }

        player = AVPlayer(playerItem: playerItem)
    }
    
    //MARK: Deallocating Observers
    func deallocatedObservers() {
        print("DELLOCdd")
        if let item = playerItem {
            print("DELLOC")
            item.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
            item.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackBufferEmpty))
            item.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackLikelyToKeepUp))
            item.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.timedMetadata))
        }
        
        
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            switch status {
            case .readyToPlay:
                print("ReadyToPlay")
              
                delegate?.startAnimatingBars(state: true)
                

            case .failed:
                print("FailedToPlay")
       
            case .unknown:
                print("NotReadyToPlay")
            
                
            }
        }
        
        if keyPath == #keyPath(AVPlayerItem.isPlaybackLikelyToKeepUp) {
             print("bufferToPlay")
            delegate?.startAnimatingBars(state: true)
            activeIndic?.stopAnimating()
            delegate?.hidePlayButton(state: false)
        }
        

    }
    
    
    
    
    func createNowPlayingAnimation(imageData: UIImageView) {
        imageData.animationImages = AnimationFrames.createFrames()
        imageData.animationDuration = 0.7
    }
    
    //MARK: Add Notifications for remote Player
    func remotePlayerNotification() {
        addNotificationToPlay()
        addNotificationToPause()
    }
    
    func addNotificationToPlay() {
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("playNEW"), object: nil, queue: nil) { (notification) in
            
            self.delegate?.changePlayButtonState(state: true)
            self.delegate?.startAnimatingBars(state: true)
            print("playIT")
        }
        
    }
    
    func addNotificationToPause() {
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("pauseNEW"), object: nil, queue: nil) { (notification) in
            
            self.delegate?.changePlayButtonState(state: false)
            self.delegate?.startAnimatingBars(state: false)
            print("pauseIT")
            
        }
        
    }
    
    
}
