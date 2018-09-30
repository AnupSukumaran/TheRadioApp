//
//  HomeViewController.swift
//  TheRadioApp
//
//  Created by Abraham VG on 25/09/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit
//import NVActivityIndicatorView

class HomeViewController: UIViewController {
    
    @IBOutlet weak var barAnimations: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var LoadingPlate: UIView!
    @IBOutlet weak var jazzTitle: UILabel!
    
    
    let home = HomeFn.shared
    
   // var activeIndic: NVActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        home.delegate = self
        home.addLoadingIndic(view: LoadingPlate)
        home.createNowPlayingAnimation(imageData: barAnimations)
        
        home.remotePlayerNotification()
        home.setupRemoteCommandCenter()
        home.setupNotifications()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        guard let audioName = UserDefaults.standard.value(forKey: HomeFn.jazzname) as? String else {jazzTitle.text = home.audioTitle;print("audioName😩");return}
        jazzTitle.text = UserDefaults.standard.value(forKey: HomeFn.jazzname) as? String ?? home.audioTitle
    
        
    }
    
    
    
    
    
    
    @IBAction func playAction(_ sender: UIButton) {
       sender.isSelected = !sender.isSelected
       print("called")
        if sender.isSelected{
            print("buttonsisSelcted = \(sender.isSelected)")
            home.definingPlayer()
            home.player?.play()
            
           
        } else {
              print("buttonsisSelcted = \(sender.isSelected)")
            home.player?.pause()
            barAnimations.stopAnimating()
        }
        
    }
    
    deinit {
        print("Deinit")
        home.deallocatedObservers()
        NotificationCenter.default.removeObserver(self)
    }
    

}

extension HomeViewController: FunctionRemainingActionDelegate {
    
    func startAnimatingBars(state: Bool) {
        if state, playButton.isSelected {
            barAnimations.startAnimating()
            print("StartedBarAnimating")
        } else {
            barAnimations.stopAnimating()
            print("StoppedBarAnimating")
        }
    }
    

        func hidePlayButton(state: Bool) {
            self.playButton.isHidden = state
//            if state {
//                
//            } else {
//                print("ActivityStopped ")
//              //  home.activeIndic?.stopAnimating()
//            }
            
        }
    
    func changePlayButtonState(state: Bool) {
        playButton.isSelected = !state
        playAction(playButton)
    }
    
}
