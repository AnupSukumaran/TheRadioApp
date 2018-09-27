//
//  HomeViewController.swift
//  TheRadioApp
//
//  Created by Abraham VG on 25/09/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class HomeViewController: UIViewController {
    
    @IBOutlet weak var barAnimations: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var LoadingPlate: UIView!
    @IBOutlet weak var jazzTitle: UILabel!
    
    let home = HomeFn.shared
    
    var activeIndic: NVActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        home.createNowPlayingAnimation(imageData: barAnimations)
        home.delegate = self
        
         let frame = CGRect(x: 0, y: 0, width: LoadingPlate.frame.width, height: LoadingPlate.frame.height)
        
        activeIndic = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType.ballScaleRippleMultiple, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), padding: 0.0)
        
        self.LoadingPlate.addSubview(activeIndic!)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     //   jazzTitle.text = home.audioTitle
    }
    
    
    @IBAction func playAction(_ sender: UIButton) {
       sender.isSelected = !sender.isSelected
       
        if sender.isSelected{
            home.definingPlayer()
            home.player?.play()
         
           
        } else {
            home.player?.pause()
            barAnimations.stopAnimating()
        }
        
    }
    

}

extension HomeViewController: FunctionRemainingActionDelegate {
    func stopLoadingIndicator() {
        self.playButton.isHidden = false
        self.activeIndic?.stopAnimating()
    }
    
    
    func startLoadingIndicator() {
            self.playButton.isHidden = true
            self.activeIndic?.startAnimating()
    }
    
    
  
    func startAnimation() {
        print("DelegateCalled")
         barAnimations.startAnimating()
    }
    
   
    
    
}
