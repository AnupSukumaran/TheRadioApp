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
        
        jazzTitle.text = home.audioTitle
        home.createNowPlayingAnimation(imageData: barAnimations)
        home.delegate = self
        home.remotePlayerNotification()
        home.addLoadingIndic(view: LoadingPlate)
        home.setupRemoteCommandCenter()
        home.setupNotifications()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     //   jazzTitle.text = home.audioTitle
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
        home.deallocatedObservers()
        NotificationCenter.default.removeObserver(self)
    }
    

}

extension HomeViewController: FunctionRemainingActionDelegate {
    
    func startAnimatingBars(state: Bool) {
        if state {
            barAnimations.startAnimating()
        } else {
            barAnimations.stopAnimating()
        }
    }
    

        func hidePlayButton(state: Bool) {
            self.playButton.isHidden = state
        }
    
    func changePlayButtonState(state: Bool) {
        playButton.isSelected = !state
        playAction(playButton)
    }
    
}
