//
//  AlertClass.swift
//  Admission App
//
//  Created by Abraham VG on 29/08/18.
//  Copyright © 2018 Web India Solutions. All rights reserved.
//

import Foundation
import UIKit




extension UIViewController {
    
     func showAlert(title: String, message: String, buttonTitle: String, selfClass: UIViewController) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alert.addAction(action)
        
        selfClass.present(alert, animated: true, completion: nil)
        
    }
    
    
}
