//
//  HomeFn+Extension.swift
//  JazzRadio
//
//  Created by Sukumar Anup Sukumaran on 01/10/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import Foundation
import UIKit

extension HomeFn {
    
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
        settingNotificationForRemote(key: "playNEW", callfunc: true, playBT: true, barAnim: true, isbufferingComp: true)
         settingNotificationForRemote(key: "pauseNEW", callfunc: false, playBT: false, barAnim: false, isbufferingComp: true)

    }
    

    
    func settingNotificationForRemote( key: String, callfunc: Bool, playBT: Bool, barAnim: Bool, isbufferingComp: Bool ) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(key), object: nil, queue: nil) { (notification) in
            
            if callfunc { self.activityIndicAndShowButton() }
            self.delegate?.changePlayButtonState(state: playBT)
            self.delegate?.startAnimatingBars(state: barAnim)
            self.isBufferingCompleted = isbufferingComp
        
        }
    }
    
}
