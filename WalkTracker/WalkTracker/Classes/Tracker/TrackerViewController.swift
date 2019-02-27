//
//  TrackerViewController.swift
//  WalkTracker
//
//  Created by Maria Ortega on 27/02/2019.
//  Copyright © 2019 Maria Ortega. All rights reserved.
//

import UIKit
import CoreLocation

private let reuseIdentifier = "TrackerViewCell"

class TrackerViewController: UICollectionViewController {

    // MARK: Properties
    
    var manager : TrackerManager!
    let locationManager = LocationManager.shared
    var distance = Measurement(value: 0, unit: UnitLength.meters)
    var locationList: [CLLocation] = []
    
    // MARK: Setups
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = TrackerManager(controller: self)
        manager.setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    // MARK: - IBActions
    
    @IBAction func stopTapped(_ sender: Any) {
        locationManager.stopUpdatingLocation()
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: UICollectionViewDataSource

extension TrackerViewController {
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TrackerViewCell
        return cell
    }
}

// MARK: Location Manager Delegate

extension TrackerViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                
                if distance > Measurement(value: 100, unit: UnitLength.meters){
                    // TO DO : Fetch Flickr Photo
                }
            }
            locationList.append(newLocation)
        }
    }
}

