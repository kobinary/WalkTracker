//
//  HomeViewController.swift
//  WalkTracker
//
//  Created by Maria Ortega on 27/02/2019.
//  Copyright © 2019 Maria Ortega. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: Properties
    
    var manager : HomeManager!
    
    // MARK: Setups
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = HomeManager(controller: self)
        manager.setupView()
    }
}
