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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let session = AVAudioSession.sharedInstance()
        do{
            
            try session.setActive(true)
            try session.setCategory(.playback, mode: .default, options: [ .allowAirPlay])
        } catch{
            
            print("Error12 = \(error.localizedDescription)")
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        HomeFn.shared.isBufferingCompleted = false
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
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

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "TheRadioApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

