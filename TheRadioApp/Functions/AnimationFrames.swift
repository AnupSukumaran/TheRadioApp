//
//  AnimationFrames.swift
//  Orthodox Radio
//
//  Created by Sukumar Anup Sukumaran on 09/03/18.
//  Copyright © 2018 AssaRadviewTech. All rights reserved.
//

import Foundation
import UIKit

class AnimationFrames {
    
     static func createFrames() -> [UIImage] {
        
        var animationFrames = [UIImage]()
        
        for i in 0...3 {
            
            if let image = UIImage(named: "NowPlayingBars-\(i)") {
                animationFrames.append(image)
            }
            
        }
        
        for i in stride(from: 2, to: 0, by: -1) {
            if let image = UIImage(named: "NowPlayingBars-\(i)") {
                animationFrames.append(image)
            }
        }
        
        return animationFrames
        
    }
    
    
}
