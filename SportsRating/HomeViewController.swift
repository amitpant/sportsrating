//
//  HomeViewController.swift
//  SportsRating
//
//  Created by Maxtra Technologies P LTD on 22/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController {
    var menuCategories:[Category]?
    override func viewDidLoad() {
        super.viewDidLoad()
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor(red: 81.0/255.0, green: 116.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
}

