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
    
    static var jazzname = "jazzname"
    static var jazzurl = "jazzurl"
    var audioTitle = "The Jazzmas Channel"
    var audioUrl = "http://185.80.220.101/1647_64"
    var tempAudioUrl = ""
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    var activeIndic: NVActivityIndicatorView?
    var isObserving = false
    var isBufferingCompleted = false
    
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
                
//                self.player?.pause()
//                self.delegate?.changePlayButtonState(state: false)
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
        if tempAudioUrl == audioUrl {
            print("Not changed")
          
        } else {
            
           // savedUrlsfunc()
            tempAudioUrl = UserDefaults.standard.value(forKey: HomeFn.jazzurl) as? String ?? audioUrl
            playerItem = nil
            activityIndicAndShowButton()
            delegate?.startAnimatingBars(state: false)
            delegate?.changePlayButtonState(state: true)
            print("urlChanging")
        }
    }
    
//    //MARK: Getting the saved URL if not the other url
//    func savedUrlsfunc() {
//        if let savedAudioUrl = UserDefaults.standard.value(forKey: HomeFn.jazzurl) as? String {
//            
//            tempAudioUrl = savedAudioUrl
//            playerItem = nil
//            activityIndicAndShowButton()
//            delegate?.startAnimatingBars(state: false)
//            delegate?.changePlayButtonState(state: true)
//            print("savedurlChanging")
//            
//        } else {
//            tempAudioUrl = audioUrl
//            playerItem = nil
//            activityIndicAndShowButton()
//            delegate?.startAnimatingBars(state: false)
//            delegate?.changePlayButtonState(state: true)
//            print("urlChanging")
//            
//        }
//    }
//    
    func definingPlayer() {
        tempAudioUrl = UserDefaults.standard.value(forKey: HomeFn.jazzurl) as? String ?? audioUrl
      //  tempAudioUrl = audioUrl
        if playerItem == nil {
             print("PlayerItem is Nil")
            activityIndicAndHideButton()
            prepareToPlay()
            
        } else {
            print("PlayerItem is Not Nil")
           
            if !isBufferingCompleted {
                print("BufferingIsNotcompleted")
                activityIndicAndHideButton()
                delegate?.startAnimatingBars(state: false)
            } else {
                 delegate?.startAnimatingBars(state: true)
            }
            //activityIndicAndHideButton()
        }
    }
    
    func prepareToPlay() {
        
      
        let url = URL(string: tempAudioUrl)
        let asset = AVAsset(url: url!)
        
        let assetKeys = ["playable", "hasProtectedContent" ]
     
        playerItem = AVPlayerItem(asset: asset,
                                  automaticallyLoadedAssetKeys: assetKeys)
        
        if let pItem =  playerItem {
            print("Assigning Notifcations")
            pItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: nil)
            pItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackBufferEmpty), options: [.old, .new], context: nil)
            pItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackLikelyToKeepUp), options: [.old, .new], context: nil)
            pItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.timedMetadata), options: [.old, .new], context: nil)
        }

        player = AVPlayer(playerItem: playerItem)
        isObserving = true
    }
    
    //MARK: Deallocating Observers
    func deallocatedObservers() {
        print("DELLOCdd")
        if let item = playerItem {
            print("DELLOC")
            
            if isObserving {
                item.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
                item.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackBufferEmpty))
                item.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackLikelyToKeepUp))
                item.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.timedMetadata))
            }
            isObserving = false
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
             print("KeyPath - isPlaybackLikelyToKeepUp")
            delegate?.startAnimatingBars(state: true)
            
            isBufferingCompleted = true
            
            activityIndicAndShowButton()
        }
        

    }
    
    func activityIndicAndHideButton() {
        print("Activit Started")
        activeIndic?.startAnimating()
        delegate?.hidePlayButton(state: true)
    }
    
    func activityIndicAndShowButton() {
        print("Activit Stopped")
        
        activeIndic?.stopAnimating()
        delegate?.hidePlayButton(state: false)
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
