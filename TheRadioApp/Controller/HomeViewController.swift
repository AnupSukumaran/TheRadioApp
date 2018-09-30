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
    @IBOutlet weak var noNetworkLB: UILabel!
    
    
    let home = HomeFn.shared
    
   // var activeIndic: NVActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // InterCheck.shared.checkConnectivity(selfVC: self)
        home.delegate = self
        home.addLoadingIndic(view: LoadingPlate)
        home.createNowPlayingAnimation(imageData: barAnimations)
        
        home.remotePlayerNotification()
        home.setupRemoteCommandCenter()
        home.setupNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        InterCheck.shared.networkNotifc(view: self) { (state) in
            switch state {
            case .hasInternet:
                    self.noNetworkLB.isHidden = true
                    print("Has Internet")
                    if !self.playButton.isSelected{
                        self.playButton.isSelected = false
                        self.home.activityIndicAndShowButton()
                   }
            case .noInternet:
                    print("Has No Internet")
                    self.noNetworkLB.isHidden = false
                    self.home.activityIndicAndHideButton()
                    self.home.player?.pause()
                    self.barAnimations.stopAnimating()
                    self.home.playerItem = nil
                    self.playButton.isSelected = false
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

        jazzTitle.text = UserDefaults.standard.value(forKey: HomeFn.jazzname) as? String ?? home.audioTitle
    
        
    }
    
    
    
  
    
    @IBAction func playAction(_ sender: UIButton) {
   
        sender.isSelected = !sender.isSelected
        print("called")
        if sender.isSelected{
            print("buttonsisSelcted = \(sender.isSelected)")
            self.home.definingPlayer()
            self.home.player?.play()
            
            
        } else {
            print("buttonsisSelcted = \(sender.isSelected)")
            self.home.player?.pause()
            self.barAnimations.stopAnimating()
        }
      
    }
    
    deinit {
        print("Deinit")
        home.deallocatedObservers()
        InterCheck.shared.removeNetworkObserver(view: self)
        NotificationCenter.default.removeObserver(self)
    }
    

}

extension HomeViewController: FunctionRemainingActionDelegate {
    func callAlertView(title: String, message: String, buttonTitle: String) {
        AlertView.showAlert(title: title, message: message, buttonTitle: buttonTitle, selfClass: self)
    }
    
    
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
   
        }
    
    func changePlayButtonState(state: Bool) {
        playButton.isSelected = !state
        playAction(playButton)
    }
    
}
