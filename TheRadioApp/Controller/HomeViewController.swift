//
//  HomeViewController.swift
//  TheRadioApp
//
//  Created by Abraham VG on 25/09/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var barAnimations: UIImageView!
    
    let home = HomeFn.shared
   // let homeVC = HomeFn()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        home.createNowPlayingAnimation(imageData: barAnimations)
       // let homeVC = HomeFn(vc: self)
        home.delegate = self
        
    }
    
    
    @IBAction func playAction(_ sender: UIButton) {
       sender.isSelected = !sender.isSelected
       
        if sender.isSelected{
            home.definingPlayer()
            home.player?.play()
         //   barAnimations.startAnimating()
           
        } else {
            home.player?.pause()
            barAnimations.stopAnimating()
        }
        
    }
    

}

extension HomeViewController: FunctionRemainingActionDelegate {
    
//    func stopAnimation() {
//        barAnimations.stopAnimating()
//    }
//    
    func startAnimation() {
        print("DelegateCalled")
         barAnimations.startAnimating()
    }
    
   
    
    
}
