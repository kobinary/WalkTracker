//
//  TrackerViewController.swift
//  WalkTracker
//
//  Created by Maria Ortega on 27/02/2019.
//  Copyright © 2019 Maria Ortega. All rights reserved.
//

import UIKit

private let reuseIdentifier = "TrackerViewCell"

class TrackerViewController: UICollectionViewController {

    // MARK: Properties
    
    var manager : TrackerManager!
    
    // MARK: Setups
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = TrackerManager(controller: self)
        manager.setupView()
    }
}

extension TrackerViewController {
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
    
}

