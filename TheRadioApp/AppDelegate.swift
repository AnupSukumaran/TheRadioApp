//
//  AppDelegate.swift
//  TheRadioApp
//
//  Created by Abraham VG on 25/09/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let dataController = DataController(modelName: "TheRadioApp")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        dataController.load()
        
        let nav = window?.rootViewController as! UINavigationController
        let homeViewController = nav.topViewController as! HomeViewController
        
        homeViewController.dataController = dataController
        
        let session = AVAudioSession.sharedInstance()
        do{
            
            try session.setActive(true)
            try session.setCategory(.playback, mode: .default, options: [ .allowAirPlay])
        } catch{
            
            print("Error12 = \(error.localizedDescription)")
        }
        return true
    }

   

    func applicationDidEnterBackground(_ application: UIApplication) {
        HomeFn.shared.isBufferingCompleted = false
    }

    

    func applicationWillTerminate(_ application: UIApplication) {
       
        UIApplication.shared.endReceivingRemoteControlEvents()
        self.saveContext()
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        super.remoteControlReceived(with: event)
        
        guard let event = event, event.type == UIEvent.EventType.remoteControl else {
            
            return
        }
        
        switch event.subtype {
        case .remoteControlPlay:
            print("Playing")
            NotificationCenter.default.post(name: NSNotification.Name("playNEW"), object: nil)
        case .remoteControlPause:
            print("Pause")
            NotificationCenter.default.post(name: NSNotification.Name("pauseNEW"), object: nil)
        case .remoteControlTogglePlayPause:
            print("TogglePlayPause")
        case .remoteControlNextTrack:
            print("NextTrack")
        case .remoteControlPreviousTrack:
            print("Previous")
        default:
            break
        }
        
    }



    func saveContext () {
        let context = dataController.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

