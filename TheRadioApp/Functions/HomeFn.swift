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

protocol FunctionRemainingActionDelegate: class {
    func startAnimation()
   // func stopAnimation()
}

class HomeFn: NSObject {
    
    static let shared = HomeFn()
    
    weak var delegate: FunctionRemainingActionDelegate?
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    
////    override init() {
////        super.init()
////        print("getInital")
////    }
//    override init() {
//        super.init()
//        print("Iniita;l")
//        delegate = nil
//    }
    
//    convenience init(vc: AnyObject) {
//        self.init()
//         print("Iniita;l2")
//        self.delegate = vc as! HomeViewController
//    }
    
    func definingPlayer() {
        
        if playerItem == nil {
            print("PlayerItem is Nil")
            prepareToPlay()
            
        } else {
            print("PlayerItem is Not Nil")
             delegate?.startAnimation()
        }
    }
    
    func prepareToPlay() {
        
      //  let url = URL(string:"http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio2_mf_p")
        
        //http://philae.shoutca.st:8399/autodj
        let url = URL(string:"http://185.80.220.101/1647_64")
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
        
        
        
        
        // Associate the player item with the player
        player = AVPlayer(playerItem: playerItem)
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
              
                    delegate?.startAnimation()
                

            case .failed:
                print("FailedToPlay")
       
            case .unknown:
                print("NotReadyToPlay")
            
                
            }
        }
        
        if keyPath == #keyPath(AVPlayerItem.isPlaybackLikelyToKeepUp) {
             print("bufferToPlay")
            
            delegate?.startAnimation()
           
        }
        

    }
    
    
    
    
    func createNowPlayingAnimation(imageData: UIImageView) {
        imageData.animationImages = AnimationFrames.createFrames()
        imageData.animationDuration = 0.7
    }
    
    
}
