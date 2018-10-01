//
//  HomeFn+Extension2.swift
//  JazzRadio
//
//  Created by Sukumar Anup Sukumaran on 01/10/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import Foundation
import MediaPlayer
import NVActivityIndicatorView

extension HomeFn {
    
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
}
