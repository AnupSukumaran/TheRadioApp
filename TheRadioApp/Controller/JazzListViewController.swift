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
    override func viewDidLoad() {
        super.viewDidLoad()

        let path = Bundle.main.path(forResource: "JazzList", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        
        jazzName = dict!.object(forKey: "jazzName") as! [String]
        jazzAudioUrl = dict!.object(forKey: "jazzAudioUrl") as! [String]
        

       print("firstKey = \(jazzName[0]), first value = \(jazzAudioUrl[0]) ")
        
        
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
    
    
}

extension JazzListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("url = \(jazzAudioUrl[indexPath.row])")
        HomeFn.shared.audioTitle = jazzName[indexPath.row]
        HomeFn.shared.audioUrl = jazzAudioUrl[indexPath.row]
        HomeFn.shared.prepareToPlay()
        navigationController?.popViewController(animated: true)
    }
}
