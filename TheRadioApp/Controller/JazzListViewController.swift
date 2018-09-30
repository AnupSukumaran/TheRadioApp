//
//  JazzListViewController.swift
//  JazzRadio
//
//  Created by Sukumar Anup Sukumaran on 27/09/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit

class JazzListViewController: UIViewController {
    
    
    @IBOutlet weak var jazzTableView: UITableView!
    
    var jazzName = [String]()
    var jazzAudioUrl = [String]()
    let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
    override func viewDidLoad() {
        super.viewDidLoad()

        let path = Bundle.main.path(forResource: "JazzList", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        
        jazzName = dict!.object(forKey: "jazzName") as! [String]
        jazzAudioUrl = dict!.object(forKey: "jazzAudioUrl") as! [String]
        

       print("firstKey = \(jazzName[0]), first value = \(jazzAudioUrl[0]) ")
        
        
            // 2. check the idiom
        
        
    }

}

extension JazzListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jazzName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JazzListTableViewCell", for: indexPath) as! JazzListTableViewCell
        
        cell.jazzLabel.text = jazzName[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch (deviceIdiom) {
            
        case .pad:
            return 100
        case .phone:
            return 60
   
        default:
            return 60
            
        }
       
    }
    
    
}

extension JazzListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("url = \(jazzAudioUrl[indexPath.row])")
        HomeFn.shared.audioTitle = jazzName[indexPath.row]
        let jazzN = jazzName[indexPath.row]
        UserDefaults.standard.set(jazzN, forKey: HomeFn.jazzname)
        HomeFn.shared.audioUrl = jazzAudioUrl[indexPath.row]
        let jazzurl = jazzAudioUrl[indexPath.row]
        UserDefaults.standard.set(jazzurl, forKey: HomeFn.jazzurl)
        
        HomeFn.shared.definingFromTable()
        navigationController?.popViewController(animated: true)
    }
}
