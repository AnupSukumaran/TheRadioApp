//
//  InternetConnectiviy.swift
//  Admission App
//
//  Created by Abraham VG on 28/08/18.
//  Copyright © 2018 Web India Solutions. All rights reserved.
//

import Foundation
import Reachability
import UIKit

enum States {
    case hasInternet
    case noInternet
}

class InterCheck {
    
    static var shared = InterCheck()
    
    var reachability = Reachability()
    
    
    func checkConnectivity(selfVC: UIViewController, completionBlk: (() -> Void)? = nil ) {

        if reachability?.connection == nil {
            AlertView.showAlert(title: "Internet Connection is not available", message: "Please check your internet connection and try again.", buttonTitle: "OK", selfClass: selfVC)
        } else {
            print("Yay! Internet Connection")
            completionBlk?()
        }
       
        
//        guard reachability.isInternetAvailable() else {
//            AlertView.showAlert(title: "Internet Connection is not available", message: "Please check your internet connection and try again.", buttonTitle: "OK", selfClass: selfVC)
//            return
//
//        }

//        DispatchQueue.main.async {
//            AlertView.showAlert(title: "Internet Connection is not available", message: "Please check your internet connection and try again.", buttonTitle: "OK", selfClass: selfVC)
//           // CommonFunc.shared.removeNoDataSubView(selfVC: selfVC)
//        }
//
       

    }

    func networkNotifc(view: UIViewController, completion: @escaping(States) -> () ) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.reachabilityChanged, object: reachability, queue: nil) { (note) in
            
            let reachability = note.object as! Reachability
            
            if reachability.connection != .none {
                
                if reachability.connection == .wifi {
                    print("Reachable via WiFi")
                   
                } else {
                    print("Reachable via Cellular")
                   
                }
                completion(.hasInternet)
                
            } else {
                completion(.noInternet)
                print("Network not reachable")
                AlertView.showAlert(title: "Internet Connection is not available", message: "Please check your internet connection and try again.", buttonTitle: "OK", selfClass: view)
            }
            
        }
//        NotificationCenter.default.addObserver(view, selector: #selector(reachabilityChanged),name: Notification.Name.reachabilityChanged,object: reachability)
        do{
            try reachability!.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
//    @objc func reachabilityChanged(note: NSNotification, view: UIViewController) {
//        
//        let reachability = note.object as! Reachability
//        
//        if reachability.connection != .none {
//            if reachability.connection == .wifi {
//                print("Reachable via WiFi")
//            } else {
//                print("Reachable via Cellular")
//            }
//        } else {
//            print("Network not reachable")
//           AlertView.showAlert(title: "Internet Connection is not available", message: "Please check your internet connection and try again.", buttonTitle: "OK", selfClass: view)
//        }
//    }
    
    func removeNetworkObserver(view: UIViewController) {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: reachability)
    }
    
}
