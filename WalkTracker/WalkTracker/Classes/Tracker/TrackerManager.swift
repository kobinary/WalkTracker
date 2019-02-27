//
//  TrackerManager.swift
//  WalkTracker
//
//  Created by Maria Ortega on 27/02/2019.
//  Copyright © 2019 Maria Ortega. All rights reserved.
//

import UIKit

class TrackerManager: NSObject {

    // MARK: Properties
    
    var controller : TrackerViewController!
    
    // MARK: Init
    
    override init() {
        super.init()
    }
    
    init(controller: TrackerViewController) {
        self.controller = controller
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("Not meant to be initialised this way")
    }
    
    // MARK: Setups
    
    func setupView() {
        setupNavigationItems()
    }
    
    func setupNavigationItems() {
        controller.navigationItem.titleView = LogoHelper().setupLogo()
        controller.navigationItem.setHidesBackButton(true, animated:true);
    }
    
}
