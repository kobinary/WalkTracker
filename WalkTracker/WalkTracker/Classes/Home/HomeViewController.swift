//
//  HomeViewController.swift
//  WalkTracker
//
//  Created by Maria Ortega on 27/02/2019.
//  Copyright © 2019 Maria Ortega. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: Setups
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setupNavigationItems()
    }
    
    private func setupNavigationItems() {
        navigationItem.titleView = LogoHelper().setupLogo()
    }
}
