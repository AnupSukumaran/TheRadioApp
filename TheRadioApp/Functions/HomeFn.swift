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

import CoreData

protocol FunctionRemainingActionDelegate: class {
    func startAnimatingBars(state: Bool)
    func changePlayButtonState(state: Bool)
    func hidePlayButton(state: Bool)
    func callAlertView(title: String, message: String, buttonTitle: String)
}

class HomeFn: NSObject {
    
    static let shared = HomeFn()
    var dataController: DataController!
    
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
    
    var jazzModel:JazzModel?
    
    func saveJazzDataToCore(jazzTitle: String, jazzAudioUrl: String) {
        
        let jazzModel = JazzModel(context: dataController.viewContext)
        print("jazzTitle = \(jazzTitle)")
        jazzModel.jazzTitle = jazzTitle
        jazzModel.jazzAudioUrl = jazzAudioUrl
        saved()
    }
    
    
    func saved() {
        if dataController.viewContext.hasChanges {
            do{
                try dataController.viewContext.save()
                definingFromTable()
                print("Saved jazz😛 ")
            }catch let error{
                print(" Error😩 = \(error.localizedDescription)")
            }
        } else {
            print("No Changes in nsmanagedobjectcontext")
        }
        
    }
    
    func clearDataInCore() {
          let fetchRequest: NSFetchRequest<JazzModel> = JazzModel.fetchRequest()
        if let results = try? dataController.viewContext.fetch(fetchRequest) {
            print("fetchCompleted")
            let _ = results.map{dataController.viewContext.delete($0)}
            print("clearData")
            saved()
            
        } else {print("failedFetching😩")}
    }
    
    func fetchRequest() {
        // let vc = selfClass as! TravelLocationsMapViewController
        
        let fetchRequest: NSFetchRequest<JazzModel> = JazzModel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "jazzTitle", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let results = try? dataController.viewContext.fetch(fetchRequest) {
            print("fetchCompleted")
           // guard let jazzM = results.first else {print("jazzM😩");return}
            jazzModel = results.first
            
        } else {print("failedFetching😩")}
    }
    

    func definingFromTable() {
        print("jazzTitleCore = \(jazzModel?.jazzTitle ?? "No Title Found")")
        if tempAudioUrl == audioUrl {
            print("Not changed")
          
        } else {
            

            tempAudioUrl = jazzModel?.jazzAudioUrl ?? audioUrl
            playerItem = nil
            activityIndicAndShowButton()
            delegate?.startAnimatingBars(state: false)
            delegate?.changePlayButtonState(state: true)
            print("urlChanging")
        }
    }
    

    func definingPlayer() {

         tempAudioUrl = jazzModel?.jazzAudioUrl ?? audioUrl
        if playerItem == nil {
             print("PlayerItem is Nil")
            self.activityIndicAndHideButton()
            prepareToPlay()
            
        } else {
            print("PlayerItem is Not Nil")
           
            if !isBufferingCompleted {
                print("BufferingIsNotcompleted")
                self.activityIndicAndHideButton()
                delegate?.startAnimatingBars(state: false)
            } else {
                print("BufferingIscompleted")
                 delegate?.startAnimatingBars(state: true)
            }
           
        }
    }
    
    
    func prepareToPlay() {
        
        guard let url = URL(string: tempAudioUrl) else {
            delegate?.callAlertView(title: "Station Not Available!!", message: "Please try another station", buttonTitle: "OK")
            return
        }
        
        let asset = AVAsset(url: url)
        
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
                print("Status Unknown2")
            } else {
                status = .unknown
                print("Status Unknown")
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
    
   
    
}
